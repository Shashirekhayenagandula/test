trigger InvoiceDeletion on Match_Maker__Invoice__c (before delete) {
   /*  set<id>lineIds = new set<id>();
    list<Match_Maker__Invoice_Line_Item__c>lineItem = new list<Match_Maker__Invoice_Line_Item__c>();
    for(Match_Maker__Invoice__c inv :trigger.old){
        lineIds.add(inv.Id);
    } system.debug('inninnnn'+lineIds);
		
    for(Match_Maker__Invoice_Line_Item__c li : [select id,Name,Match_Maker__Invoice__r.Id From Match_Maker__Invoice_Line_Item__c where Match_Maker__Invoice__r.Id IN :lineIds]){
        lineItem.add(li);
    }
    delete lineItem; system.debug('delete---' + lineItem); */
    
    
    List<Match_Maker__Invoice_Line_Item__c> line = [SELECT id,name,Match_Maker__Invoice__r.Id FROM Match_Maker__Invoice_Line_Item__c WHERE Match_Maker__Invoice__r.Id IN:Trigger.OldMap.keyset()];
        delete line;
    /* InvoiceDeletionTriggerClass deleteInvoiceHandler =new InvoiceDeletionTriggerClass(Trigger.new);
   
    if (Trigger.isBefore) {
        if (before delete) {
            deleteInvoiceHandler.Deletion();
        } 
       
    }*/
    
}