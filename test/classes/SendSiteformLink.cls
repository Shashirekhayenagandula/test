public with sharing class SendSiteformLink {
    
    @auraEnabled(cacheable=true)
    public static void sendMail(String recordId){
        
        for(Match_Maker__Profile__c pro : [SELECT Id,Match_Maker__Contact__c, Match_Maker__ProfileURL__c,Name, Email__c,Match_Maker__Status__c,CreatedById FROM Match_Maker__Profile__c WHERE Id =: recordId WITH SECURITY_ENFORCED Limit 1]){
            system.debug('profile===='+pro);
            if(pro.Match_Maker__Status__c=='Request for Completion')
            {
            Schema.EmailTemplate emailTemplate =[Select Id,Name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Name ='SiteUserTemplate' WITH SECURITY_ENFORCED  limit 1 ];
            String htmlBody=emailTemplate.HtmlValue;
            String plainBody=emailTemplate.Body;
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            
            List<String> sendTo = new List<String>();
            sendTo.add(pro.Email__c);
            semail.setToAddresses(sendTo);
            semail.setTemplateId(emailTemplate.Id);
            semail.setTreatTargetObjectAsRecipient(false);
            semail.setTargetObjectId(pro.Match_Maker__Contact__c);
            semail.setWhatId(pro.Id);
            semail.setSaveAsActivity(false);
            semail.setTreatBodiesAsTemplate(true);
            semail.setplainTextBody(plainBody);
            //semail.setHtmlBody(htmlBody);
            semail.setSubject('Matchy Profile Creation');
          try
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semail });  
                           }
            catch(Exception e)
            {
                throw new AuraHandledException(e.getMessage());
            }
        }
        }
        }
    }