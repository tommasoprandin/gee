with On_Call_Producer;
with Production_Workload;
with Activation_Log_Reader;
with Auxiliary;
with Ada.Text_IO;
with Task_Metrics;
with Ada.Real_Time;

package body Regular_Producer_Parameters is
   use Ada.Real_Time;

   --  approximately 5,001,000 processor cycles of Whetstone load
   --  on an ERC32 (a radiation-hardened SPARC for space use) at 10 Hz
   Regular_Producer_Workload : constant Positive := Positive (756 * 25.38);
   --  approximately 2,500,500 processor cycles
   On_Call_Producer_Workload : constant Positive := Positive (278 * 69.97);
   --  the parameter used to query the condition
   --  for the activation of On_Call_Producer
   Activation_Condition : constant Auxiliary.Range_Counter := 2;
	procedure Regular_Producer_Operation is
		due_activation : Boolean := False;
		check_due : Boolean := False;
	begin
      Task_Metrics.Start_Tracking;
      --  we execute the guaranteed level of workload
      Production_Workload.Small_Whetstone (Regular_Producer_Workload);
      Task_Metrics.End_Tracking ("RP Small Whetstone");
      --  then we check whether we need to farm excess load out to
      --  On_Call_Producer
		Task_Metrics.Start_Tracking;
		due_activation := Auxiliary.Due_Activation (Activation_Condition);
		Task_Metrics.End_Tracking ("RP Due Activation");
		Task_Metrics.Start_Tracking;
		check_due := Auxiliary.Check_Due;
		Task_Metrics.End_Tracking ("RP Check Due");
      if due_activation then
         --  if yes, then we issue the activation request with a parameter
         --  that determines the workload request
			Task_Metrics.Start_Tracking;
         if not On_Call_Producer.Start (On_Call_Producer_Workload) then
            --  we capture and report failed activation
            Ada.Text_IO.Put_Line ("Failed sporadic activation.");
         end if;
			Task_Metrics.End_Tracking ("RP OCP Activation");
      end if;
      --  we check whether we need to release Activation_Log
      if check_due then
			Task_Metrics.Start_Tracking;
         Activation_Log_Reader.Signal;
			Task_Metrics.End_Tracking ("RP ALR Signal");
      end if;
      --  finally we report nominal completion of the current activation
      Ada.Text_IO.Put_Line ("End of cyclic activation.                         ");
   end Regular_Producer_Operation;
end Regular_Producer_Parameters;
