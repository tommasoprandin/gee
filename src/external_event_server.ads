with External_Event_Server_Parameters;
package External_Event_Server is
   procedure Mark_Activation_Time;
   task External_Event_Server
     with Priority =>
       External_Event_Server_Parameters.External_Event_Server_Priority;
end External_Event_Server;
