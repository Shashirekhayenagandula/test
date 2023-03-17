public with sharing class Shortlisted_Status_Trigger_class {
    List<Match_Maker__Shortlisted_Contact__c> newShortlistedProfiles;
    
    public Shortlisted_Status_Trigger_class(List<Match_Maker__Shortlisted_Contact__c> lstShortlistedContacts){
        newShortlistedProfiles=lstShortlistedContacts;
    }        
    public void updateStatus(){
        system.debug('lstShortlisted==' +newShortlistedProfiles);
        set<Id> profileIds = new Set<Id>();
        set<Id> profileIds2 = new Set<Id>();
        set<Id> matchedProfileIds = new Set<Id>();
        for(Match_Maker__Shortlisted_Contact__c sp : newShortlistedProfiles){
            if(sp.Match_Maker__Status__c == 'Selected'){
                profileIds.add(sp.Match_Maker__Profile__c); 
                matchedProfileIds.add(sp.Match_Maker__Match_Preference__c);
            }
            else{
                profileIds2.add(sp.Match_Maker__Profile__c); 
                matchedProfileIds.add(sp.Match_Maker__Match_Preference__c);
            }
            
        }
        
        //Map<Id,Match_Preference__c> mapMatchPreference =new Map<Id,Match_Preference__c>();
        Map<Id, Match_Maker__Match_Preference__c> mapMatchPref = new Map<Id, Match_Maker__Match_Preference__c>([SELECT Id, Name,Match_Maker__Profile__c FROM Match_Maker__Match_Preference__c WHERE Id IN :matchedProfileIds WITH SECURITY_ENFORCED]);
        for(Match_Maker__Shortlisted_Contact__c sp : newShortlistedProfiles){
            if(sp.Match_Maker__Status__c == 'Selected' ){
                if(mapMatchPref.containskey(sp.Match_Maker__Match_Preference__c)){
                    profileIds.add(mapMatchPref.get(sp.Match_Maker__Match_Preference__c).Match_Maker__Profile__c);
                }
            }
            else{
                if(mapMatchPref.containskey(sp.Match_Maker__Match_Preference__c)){
                    profileIds2.add(mapMatchPref.get(sp.Match_Maker__Match_Preference__c).Match_Maker__Profile__c);
                }
            }
        }        
        List<Match_Maker__Profile__c> profileList = new List<Match_Maker__Profile__c>();
        for(Match_Maker__Profile__c pf : [SELECT Id,Name,Match_Maker__Active__c FROM Match_Maker__Profile__c WHERE Id IN :profileIds WITH SECURITY_ENFORCED]){
            pf.Match_Maker__Active__c = false;
            profileList.add(pf);
        }
        List<Match_Maker__Profile__c> profileList2 = new List<Match_Maker__Profile__c>();
        for(Match_Maker__Profile__c pf : [SELECT Id,Name,Match_Maker__Active__c FROM Match_Maker__Profile__c WHERE Id IN :profileIds2 WITH SECURITY_ENFORCED]){
            pf.Match_Maker__Active__c = true;
            profileList2.add(pf);
        }
        if(profileList.size()>0){
            if(Schema.SObjectType.Match_Maker__Profile__c.isUpdateable() && Schema.SObjectType.Match_Maker__Profile__c.fields.Match_Maker__Active__c.isUpdateable()){
                update profileList; 
            }
            
        }
        if(profileList2.size()>0){
            if(Schema.SObjectType.Match_Maker__Profile__c.isUpdateable() && Schema.SObjectType.Match_Maker__Profile__c.fields.Match_Maker__Active__c.isUpdateable()){
                update profileList2;
            }
        }
    }
    
    
}