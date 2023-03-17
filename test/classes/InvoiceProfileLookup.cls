public with sharing class InvoiceProfileLookup {
    //1st lookup mthd
      @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName ,string contactId) {    
        system.debug('contactId'+contactId);
        List < sObject > returnList = new List < sObject > ();
        string sWildCardText = '%' + searchKey + '%';
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText and Match_Maker__Contact__c=:contactId order by createdDate DESC';
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        system.debug('result'+returnList);
        return returnList;
        
    }
    
      //item prepopulate      
 @AuraEnabled(cacheable=true)
    Public Static Match_Maker__Item_Master__c getItemMasterItem(String itemId){
        system.debug('itemId'+itemId);
         Match_Maker__Item_Master__c im =[select id,Name,Match_Maker__Rate__c,Match_Maker__Tax__c from Match_Maker__Item_Master__c where id=:itemId WITH SECURITY_ENFORCED];
      
       return im;
    }    
    
       //insert
   @AuraEnabled
    Public Static string insertInvoice(List<Match_Maker__Invoice_Line_Item__c> lineItems , Match_Maker__Invoice__c invoc ,string prof){
        //INSERT invoc;
       Match_Maker__Invoice__c invsv= new Match_Maker__Invoice__c();
       
        invsv.Match_Maker__Full_Name__c=invoc.Match_Maker__Full_Name__c;
        invsv.Match_Maker__Contact__c=invoc.Match_Maker__Contact__c;
        invsv.Match_Maker__Profile__c=prof;
        invsv.Match_Maker__Phone__c=invoc.Match_Maker__Phone__c;  
        invsv.Match_Maker__Email__c=invoc.Match_Maker__Email__c;
        invsv.Match_Maker__Date__c=system.today();
         DateTime dt = DateTime.now();
        invsv.Match_Maker__Time__c=Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
        invsv.Match_Maker__Payment_Method__c=invoc.Match_Maker__Payment_Method__c;     
        invsv.Match_Maker__Payment_Status__c=invoc.Match_Maker__Payment_Status__c;
        invsv.Match_Maker__Line_Item_Count__c=invoc.Match_Maker__Line_Item_Count__c;
        invsv.Match_Maker__Address__Street__s=invoc.Match_Maker__Address__Street__s;
        invsv.Match_Maker__Address__City__s=invoc.Match_Maker__Address__City__s;
        invsv.Match_Maker__Address__StateCode__s=invoc.Match_Maker__Address__StateCode__s;
        invsv.Match_Maker__Address__PostalCode__s=invoc.Match_Maker__Address__PostalCode__s;
        invsv.Match_Maker__Address__CountryCode__s='IN';
        invsv.Match_Maker__Total_Amount__c=invoc.Match_Maker__Total_Amount__c;
        invsv.Match_Maker__Total_Tax_Amount__c=invoc.Match_Maker__Total_Tax_Amount__c;
        invsv.Match_Maker__Total_Discount_Amount__c=invoc.Match_Maker__Total_Discount_Amount__c;
        invsv.Match_Maker__Net_Invoice_Amount__c=invoc.Match_Maker__Net_Invoice_Amount__c;
        if(Schema.sObjectType.Match_Maker__Invoice__c.isCreateable()){
             insert invsv;
        }
        
           
        List<Match_Maker__Invoice_Line_Item__c> lstiv = new list<Match_Maker__Invoice_Line_Item__c>();
        String invocId = invoc.id;  system.debug('invoice  record' +invocId);
        for(Match_Maker__Invoice_Line_Item__c inv : lineItems)
       {
           Match_Maker__Invoice_Line_Item__c sinv = new Match_Maker__Invoice_Line_Item__c();
           
            sinv.Match_Maker__Invoice__c = invsv.id;
            sinv.Match_Maker__Items__c=inv.Match_Maker__Items__c;
            sinv.Match_Maker__Amount__c=inv.Match_Maker__Amount__c;
            sinv.Match_Maker__Discount__c=inv.Match_Maker__Discount__c;
            sinv.Match_Maker__Discount_Amount__c=inv.Match_Maker__Discount_Amount__c;
            sinv.Match_Maker__Line_Item_Total__c=inv.Match_Maker__Line_Item_Total__c;
            sinv.Match_Maker__Line_Total__c=inv.Match_Maker__Line_Total__c;
            sinv.Match_Maker__Line_Total_After_Discount__c=inv.Match_Maker__Line_Total_After_Discount__c;
            sinv.Match_Maker__Quantity__c=inv.Match_Maker__Quantity__c;
            sinv.Match_Maker__Taxs__c=inv.Match_Maker__Taxs__c;
            sinv.Match_Maker__Tax_Amount__c=inv.Match_Maker__Tax_Amount__c;
           lstiv.add(sinv);
           system.debug('lstiv=='+lstiv);
       }
        if(Schema.sObjectType.Match_Maker__Invoice_Line_Item__c.isCreateable()){
        INSERT lstiv; }
        return invocId; 
    }
    
        //edit inv fetch data
    @AuraEnabled(cacheable=true)
     public static List<Match_Maker__Invoice_Line_Item__c> fetchLineItem(String recordId) {
        return [SELECT Id,Match_Maker__Invoice__c,Match_Maker__Items__c,Match_Maker__Amount__c,Match_Maker__Discount__c,Match_Maker__Discount_Amount__c,
               Match_Maker__Line_Item_Total__c,Match_Maker__Line_Total__c,Match_Maker__Line_Total_After_Discount__c,Match_Maker__Quantity__c,Match_Maker__Taxs__c,Match_Maker__Tax_Amount__c FROM Match_Maker__Invoice_Line_Item__c WHERE Match_Maker__Invoice__c =:recordId WITH SECURITY_ENFORCED LIMIT 100 ];
     }
    
          //upsert
       @AuraEnabled
    Public Static void upsertInvoice(List<Match_Maker__Invoice_Line_Item__c> lineItems , Match_Maker__Invoice__c invoc, String recId,List<Match_Maker__Invoice_Line_Item__c> removeLineItemIds){
        system.debug('lineItems==='+lineItems);
        system.debug('invoc==='+invoc);
        system.debug('recId==='+recId);   system.debug('deletedLine==='+removeLineItemIds);
       // update invoc; 
         Match_Maker__Invoice__c invupd=new Match_Maker__Invoice__c();
        invupd.id=recId;
       // invupd.Match_Maker__Full_Name__c=invoc.Match_Maker__Full_Name__c;
       // invupd.Match_Maker__Contact__c=invoc.Match_Maker__Contact__c;
       // invupd.Match_Maker__Profile__c=invoc.Match_Maker__Profile__c;;
        invupd.Match_Maker__Phone__c=invoc.Match_Maker__Phone__c;  
        invupd.Match_Maker__Email__c=invoc.Match_Maker__Email__c;
        invupd.Match_Maker__Date__c=invoc.Match_Maker__Date__c;
        invupd.Match_Maker__Time__c=invoc.Match_Maker__Time__c;
        invupd.Match_Maker__Payment_Method__c=invoc.Match_Maker__Payment_Method__c;     
        invupd.Match_Maker__Payment_Status__c=invoc.Match_Maker__Payment_Status__c;
        invupd.Match_Maker__Line_Item_Count__c=invoc.Match_Maker__Line_Item_Count__c;
        invupd.Match_Maker__Address__Street__s=invoc.Match_Maker__Address__Street__s;
        invupd.Match_Maker__Address__City__s=invoc.Match_Maker__Address__City__s;
        invupd.Match_Maker__Address__StateCode__s=invoc.Match_Maker__Address__StateCode__s;
        invupd.Match_Maker__Address__PostalCode__s=invoc.Match_Maker__Address__PostalCode__s;
        invupd.Match_Maker__Address__CountryCode__s=invoc.Match_Maker__Address__CountryCode__s;
        invupd.Match_Maker__Total_Amount__c=invoc.Match_Maker__Total_Amount__c;
        invupd.Match_Maker__Total_Tax_Amount__c=invoc.Match_Maker__Total_Tax_Amount__c;
        invupd.Match_Maker__Total_Discount_Amount__c=invoc.Match_Maker__Total_Discount_Amount__c;
        invupd.Match_Maker__Net_Invoice_Amount__c=invoc.Match_Maker__Net_Invoice_Amount__c;
        if(Schema.sObjectType.Match_Maker__Invoice__c.isUpdateable()){
             update invupd;
        }
        List<Match_Maker__Invoice_Line_Item__c> lstiv = new list<Match_Maker__Invoice_Line_Item__c>();
        
        List<Match_Maker__Invoice_Line_Item__c> deleteline = new List<Match_Maker__Invoice_Line_Item__c>();
        if(removeLineItemIds.size()>0){
           
            deleteline = [SELECT Id FROM Match_Maker__Invoice_Line_Item__c WHERE Id IN :removeLineItemIds];
            system.debug('deleteline==='+deleteline.size());
        }
         if(deleteline.size()>0){    
                delete deleteline;
            }
        
        for(Match_Maker__Invoice_Line_Item__c inv : lineItems)
       {
           Match_Maker__Invoice_Line_Item__c sinv = new Match_Maker__Invoice_Line_Item__c();
           if(inv.Id!=null){
            sinv.Id=inv.Id; 
            sinv.Match_Maker__Invoice__c = recId;
            sinv.Match_Maker__Items__c=inv.Match_Maker__Items__c;
            sinv.Match_Maker__Amount__c=inv.Match_Maker__Amount__c;
            sinv.Match_Maker__Discount__c=inv.Match_Maker__Discount__c;
            sinv.Match_Maker__Discount_Amount__c=inv.Match_Maker__Discount_Amount__c;
            sinv.Match_Maker__Line_Item_Total__c=inv.Match_Maker__Line_Item_Total__c;
            sinv.Match_Maker__Line_Total__c=inv.Match_Maker__Line_Total__c;
            sinv.Match_Maker__Line_Total_After_Discount__c=inv.Match_Maker__Line_Total_After_Discount__c;
            sinv.Match_Maker__Quantity__c=inv.Match_Maker__Quantity__c;
            sinv.Match_Maker__Taxs__c=inv.Match_Maker__Taxs__c;
            sinv.Match_Maker__Tax_Amount__c=inv.Match_Maker__Tax_Amount__c;
           lstiv.add(sinv);
           } 
           else
           {
            sinv.Match_Maker__Invoice__c = recId;
            sinv.Match_Maker__Items__c=inv.Match_Maker__Items__c;
            sinv.Match_Maker__Amount__c=inv.Match_Maker__Amount__c;
            sinv.Match_Maker__Discount__c=inv.Match_Maker__Discount__c;
            sinv.Match_Maker__Discount_Amount__c=inv.Match_Maker__Discount_Amount__c;
            sinv.Match_Maker__Line_Item_Total__c=inv.Match_Maker__Line_Item_Total__c;
            sinv.Match_Maker__Line_Total__c=inv.Match_Maker__Line_Total__c;
            sinv.Match_Maker__Line_Total_After_Discount__c=inv.Match_Maker__Line_Total_After_Discount__c;
            sinv.Match_Maker__Quantity__c=inv.Match_Maker__Quantity__c;
            sinv.Match_Maker__Taxs__c=inv.Match_Maker__Taxs__c;
            sinv.Match_Maker__Tax_Amount__c=inv.Match_Maker__Tax_Amount__c;
           lstiv.add(sinv);
           system.debug('lstiv=='+lstiv);
               }
       }
        if(Schema.sObjectType.Match_Maker__Invoice_Line_Item__c.isUpdateable()){
        upsert lstiv; }
       // return invocId; 
    } 
    
        //for contact id
     @AuraEnabled
    Public Static Id getContactId(String conId){
        system.debug('conId'+conId);
         Match_Maker__Invoice__c inve =[select id,name,Match_Maker__Contact__c  from Match_Maker__Invoice__c where id=:conId WITH SECURITY_ENFORCED];
          system.debug('inve.Match_Maker__Contact__c.Id;'+inve.Match_Maker__Contact__c);
        return inve.Match_Maker__Contact__c;
    }
    
 /*     //2nd lookup mthd
   @AuraEnabled(cacheable=true)
    public static List<sObject> searchPro(String searchTerm, string myObject, string contactId) {
        String myQuery = null;
       
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND Match_Maker__Contact__c=:contactId order by createdDate DESC';
      
        
        List<sObject> lookUpList = database.query(myQuery);
        system.debug('result'+lookUpList);
        return lookUpList;
    }   
    //3rd mthd
        @AuraEnabled(cacheable=true)
    public static List<Match_Maker__Profile__c> getCustomLookupProfile (String proName,string contactId){
       List<Match_Maker__Profile__c> proLookupList =  new List<Match_Maker__Profile__c>();
       
           String profileName = '%' + proName + '%';
           proLookupList = [Select Id, Name From Match_Maker__Profile__c Where Name like:profileName AND Match_Maker__Contact__c=:contactId WITH SECURITY_ENFORCED];
           return proLookupList;      
    }   */

}