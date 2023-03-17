public with sharing class UploadPhotoWithGallary {
    
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getVersionFiles(String recordId){
        try {
            
            List<ContentDocumentLink> listCDL = [ SELECT ContentDocumentId, LinkedEntityId FROM contentDocumentLink WHERE LinkedEntityId = :recordId WITH SECURITY_ENFORCED Limit 1000];
            Set<Id> setContentDocumentIds = new Set <Id>();
            for( contentDocumentLink  rec : listCDL  ){
                setContentDocumentIds.add(rec.ContentDocumentid);
            }
            List<ContentVersion> cvList=new list <ContentVersion>();
            if(!setContentDocumentIds.isEmpty()){
                cvList =[SELECT Id,Title,ContentDocumentId,FileType,ContentSize,FileExtension,VersionNumber,CreatedDate,VersionData,FirstPublishLocationId from ContentVersion where ContentDocumentId IN: setContentDocumentIds and FileType!='SNOTE' WITH SECURITY_ENFORCED Order by CreatedDate DESC Limit 1000];             
            }
            return cvList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void delFiles(String recid, string delfileId){
        try {    
            List<ContentDocumentLink> cdl =[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink   where ContentDocumentId =:delfileId and LinkedEntityId =:recid WITH SECURITY_ENFORCED Limit 1000];
            system.debug('deleteddddddddddd file===='+cdl);
            if(cdl.size()>0){
                if (Schema.sObjectType.ContentDocumentLink.isDeletable()) {
                     delete cdl;
                }
               
            }
            
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
}