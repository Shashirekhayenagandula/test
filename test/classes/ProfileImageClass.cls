public with sharing class ProfileImageClass {
    
    @AuraEnabled(cacheable=true)
        public static List<Sobject> getRelatedFilesByRecordId(String recordId) {
            // Get record file IDs        
            List<ContentDocumentLink> files = [ SELECT ContentDocumentId, LinkedEntityId FROM contentDocumentLink WHERE LinkedEntityId =:recordId WITH SECURITY_ENFORCED];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT Id,ContentDocumentId,title from ContentVersion where ContentDocumentId IN: fileIDs and isLatest=true and FileType!='SNOTE' WITH SECURITY_ENFORCED Order by CreatedDate DESC]; 
         
           List<Sobject> setContentDocumentIds = new  List<Sobject>();
           
            for (ContentVersion docLink : docs) {
                setContentDocumentIds.add(docLink);
            }
            System.debug('setContentDocumentIds'+setContentDocumentIds);
            return setContentDocumentIds;
        }
}