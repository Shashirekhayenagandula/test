public with sharing class EmailClass {
    public Match_Maker__Profile__c profile {get;set;}
    public String recordId {get;set;}
    public String fileId {get;set;}
    
    @AuraEnabled
    public static List<Match_Maker__Profile__c> search(String searchKeyWord,List<String> excludedlist) {
        List<Match_Maker__Profile__c> searchList = new List<Match_Maker__Profile__c>();
        try {
            List<string> lstExcludeitems = new List<string>();
            for(string item : excludedlist ){
                lstExcludeitems.add(item);
            }
            String searchKey = searchKeyWord + '%';
            String sQuery =  'select id, Name,Match_Maker__Email__c from Match_Maker__Profile__c where (Name LIKE: searchKey OR Match_Maker__Email__c LIKE: searchKey) AND Match_Maker__Email__c NOT IN : lstExcludeitems AND Match_Maker__Email__c <> Null WITH SECURITY_ENFORCED order by createdDate ASC';
            List < Match_Maker__Profile__c > lstOfRecords = Database.query(sQuery);
            for (Match_Maker__Profile__c curList : lstOfRecords) {
                searchList.add(curList);
            }
            system.debug('searchList:::' + searchList.size());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        system.debug('searchList=='+searchList);
        return searchList;
    }
    
    
    @AuraEnabled
    public static string sendEmailController(String emailDetailStr) {
        system.debug('emailDetailStr===='+emailDetailStr);
        EmailWrapper emailDetails = (EmailWrapper) JSON.deserialize(emailDetailStr, EmailWrapper.class);
        system.debug('emails===='+emailDetails.toAddress);
        Blob b;
        PageReference pdf = Page.New_Send_Profile;
        pdf.getParameters().put('id',emailDetails.profileid);
        pdf.setRedirect(true);
        
        Match_Maker__Profile__c con =[Select Id,Name,Match_Maker__Gender__c,Match_Maker__Email__c From Match_Maker__Profile__c where id=:emailDetails.profileid WITH SECURITY_ENFORCED]; 
        if(!Test.isRunningTest()){
            b = pdf.getContent();
        }
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Profile of '+con.Name+'.pdf');
        efa.setBody(b);
        
        Schema.EmailTemplate emailTemplate =[Select Id,Name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Name ='Send Profile Text' WITH SECURITY_ENFORCED  limit 1 ];
        String htmlBody=emailTemplate.HtmlValue;
        system.debug('htmlBody===='+htmlBody);
        String plainBody=emailTemplate.Body;
        if(emailDetails.toAddress!=null)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setTemplateID(emailTemplate.Id);
            mail.setToAddresses(emailDetails.toAddress);
            mail.setSubject(emailDetails.subject);
            //mail.setHtmlBody(htmlBody);
            mail.setplainTextBody(plainBody);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa }); 
            // Send the email
            
            try
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                return 'OK';
            }
            catch(Exception e)
            {
                return 'Message Sending Failed. Please Enter Email and Try Again.';
            }
        }
        else
        {
            
            return 'Please Enter Email and Try Again.';
        }
        
    }
    @AuraEnabled(cacheable=true)
    public static Match_Maker__Profile__c profileDetails(String profileId) {
        Match_Maker__Profile__c profile =[Select Id,Name,Match_Maker__Gender__c,Match_Maker__Email__c From Match_Maker__Profile__c  where id=:profileId WITH SECURITY_ENFORCED limit 1 ];
        system.debug('profile==='+profile);
        return profile;
    }
    
    
    public void getProfileInformation(){
        recordId  = ApexPages.currentPage().getParameters().get('id');
        profile = [select id,name,Match_Maker__Gender__c,Match_Maker__Zodiac__c,Match_Maker__Marital_Status__c,Match_Maker__Does_He_She_They_have_children__c,Match_Maker__No_of_Children__c,Match_Maker__DOB__c, Match_Maker__Age__c,Match_Maker__Place_of_Birth__c,Match_Maker__Birth_Time__c,Match_Maker__Challenges__c,Match_Maker__Living_with_Family__c,Match_Maker__Lives_In__City__s,Match_Maker__Lives_In__StateCode__s,Match_Maker__Lives_In__CountryCode__s, Match_Maker__Highest_Qualification__c, Match_Maker__College_University_Name__c, Match_Maker__Working_with__c, Match_Maker__Company_Name_current__c,Match_Maker__Professional_Area__c,Match_Maker__Income_yearly__c,Match_Maker__Religion__c,Match_Maker__Other_Religion__c,Match_Maker__Community_Mother_Tounge__c,Match_Maker__Skin_Tone_C__c,Match_Maker__Body_Type__c,Match_Maker__Height__c,Match_Maker__Weight__c,Match_Maker__Your_Diet__c,Match_Maker__Blood_Group__c,Match_Maker__Smoke__c,Match_Maker__Drinks__c,Match_Maker__Interest__c,Match_Maker__Hobbies__c,Match_Maker__Favourite_Music__c,Match_Maker__Preferred_Dress_Style__c,Match_Maker__Preferred_Movies__c,Match_Maker__Sport_Fitness_Activities__c,Match_Maker__Favourite_Criuisne__c,Match_Maker__Favourite_Read__c,Match_Maker__Family_Lives_In__City__s,Match_Maker__Family_Lives_In__StateCode__s from Match_Maker__Profile__c where id=:recordId WITH SECURITY_ENFORCED limit 1];
        fileId = '';
        system.debug('----recordId----'+recordId);
        List<ContentDocumentLink> attachedFiles = [SELECT Id, LinkedEntityId,ContentDocument.LatestPublishedVersionId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:recordId WITH SECURITY_ENFORCED Order by SystemModstamp DESC]; 
        //system.debug('----ContentDocument.LatestPublishedVersionId----'+attachedFiles[0].ContentDocument.LatestPublishedVersionId);
        if( attachedFiles != null && attachedFiles.size() > 0 ) {
            fileId = attachedFiles[0].ContentDocument.LatestPublishedVersionId;
            system.debug('----fileId----'+fileId);
        }
        else{
            fileId='No Image';
        }
        system.debug('----fileId----'+fileId);
        
    }
    
    
    
    Class EmailWrapper {
        public List<String> toAddress;
        //public List<String> ccAddress;
        public String subject;
        public String body;
        public string profileid;
        //public List<String> files;
    }
}