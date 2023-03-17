trigger Event_Trigger on Event (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete,
    after undelete) {
        Email_Event_Helper emailHandler= new Email_Event_Helper(Trigger.new);
         if (Trigger.isBefore) {
             if (Trigger.isInsert) {
                 emailHandler.beforeInsert();
             }  
             
       }
    }