with Production_Workload;
with Ada.Text_IO;
with Task_Metrics;

package body On_Call_Producer_Parameters is
   procedure On_Call_Producer_Operation (Load : Positive) is
   begin
      --  we execute the required amount of excess workload
      Task_Metrics.Start_Tracking;
      Production_Workload.Small_Whetstone (Load);
      Task_Metrics.End_Tracking ("OCP Small Whetstone");
      --  then we report nominal completion of current activation
		Task_Metrics.Start_Tracking;
      Ada.Text_IO.Put_Line ("End of sporadic activation.                       ");
		Task_Metrics.End_Tracking ("OCP Put Line");
   end On_Call_Producer_Operation;
end On_Call_Producer_Parameters;
