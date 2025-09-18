with Event_Queue;
with Activation_Manager;
with Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Real_Time;
with System;
with System.BB.Time;
with System.BB.Threads; use System.BB.Threads;
with System.BB.Threads.Queues; use System.BB.Threads.Queues;
with External_Event_Server_Parameters; use External_Event_Server_Parameters;

package body External_Event_Server is
   use System.BB.Time;

   Release_Time: System.BB.Time.Time := System.BB.Time.Time'First;

   procedure Mark_Activation_Time is
   begin
      if Release_Time = System.BB.Time.Time'First then
         Release_Time := System.BB.Time.Clock;
      end if;
   end Mark_Activation_Time;

   procedure Wait renames Event_Queue.Handler.Wait;
   task body External_Event_Server is
      --  for tasks to achieve simultaneous activation
      Next_Time : Ada.Real_Time.Time := Activation_Manager.Get_Activation_Time;
      Release_Jitter : System.BB.Time.Time_Span;
      Response_Time : System.BB.Time.Time_Span;
   begin
      --  Setting artificial deadline
      Set_Starting_Time (Activation_Manager.Time_Conversion (Next_Time));
      Set_Relative_Deadline (System.BB.Time.Milliseconds (External_Event_Server_Deadline));
      Set_Fake_Number_ID (4);

      delay until Next_Time;
      System.BB.Threads.Queues.Initialize_Task_Table (4, True);
      loop
         --  suspending request for external activation event
         Wait;
         Release_Jitter := System.BB.Time.Clock - Release_Time;
         --  non-suspending operation code
         Server_Operation;
         Response_Time := System.BB.Time.Clock - Release_Time;
         -- Reset to sentinel value to reinit at next activation
         Release_Time := System.BB.Time.Time'First;
         Change_Jitters(Running_Thread, Response_Time, Release_Jitter);
      end loop;
   exception
      when Error : others =>
         --  last rites: for example
         Ada.Text_IO.Put_Line
           ("EES: Something has gone wrong here: " & Exception_Information (Error));
   end External_Event_Server;
end External_Event_Server;
