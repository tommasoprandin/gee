with System.Tasking.Protected_Objects;
with Task_Metrics;

package body Activation_Log is
   protected body Activation_Log is
      procedure Write is
      begin
			Task_Metrics.Start_Tracking;
         Activation_Counter := Activation_Counter + 1;
         Activation_Time := Ada.Real_Time.Clock;
			Task_Metrics.End_Tracking ("AL Write");
      end Write;
      procedure Read (Last_Activation  : out Range_Counter;
                      Last_Active_Time : out Ada.Real_Time.Time) is
      begin
			Task_Metrics.Start_Tracking;
         Last_Activation := Activation_Counter;
         Last_Active_Time := Activation_Time;
			Task_Metrics.End_Tracking ("AL Read");
      end Read;
   end Activation_Log;
begin
   System.Tasking.Protected_Objects.Initialize_Protection_Deadline
     (System.Tasking.Protected_Objects.Current_Object, 18000000); -- 0.1 * 180Mhz
end Activation_Log;
