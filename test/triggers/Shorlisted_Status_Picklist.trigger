trigger Shorlisted_Status_Picklist on Match_Maker__Shortlisted_Contact__c (before insert, after insert, before update, after update, before delete, after delete,after undelete) 
{
    Shortlisted_Status_Trigger_class shortlistedProfileHandler =new Shortlisted_Status_Trigger_class(Trigger.new);
   
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            shortlistedProfileHandler.updateStatus();
        } 
        if (Trigger.isUpdate) {
           shortlistedProfileHandler.updateStatus();
        }
    }
}