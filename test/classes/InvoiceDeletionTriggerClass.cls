public with sharing class InvoiceDeletionTriggerClass {
    public void Deletion()
    {
         List<Match_Maker__Invoice_Line_Item__c> line = [SELECT id,name,Match_Maker__Invoice__r.Id FROM Match_Maker__Invoice_Line_Item__c WHERE Match_Maker__Invoice__r.Id IN:Trigger.OldMap.keyset()];
        delete line;
    }
    

}