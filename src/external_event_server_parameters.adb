
with Activation_Log;
with Task_Metrics;
package body External_Event_Server_Parameters is
   procedure Server_Operation is
   begin
      --  we record an entry in the Activation_Log buffer
		Task_Metrics.Start_Tracking;
      Activation_Log.Write;
		Task_Metrics.End_Tracking ("EES AL Write");
   end Server_Operation;
end External_Event_Server_Parameters;
