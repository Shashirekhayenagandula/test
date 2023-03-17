public with sharing class Search_MM {
   
    @AuraEnabled(cacheable=true)
    Public Static  List<ProfileMatchWrapper> getMatchedProfiles(String matchingId){
        List<Match_Maker__Shortlisted_Contact__c> shortlistedProfileBefore = [select id,Name,Match_Maker__Profile__c,Match_Maker__Match_Preference__c from Match_Maker__Shortlisted_Contact__c where Match_Maker__Match_Preference__c=:matchingId WITH SECURITY_ENFORCED];
       
        set<Id> scIds = new set<Id>();
        for(Match_Maker__Shortlisted_Contact__c sc: shortlistedProfileBefore){
            scIds.add(sc.Match_Maker__Profile__c);
        }
        List<Match_Maker__Profile__c> profilesList = [Select id,Name,Match_Maker__Active__c,Match_Maker__Opposite_Gender__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Match_Maker__Gender__c,Match_Maker__Age__c,Match_Maker__Height__c,Match_Maker__Does_He_She_They_have_children__c,Match_Maker__No_of_Children__c,Match_Maker__Marital_Status__c,Match_Maker__Religion__c,
                                                      Match_Maker__Your_Diet__c,Match_Maker__Zodiac__c,Match_Maker__Skin_Tone_C__c,Match_Maker__Highest_Qualification__c,Match_Maker__Working_with__c,Contact__c,Contact__r.AccountId,Match_Maker__Professional_Area__c,Match_Maker__Drinks__c,Match_Maker__Smoke__c ,Match_Maker__Lives_In__City__s,Match_Maker__Lives_In__CountryCode__s,Match_Maker__Lives_In__c,Match_Maker__Lives_In__StateCode__s, Match_Maker__Income_yearly__c from Match_Maker__Profile__c where id Not In:scIds WITH SECURITY_ENFORCED Order by Name LIMIT 1000];
       
        Map<Id, Match_Maker__Profile__c> profilenames = new map<Id,Match_Maker__Profile__c>();
        List<ProfileMatchWrapper> roleWraps=new List<ProfileMatchWrapper>();
        if(!profilesList.isEmpty()){
            Set<Id> contentDocumentIdSet =new Set<Id>();
            Map<Id,String> contentDocMap=new Map<Id,String>();
            for(Match_Maker__Profile__c c: profilesList){
                profilenames.put(c.id,c);
                for(ContentDocumentLink cdl: c.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
           
           
            List<Match_Maker__Match_Preference__c>matchings =[SELECT Id, Match_Maker__Diet__c,Match_Maker__Zodiac__c,Match_Maker__Skin_Tone_Complexion__c,Match_Maker__Looking_for_Gender__c,Match_Maker__Min_Age__c,Match_Maker__Max_Age__c,Match_Maker__Min_Height__c,Match_Maker__Max_Height__c,Match_Maker__Material_Status__c,Match_Maker__Having_Children__c,Match_Maker__Religion__c,Match_Maker__Profile__r.Contact__c,Match_Maker__Highest_Qualification__c,Match_Maker__Working_with__c,Match_Maker__Professional_Area__c,Match_Maker__Annual_Income__c,Match_Maker__Alcohol__c,Match_Maker__Profile__r.Contact__r.AccountId,Match_Maker__Does_Smoke__c,Match_Maker__No_of_Children__c,Match_Maker__Profile__r.id,Match_Maker__Profile__r.Match_Maker__Gender__c FROM Match_Maker__Match_Preference__c  where id=: matchingId and Match_Maker__Profile__c=:profilenames.keyset() WITH SECURITY_ENFORCED];
            system.debug('matchings'+matchings);
           
            for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' WITH SECURITY_ENFORCED Order by CreatedDate DESC]){
                if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                    contentDocMap.put(cv.ContentDocumentId,cv.Id);
                }
            }
            for(Match_Maker__Match_Preference__c M :matchings){
                Boolean AgeBool=false,HeightBool=false,ReligionBool=false,HighestQualificationBool=false,AnnualIncomeBool=false,ProfessionalAreaBool=false,ZodiacBool=false,HavingchildrenBool=false,workingwithBool=false,SmokeBool=false,AlocoholBool=false,DietBool=false,SkinToneBool=false,NoOfChildrenBool=false,MaritalStatusBool=false;
                for(Match_Maker__Profile__c pro : profilesList){
                    Decimal c=0;
                    List<string> dietIndividualValue;
                    string profileAge = string.valueOf(pro.Match_Maker__Age__c);
                    system.debug('profileAge=='+profileAge);
                    String[] religions = M.Match_Maker__Religion__c.split(';');
                    system.debug('religions==='+religions);
                    string profileHeight = string.valueOf(pro.Match_Maker__Height__c);
                    // Integer contactIncome = Integer.valueOf(con.Income_yearly__c);
                    if( M.Match_Maker__Religion__c == 'Open to All'){
                        ReligionBool=true;
                        c++;
                        if(M.Match_Maker__Alcohol__c == 'Does not matter' || M.Match_Maker__Does_Smoke__c == 'Does not matter' || M.Match_Maker__Having_Children__c == 'Does not matter' || M.Match_Maker__Zodiac__c == 'Does not matter' || M.Match_Maker__Material_Status__c =='Open to All' || M.Match_Maker__Highest_Qualification__c =='Open to All' || M.Match_Maker__Diet__c =='Open to All' || M.Match_Maker__Skin_Tone_Complexion__c =='Open to All' || M.Match_Maker__Working_with__c=='Open to All')
                        {
                            if(M.Match_Maker__Looking_for_Gender__c == pro.Match_Maker__Gender__c && M.Match_Maker__Min_Age__c<=profileAge && M.Match_Maker__Max_Age__c>=profileAge && M.Match_Maker__Min_Height__c<=profileHeight && M.Match_Maker__Max_Height__c>=profileHeight && pro.Id != M.Match_Maker__Profile__c && M.Match_Maker__Profile__r.Contact__c!=pro.Contact__c && M.Match_Maker__Profile__r.Contact__r.AccountId!=pro.Contact__r.AccountId && pro.Match_Maker__Opposite_Gender__c == M.Match_Maker__Profile__r.Match_Maker__Gender__c && pro.Match_Maker__Active__c == true && (M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c) && ((M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c)||(M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c) ||(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c))||(M.Match_Maker__Material_Status__c==pro.Match_Maker__Marital_Status__c)|| (M.Match_Maker__No_of_Children__c==pro.Match_Maker__No_of_Children__c)||(M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c) ||(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c))||(M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c)||(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c) || M.Match_Maker__Diet__c.contains(pro.Match_Maker__Your_Diet__c) || (M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c)) || true) )
                                
                            {
                                system.debug('profile ID==========================================================='+pro.Id);
                            system.debug('flag valuee================================================='+(M.Match_Maker__Looking_for_Gender__c == pro.Match_Maker__Gender__c && M.Match_Maker__Min_Age__c<=profileAge && 
                                         M.Match_Maker__Max_Age__c>=profileAge && M.Match_Maker__Min_Height__c<=profileHeight && M.Match_Maker__Max_Height__c>=profileHeight
                                         && pro.Id != M.Match_Maker__Profile__c && M.Match_Maker__Profile__r.Contact__c!=pro.Contact__c && 
                                         M.Match_Maker__Profile__r.Contact__r.AccountId!=pro.Contact__r.AccountId && pro.Match_Maker__Opposite_Gender__c == M.Match_Maker__Profile__r.Match_Maker__Gender__c 
                                         && pro.Match_Maker__Active__c == true && (M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c) && 
                                                                                                         
                                         ((M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c)||(M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c) 
                                          ||(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c))||
                                          (M.Match_Maker__Material_Status__c==pro.Match_Maker__Marital_Status__c)|| 
                                          (M.Match_Maker__No_of_Children__c==pro.Match_Maker__No_of_Children__c)||
                                          (M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c) 
                                          ||(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c))||
                                          (M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c)||(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c) 
                                          || M.Match_Maker__Diet__c.contains(pro.Match_Maker__Your_Diet__c) || (M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c)) )|| true));
                         
                                
                                if((M.Match_Maker__Min_Age__c<=profileAge) && (M.Match_Maker__Max_Age__c>=profileAge) ){
                                    c++;
                                    AgeBool=true;
                                }
                                else{
                                    AgeBool=false;
                                }
                                if((M.Match_Maker__Min_Height__c<=profileHeight) && (M.Match_Maker__Max_Height__c>=profileHeight)){
                                    c++;
                                    HeightBool=true;
                                }
                                else{
                                    HeightBool=false;
                                }
                                if(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c )|| M.Match_Maker__Highest_Qualification__c =='Open to All'){
                                    c++;
                                    HighestQualificationBool=true;
                                }
                                 else{
                                    HighestQualificationBool=false;
                                }
                                if(M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c){
                                    c++;
                                    AnnualIncomeBool=true;
                                }
                                else{
                                    AnnualIncomeBool=false;
                                }
                                if(M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c){
                                    c++;
                                    ProfessionalAreaBool=true;
                                }
                                 else{
                                    ProfessionalAreaBool=false;
                                }
                                if(M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c|| M.Match_Maker__Having_Children__c == 'Does not matter'){
                                    c++;
                                    HavingchildrenBool=true;
                                }
                                else{
                                    HavingchildrenBool=false;
                                }
                                if(M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c|| M.Match_Maker__Zodiac__c == 'Does not matter'){
                                    c++;
                                    ZodiacBool=true;
                                  }
                                  else{
                                    ZodiacBool=false;
                                }
                                if(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c)  || M.Match_Maker__Working_with__c=='Open to All'){
                                    c++;
                                    workingwithBool=true;
                                }
                                else{
                                    workingwithBool=false;
                                }
                                if(M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c || M.Match_Maker__Does_Smoke__c == 'Does not matter'){
                                    c++;
                                    SmokeBool=true;
                                }
                                else{
                                    SmokeBool=false;
                                }
                                if(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c || M.Match_Maker__Alcohol__c == 'Does not matter'){
                                    c++;
                                    AlocoholBool=true;
                                }
                                else{
                                    AlocoholBool=false;
                                }
                                if(M.Match_Maker__Diet__c!=null && pro.Match_Maker__Your_Diet__c!=null)
                                {
                                    
                                    if(M.Match_Maker__Diet__c.contains(pro.Match_Maker__Your_Diet__c) || M.Match_Maker__Diet__c =='Open to All'){
                                    c++;
                                    DietBool=true;
                                }
                                    else{
                                    DietBool=false;
                                }
                                } 
                              /*  if(M.Match_Maker__No_of_Children__c==pro.Match_Maker__No_of_Children__c){
                                    c++;
                                    NoOfChildrenBool=true;
                                }
                                 else{
                                    NoOfChildrenBool=false;
                                } */
                                if( M.Match_Maker__Skin_Tone_Complexion__c!=null && pro.Match_Maker__Skin_Tone_C__c!=null)
                                {
                                    if(M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c) || M.Match_Maker__Skin_Tone_Complexion__c =='Open to All'){
                                    c++;
                                    SkinToneBool=true;
                                }
                                    else{
                                        SkinToneBool=false;
                                    }
                                }
                                if(M.Match_Maker__Material_Status__c.contains(pro.Match_Maker__Marital_Status__c) || M.Match_Maker__Material_Status__c =='Open to All'){
                                    c++;
                                    MaritalStatusBool=true;
                                }
                                else{
                                        MaritalStatusBool=false;
                                    }
                               string newcontentid='';
                    ProfileMatchWrapper cm = new ProfileMatchWrapper();
                    cm.profilewrapper = pro;
                    cm.preferencewrapper= M;
                    cm.probability = ((c/14)*100).setScale(2);
                               
                    cm.hideBool = true;
                    cm.ContentVersionId = '';
                    cm.AgeBool=AgeBool;
                    cm.HeightBool=HeightBool;
                    cm.ReligionBool=ReligionBool;
                    cm.HighestQualificationBool=HighestQualificationBool;
                    cm.AnnualIncomeBool=AnnualIncomeBool;
                    cm.ProfessionalAreaBool=ProfessionalAreaBool;
                    cm.HavingchildrenBool=HavingchildrenBool;
                    cm.ZodiacBool=ZodiacBool;            
                    cm.workingwithBool=workingwithBool;
                    cm.SmokeBool=SmokeBool;
                    cm.AlocoholBool=AlocoholBool;
                    cm.DietBool=DietBool;
                    cm.SkinToneBool=SkinToneBool;
                 //   cm.NoOfChildrenBool=NoOfChildrenBool;
                    cm.MaritalStatusBool=MaritalStatusBool;
                    for(ContentDocumentLink cdl:pro.ContentDocumentLinks){
                        if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                            newcontentid=contentDocMap.get(cdl.ContentDocumentId);
                            if(newcontentid!=null){
                                cm.ContentVersionId='/sfc/servlet.shepherd/version/download/'+newcontentid;
                            }
                            else{
                                cm.ContentVersionId='https://s3-us-west-1.amazonaws.com/sfdc-demo/image-placeholder.png';
                            }
                            cm.ContentVersionId='/sfc/servlet.shepherd/version/download/'+newcontentid;
                            system.debug('cm.ContentVersionId== '+cm.ContentVersionId);
                            break;
                        }
                    }
                    roleWraps.add(cm);
                   
                               
                            }
                        }
                        else  
                        {
                            if(M.Match_Maker__Looking_for_Gender__c == pro.Match_Maker__Gender__c && M.Match_Maker__Min_Age__c<=profileAge && M.Match_Maker__Max_Age__c>=profileAge && M.Match_Maker__Min_Height__c<=profileHeight && M.Match_Maker__Max_Height__c>=profileHeight && pro.Id != M.Match_Maker__Profile__c && M.Match_Maker__Profile__r.Contact__c!=pro.Contact__c && M.Match_Maker__Profile__r.Contact__r.AccountId!=pro.Contact__r.AccountId && pro.Match_Maker__Opposite_Gender__c == M.Match_Maker__Profile__r.Match_Maker__Gender__c && pro.Match_Maker__Active__c == true && (M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c) && ((M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c)||(M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c) ||(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c))||(M.Match_Maker__Material_Status__c==pro.Match_Maker__Marital_Status__c)|| (M.Match_Maker__No_of_Children__c==pro.Match_Maker__No_of_Children__c)||(M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c) ||(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c))||(M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c)||(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c)) )
                               
                            {
                                if((M.Match_Maker__Min_Age__c<=profileAge) && (M.Match_Maker__Max_Age__c>=profileAge) ){
                                    c++;
                                    AgeBool=true;
                                }
                                else{
                                    AgeBool=false;
                                }
                                if((M.Match_Maker__Min_Height__c<=profileHeight) && (M.Match_Maker__Max_Height__c>=profileHeight)){
                                    c++;
                                    HeightBool=true;
                                }
                                else{
                                    HeightBool=false;
                                }
                                if(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c)){
                                    c++;
                                    HighestQualificationBool=true;
                                }
                                 else{
                                    HighestQualificationBool=false;
                                }
                                if(M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c){
                                    c++;
                                    AnnualIncomeBool=true;
                                }
                                else{
                                    AnnualIncomeBool=false;
                                }
                                
                                if(M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c){
                                    c++;
                                    ProfessionalAreaBool=true;
                                }
                                else{
                                    ProfessionalAreaBool=false;
                                }
                                if(M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c){
                                    c++;
                                    HavingchildrenBool=true;
                                }
                                else{
                                    HavingchildrenBool=false;
                                }
                                if(M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c){
                                    c++;
                                    ZodiacBool=true;
                                  }
                                  else{
                                    ZodiacBool=false;
                                }
                                if(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c)){
                                    c++;
                                    workingwithBool=true;
                                }
                                else{
                                    workingwithBool=false;
                                }
                                if(M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c){
                                    c++;
                                    SmokeBool=true;
                                }
                                else{
                                    SmokeBool=false;
                                }
                                if(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c){
                                    c++;
                                    AlocoholBool=true;
                                }
                                 else{
                                    AlocoholBool=false;
                                }
                                if(M.Match_Maker__Diet__c!=null && pro.Match_Maker__Your_Diet__c!=null)
                                {
                                    
                                    if(M.Match_Maker__Diet__c.contains(pro.Match_Maker__Your_Diet__c)){
                                    c++;
                                    DietBool=true;
                                }
                                     else{
                                    DietBool=false;
                                }
                                }
                            
                                if(M.Match_Maker__Skin_Tone_Complexion__c!=null && pro.Match_Maker__Skin_Tone_C__c!=null)
                                {
                                    if(M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c)){
                                    c++;
                                    SkinToneBool=true;
                                }
                                    else{
                                        SkinToneBool=false;
                                    }
                                }
                                if(M.Match_Maker__Material_Status__c.contains(pro.Match_Maker__Marital_Status__c)){
                                    c++;
                                    MaritalStatusBool=true;
                                }
                                else{
                                    MaritalStatusBool=false;
                                }
                                string newcontentid='';
                    ProfileMatchWrapper cm = new ProfileMatchWrapper();
                    cm.profilewrapper = pro;
                    cm.preferencewrapper= M;
                    cm.probability = ((c/14)*100).setScale(2);
                    cm.hideBool = true;
                    cm.ContentVersionId = '';
                    cm.AgeBool=AgeBool;
                    cm.HeightBool=HeightBool;
                    cm.ReligionBool=ReligionBool;
                    cm.HighestQualificationBool=HighestQualificationBool;
                    cm.AnnualIncomeBool=AnnualIncomeBool;
                    cm.ProfessionalAreaBool=ProfessionalAreaBool;
                    cm.HavingchildrenBool=HavingchildrenBool;
                    cm.ZodiacBool=ZodiacBool;
                    cm.workingwithBool=workingwithBool;
                    cm.SmokeBool=SmokeBool;
                    cm.AlocoholBool=AlocoholBool;
                    cm.DietBool=DietBool;
                    cm.SkinToneBool=SkinToneBool;
                  //  cm.NoOfChildrenBool=NoOfChildrenBool;
                    cm.MaritalStatusBool=MaritalStatusBool;
                    for(ContentDocumentLink cdl:pro.ContentDocumentLinks){
                        if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                            newcontentid=contentDocMap.get(cdl.ContentDocumentId);
                            if(newcontentid!=null){
                                cm.ContentVersionId='/sfc/servlet.shepherd/version/download/'+newcontentid;
                            }
                            else{
                                cm.ContentVersionId='https://s3-us-west-1.amazonaws.com/sfdc-demo/image-placeholder.png';
                            }
                            cm.ContentVersionId='/sfc/servlet.shepherd/version/download/'+newcontentid;
                            system.debug('cm.ContentVersionId== '+cm.ContentVersionId);
                            break;
                        }
                    }
                    roleWraps.add(cm);
                   
                               
                            }
                        }
                    }
                    else{
                        if(M.Match_Maker__Looking_for_Gender__c == pro.Match_Maker__Gender__c && M.Match_Maker__Min_Age__c<=profileAge &&
                           M.Match_Maker__Max_Age__c>=profileAge && M.Match_Maker__Min_Height__c<=profileHeight && 
                           M.Match_Maker__Max_Height__c>=profileHeight && pro.Id != M.Match_Maker__Profile__c &&
                           M.Match_Maker__Profile__r.Contact__c!=pro.Contact__c && M.Match_Maker__Profile__r.Contact__r.AccountId!=pro.Contact__r.AccountId
                           && pro.Match_Maker__Opposite_Gender__c == M.Match_Maker__Profile__r.Match_Maker__Gender__c && pro.Match_Maker__Active__c == true && 
                           (religions.contains(pro.Match_Maker__Religion__c)) && (M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c)
                           && ( (M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c)|| (M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c)     ||(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c))||   (M.Match_Maker__Material_Status__c.contains(pro.Match_Maker__Marital_Status__c))|| (M.Match_Maker__No_of_Children__c==pro.Match_Maker__No_of_Children__c)||  (M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c) ||(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c))   ||(M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c)||(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c)||( M.Match_Maker__Diet__c.contains(pro.Match_Maker__Your_Diet__c)) || (M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c) )))
                           
                        {
                            if((M.Match_Maker__Min_Age__c<=profileAge) && (M.Match_Maker__Max_Age__c>=profileAge) ){
                                c++;
                                AgeBool=true;
                            }
                            else{
                                    AgeBool=false;
                                }
                            if((M.Match_Maker__Min_Height__c<=profileHeight) && (M.Match_Maker__Max_Height__c>=profileHeight)){
                                c++;
                                HeightBool=true;
                            }
                            else{
                                    HeightBool=false;
                                }
                            if(M.Match_Maker__Highest_Qualification__c.contains(pro.Match_Maker__Highest_Qualification__c )|| M.Match_Maker__Highest_Qualification__c =='Open to All'){
                                c++;
                                HighestQualificationBool=true;
                            }
                            else{
                                    HighestQualificationBool=false;
                                }
                            if(M.Match_Maker__Annual_Income__c<=pro.Match_Maker__Income_yearly__c){
                                c++;
                                AnnualIncomeBool=true;
                            }
                             else{
                                    AnnualIncomeBool=false;
                                }
                            if(M.Match_Maker__Professional_Area__c==pro.Match_Maker__Professional_Area__c){
                                c++;
                                ProfessionalAreaBool=true;
                            }
                            else{
                                    ProfessionalAreaBool=false;
                                }
                            if(M.Match_Maker__Having_Children__c==pro.Match_Maker__Does_He_She_They_have_children__c|| M.Match_Maker__Having_Children__c == 'Does not matter'){
                                c++;
                                HavingchildrenBool=true;
                            }
                            else{
                                    HavingchildrenBool=false;
                                }
                            if(M.Match_Maker__Zodiac__c==pro.Match_Maker__Zodiac__c|| M.Match_Maker__Zodiac__c == 'Does not matter'){
                                    c++;
                                    ZodiacBool=true;
                                  }
                                  else{
                                    ZodiacBool=false;
                                }
                            if(M.Match_Maker__Working_with__c.contains(pro.Match_Maker__Working_with__c)  || M.Match_Maker__Working_with__c=='Open to All'){
                                c++;
                                workingwithBool=true;
                            }
                            else{
                                    workingwithBool=false;
                                }
                            if(M.Match_Maker__Does_Smoke__c==pro.Match_Maker__Smoke__c || M.Match_Maker__Does_Smoke__c == 'Does not matter'){
                                c++;
                                SmokeBool=true;
                            }
                            else{
                                    SmokeBool=false;
                                }
                            if(M.Match_Maker__Alcohol__c==pro.Match_Maker__Drinks__c || M.Match_Maker__Alcohol__c == 'Does not matter'){
                                c++;
                                AlocoholBool=true;
                            }
                            else{
                                    AlocoholBool=false;
                                }
                            if(M.Match_Maker__Diet__c!=null && pro.Match_Maker__Your_Diet__c!=null)
                            {
                                    if(M.Match_Maker__Diet__c.contains(pro.Match_Maker__Your_Diet__c) || M.Match_Maker__Diet__c =='Open to All'){
                                    c++;
                                    DietBool=true;
                                }
                                 else{
                                    DietBool=false;
                                }
                                }
                      
                           if(M.Match_Maker__Skin_Tone_Complexion__c!=null && pro.Match_Maker__Skin_Tone_C__c!=null)
                                {
                                    system.debug('M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c)======'+M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c));
                                    if(M.Match_Maker__Skin_Tone_Complexion__c.contains(pro.Match_Maker__Skin_Tone_C__c) || M.Match_Maker__Skin_Tone_Complexion__c =='Open to All'){
                                    c++;
                                    SkinToneBool=true;
                                }
                                    else{
                                         SkinToneBool=false;
                                    }
                                }
                            if(M.Match_Maker__Material_Status__c.contains(pro.Match_Maker__Marital_Status__c) || M.Match_Maker__Material_Status__c =='Open to All'){
                                c++;
                                MaritalStatusBool=true;
                            }
                            else{
                                    MaritalStatusBool=false;
                                }
                            if(M.Match_Maker__Religion__c.contains(pro.Match_Maker__Religion__c)){
                                c++;
                                ReligionBool=true;
                            }
                            else{
                                    ReligionBool=false;
                                }
                            string newcontentid='';
                    ProfileMatchWrapper cm = new ProfileMatchWrapper();
                    cm.profilewrapper = pro;
                    cm.preferencewrapper= M;
                    cm.probability = ((c/14)*100).setScale(2);
                    cm.hideBool = true;
                    cm.ContentVersionId = '';
                    cm.AgeBool=AgeBool;
                    cm.HeightBool=HeightBool;
                    cm.ReligionBool=ReligionBool;
                    cm.HighestQualificationBool=HighestQualificationBool;
                    cm.AnnualIncomeBool=AnnualIncomeBool;
                    cm.ProfessionalAreaBool=ProfessionalAreaBool;
                    cm.HavingchildrenBool=HavingchildrenBool;
                    cm.ZodiacBool=ZodiacBool;
                    cm.workingwithBool=workingwithBool;
                    cm.SmokeBool=SmokeBool;
                    cm.AlocoholBool=AlocoholBool;
                    cm.DietBool=DietBool;
                    cm.SkinToneBool=SkinToneBool;
                 //   cm.NoOfChildrenBool=NoOfChildrenBool;
                    cm.MaritalStatusBool=MaritalStatusBool;
                    for(ContentDocumentLink cdl:pro.ContentDocumentLinks){
                        if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                            newcontentid=contentDocMap.get(cdl.ContentDocumentId);
                            if(newcontentid!=null){
                                cm.ContentVersionId='/sfc/servlet.shepherd/version/download/'+newcontentid;
                            }
                            else{
                                cm.ContentVersionId='https://s3-us-west-1.amazonaws.com/sfdc-demo/image-placeholder.png';
                            }
                            cm.ContentVersionId='/sfc/servlet.shepherd/version/download/'+newcontentid;
                            system.debug('cm.ContentVersionId== '+cm.ContentVersionId);
                            break;
                        }
                    }
                    roleWraps.add(cm);
                   
                           
                        }        
                       
                    }
                   
                }
            }
           
        }
       
       
        for(integer i = 0; i < roleWraps.size(); i++){
            for(integer j = 1; j < (roleWraps.size()-i); j++){
                Decimal firstValue = decimal.valueof(string.valueof(roleWraps[j-1].probability));
                Decimal nextValue = decimal.valueof(string.valueof(roleWraps[j].probability));
                //if firstValue < nextValue, swap the elements
                if(firstValue < nextValue){
                    ProfileMatchWrapper tmpValue = roleWraps[j-1];
                    roleWraps[j-1]=roleWraps[j];
                    roleWraps[j]=tmpValue;
                }
            }
        }
        system.debug('roleWraps==='+roleWraps);
        return  roleWraps;
    }
   
   
   
   
    @AuraEnabled
    public static string shortListedProfiles(List<String> lstRecordId, String matchpreferenceId){
        system.debug('lstRecordId=='+lstRecordId);
        set<Id> shortlistedIds = new set<Id>();
        for(string scid: lstRecordId){
            shortlistedIds.add(scid);
        }
        List<Match_Maker__Shortlisted_Contact__c> scprofsList = [select id,Name,Match_Maker__Profile__c ,Match_Maker__Match_Preference__c,Match_Maker__Match_Preference__r.Match_Maker__Profile__c  from
                                                                 Match_Maker__Shortlisted_Contact__c where Match_Maker__Match_Preference__c=:matchpreferenceId WITH SECURITY_ENFORCED];
       
        Map<Id,Match_Maker__Shortlisted_Contact__c> scprofsMap = new Map<Id,Match_Maker__Shortlisted_Contact__c>();
        for(Match_Maker__Shortlisted_Contact__c scprofs : scprofsList){
            scprofsMap.put(scprofs.Match_Maker__Profile__c ,scprofs);
        }
        //Map<Contact__c,Shortlisted_Contact__c> scprofsMap = new Map<Contact__c,Shortlisted_Contact__c>([select id,Name,Contact__c,Match_Preference__c,Match_Preference__r.Contact__c from Shortlisted_Contact__c where Match_Preference__c=:matchpreferenceId WITH SECURITY_ENFORCED]);
        system.debug('scprofsMap=='+scprofsMap);
        List<Match_Maker__Shortlisted_Contact__c> shortlisted = new List<Match_Maker__Shortlisted_Contact__c>();
        for(Match_Maker__Profile__c  cc : [Select id,Name from Match_Maker__Profile__c  where  id IN :shortlistedIds WITH SECURITY_ENFORCED]){
            if(!scprofsMap.containsKey(cc.Id)){
                Match_Maker__Shortlisted_Contact__c sc = new Match_Maker__Shortlisted_Contact__c();
                sc.Match_Maker__Profile__c  = cc.Id;
                sc.Match_Maker__Match_Preference__c =matchpreferenceId ;
               
                shortlisted.add(sc);
            }
        }
        system.debug('shortlisted=='+shortlisted.size());
        if(shortlisted.size()>0){
            if(Schema.sObjectType.Match_Maker__Shortlisted_Contact__c.isCreateable()){
                Insert shortlisted;
            }
           
        }
        return '';
       
    }
   
   
    public class ProfileMatchWrapper
    {
        @AuraEnabled public  Match_Maker__Profile__c  profilewrapper{get;set;}
        @AuraEnabled public  Match_Maker__Match_Preference__c  preferencewrapper   {get;set;}
        @AuraEnabled public Boolean hideBool {get;set;}
        @AuraEnabled public String  ContentVersionId {get;set;}
        @AuraEnabled public Decimal probability{get;set;}
        @AuraEnabled public Boolean AgeBool {get;set;}
        @AuraEnabled public Boolean HeightBool {get;set;}
        @AuraEnabled public Boolean ReligionBool {get;set;}
        @AuraEnabled public Boolean HighestQualificationBool {get;set;}
        @AuraEnabled public Boolean AnnualIncomeBool {get;set;}
        @AuraEnabled public Boolean ProfessionalAreaBool {get;set;}
        @AuraEnabled public Boolean HavingchildrenBool {get;set;}
        @AuraEnabled public Boolean ZodiacBool {get;set;}
        @AuraEnabled public Boolean workingwithBool {get;set;}
        @AuraEnabled public Boolean SmokeBool {get;set;}
        @AuraEnabled public Boolean AlocoholBool {get;set;}
        @AuraEnabled public Boolean DietBool {get;set;}
        @AuraEnabled public Boolean SkinToneBool {get;set;}
      //  @AuraEnabled public Boolean NoOfChildrenBool {get;set;}
        @AuraEnabled public Boolean MaritalStatusBool {get;set;}
        public  ProfileMatchWrapper(){
            //
        }  
    }
   
}