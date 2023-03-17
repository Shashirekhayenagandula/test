public with sharing class Email_Event_Helper {
    List<Event> lstEvents;
    public Email_Event_Helper(List<Event> allEvents){
        lstEvents=allEvents;
    }
    public void beforeInsert(){
        system.debug('lstEvents==='+lstEvents.size()+', list ==='+lstEvents);
        List<String> lstEmails = new List<String>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(Event e :lstEvents ){
            userIds.add(e.OwnerId);
            contactIds.add(e.WhoId);
        }
        Contact eventContact = [select Id,Name,Email from Contact where id=:contactIds WITH SECURITY_ENFORCED limit 1];
        user userevent = [select id,Name,Email from user where id=:userIds WITH SECURITY_ENFORCED limit 1];
        lstEmails.add(eventContact.Email);
        lstEmails.add(userevent.Email);
        system.debug('lstEmails==='+lstEmails.size()+', list ==='+lstEmails);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(lstEmails);
        message.subject = 'Match Maker Meeting Invitation.';
        message.plainTextBody = 'Meeting Created by '+userevent.Name+' with '+eventContact.Name;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}