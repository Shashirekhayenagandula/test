public with sharing class MatchPreferenceNewOverideClass {
    @AuraEnabled
    Public Static Integer getMatchReferences(String profileId){
        system.debug('profileId'+profileId);
        Integer matchCount=[select count() from Match_Maker__Match_Preference__c where Match_Maker__Profile__c =:profileId WITH SECURITY_ENFORCED];
          system.debug('matchCount'+matchCount);
        return matchCount;
    }
    
    @AuraEnabled
    Public Static Id getProfileForMatchPreference(String matchId){
        system.debug('matchId'+matchId);
         Match_Maker__Match_Preference__c mp =[select id,name,Match_Maker__Profile__c  from Match_Maker__Match_Preference__c where id=:matchId WITH SECURITY_ENFORCED];
          system.debug('mp.Match_Maker__Profile__c.Id;'+mp.Match_Maker__Profile__c);
        return mp.Match_Maker__Profile__c;
    }
  
 }