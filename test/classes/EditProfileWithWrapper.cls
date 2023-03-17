public without sharing class EditProfileWithWrapper {
    
    private static final String BASE_64_CHARS = ''
        + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        + 'abcdefghijklmnopqrstuvwxyz'
        + '0123456789+/';
    private class PicklistEntryBean {
        public Boolean active {get; set;}
        public String value {get; set;}
        public String validFor {get; set;}
    }
    public Map<String, List<String>> results {get;set;}
    private Map<String, Set<Integer>> cache;
    public Id profileId{set;get;}
    public Match_Maker__Profile__c pro {get;set;}
    public boolean submitted{set;get;}
    public boolean saved{set;get;}
    public boolean shouldRender {get;set;}
    public List<SelectOption> havingChildrenList {get; set;}
    public List<SelectOption> noOfChildrenList {get; set;}
    public List<SelectOption> stateCodeList{get; set;}
    public List<SelectOption> familyStateCodeList{get; set;}
    public Map<String, Integer> Base64CharCodes { get; set; }
    public Boolean isError {get;set;}  public String active;
    public String defaultValue;
    private ApexPages.StandardController controller;
    public list <ContentDocumentLink> files {set;get;}
    public List<VersionDataInner> listValueOfTextBox {set;get;}
    public String VersionData{get;set;}
    public String Title{get;set;}
    public Blob file{get;set;}
    public Blob img{get;set;}
    public Integer count = 1;   
    public List<Country> countries{set;get;}
    public List<State> states{set;get;}
    public class Country {
        public String label;
        public String value;
        public Country(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    public class State {
        public String label;
        public String value;
        public String dependingOn;
        
        public State(String label,String value, String dependingOn) {
            this.label = label;
            this.value = value;
            this.dependingOn = dependingOn;
        }
    }
    public class StateList {
        public List<State> stateList;
        
    }  
    public class ProfileWrapper{
        public	String name{get;set;}
        public	String contact{get;set;}
        public String email{get;set;}
        public  String Id{get;set;}
        public String countryCode{set;get;}
        public String phone{set;get;}
        public String gender{set;get;}
        public String lookingForGender{set;get;}
        public Date dob{set;get;}
        public String placeOfBirth{set;get;}
        public Time birthTime{set;get;}
        public String maritalStatus{set;get;}
        public String sexuality{set;get;}
        public String zodiac{set;get;}
        public String havingChildren{set;get;}
        public String noOfChildren{set;get;}
        public String challenges{set;get;}
        public String livesInCity{set;get;}
        public String livesInCountry{set;get;}
        public String livesInStreet{set;get;}
        public String livesInStateCode{set;get;}
        public String livesInPostalCode{set;get;}
        public String livingWithFamily{set;get;}
        public String familyCountryCode{set;get;}
        public String familyStreet{set;get;}
        public String familyCity{set;get;}
        public String familyStateCode{set;get;}
        public String familyPostalCode{set;get;}
        public String highestQualification{set;get;}
        public String collegeUniversityName{set;get;}
        public String workingWith{set;get;}
        public String companyName{set;get;}
        public String professionalArea{set;get;}
        public Decimal income{set;get;}
        public String religion{set;get;}
        public String otherReligion{set;get;}
        public String subReligion{set;get;}
        public String motherTongue{set;get;}
        public String bodyType{set;get;}
        public String bloodGroup{set;get;}
        public String height{set;get;}
        public String weight{set;get;}
        public String smoke{set;get;}
        public String drinks{set;get;}
        public String diet{set;get;}
        public String skinTone{set;get;}
        public String hobbbies{set;get;}
        public String interest{set;get;}
        public String music{set;get;}
        public String movies{set;get;}
        public String read{set;get;}
        public String cuisine{set;get;}
        public String sport{set;get;}
        public String dress{set;get;}
        public String fatherStatus{set;get;}
        public String motherStatus{set;get;}
        public Decimal brother{set;get;}
        public Decimal marriedBrother{set;get;}
        public Decimal sister{set;get;}
        public Decimal marriedSister{set;get;}
        public String familyStatus{set;get;}
        public String familyType{set;get;}
        public String status{set;get;}
        public String label{set;get;}
        public String value{set;get;}
        public String validFor{set;get;}
    }
    public ProfileWrapper profilew {get;set;} 
    
    public editProfileWithWrapper() {
        try{
            submitted=false;
            saved=false;
            shouldRender=false;
            
            String profileId  = ApexPages.CurrentPage().getparameters().get('id'); 
            pro = [select Id,Name,Match_Maker__Active__c,Match_Maker__Contact__c,Match_Maker__Email__c,Match_Maker__Country_Code__c,Match_Maker__Zodiac__c,Match_Maker__Mobile__c,Match_Maker__Gender__c,Match_Maker__Opposite_Gender__c,Match_Maker__DOB__c,Match_Maker__Age__c,Match_Maker__Place_of_Birth__c,Match_Maker__Birth_Time__c,Match_Maker__Marital_Status__c,Match_Maker__Sexuality__c,Match_Maker__Does_He_She_They_have_children__c,Match_Maker__No_of_Children__c,Match_Maker__Challenges__c,
                   Match_Maker__Lives_In__City__s,Match_Maker__Lives_In__CountryCode__s,Match_Maker__Lives_In__Street__s,Match_Maker__Lives_In__StateCode__s,Match_Maker__Lives_In__PostalCode__s,Match_Maker__Living_with_Family__c,Match_Maker__Family_Lives_In__CountryCode__s,Match_Maker__Family_Lives_In__Street__s,Match_Maker__Family_Lives_In__City__s,Match_Maker__Family_Lives_In__StateCode__s,Match_Maker__Family_Lives_In__PostalCode__s,Match_Maker__Highest_Qualification__c,
                   Match_Maker__College_University_Name__c,Match_Maker__Working_with__c,Match_Maker__Company_Name_current__c,Match_Maker__Professional_Area__c,Match_Maker__Income_yearly__c,Match_Maker__Body_Type__c,Match_Maker__Blood_Group__c,Match_Maker__Weight__c,Match_Maker__Smoke__c,Match_Maker__Drinks__c,Match_Maker__Your_Diet__c,Match_Maker__Skin_Tone_C__c,Match_Maker__Hobbies__c,Match_Maker__Interest__c,Match_Maker__Favourite_Music__c,Match_Maker__Preferred_Movies__c,
                   Match_Maker__Favourite_Read__c,Match_Maker__Favourite_Criuisne__c,Match_Maker__Sport_Fitness_Activities__c,Match_Maker__Preferred_Dress_Style__c,Match_Maker__Father_Status__c,Match_Maker__Height__c,Match_Maker__Community_Mother_Tounge__c,Match_Maker__Sub_Religion__c,Match_Maker__Other_Religion__c,Match_Maker__Religion__c,Match_Maker__Mother_Status__c,Match_Maker__No_of_Brothers__c,Match_Maker__Number_of_Married_Brother__c,Match_Maker__No_of_Sisters__c,
                   Match_Maker__No_of_Married_Sisters__c,Match_Maker__Family_Status__c,Match_Maker__Family_Type__c,Match_Maker__Status__c,Match_Maker__Submitted__c from Match_Maker__Profile__c where id=:ProfileId];
            
            profilew = new ProfileWrapper();
            submitted =pro.Match_Maker__Active__c;
            profilew.Id = pro.Id;
            profilew.name = pro.Name;
            profilew.contact = pro.Match_Maker__Contact__c;
            profilew.email = pro.Match_Maker__Email__c;
            profilew.countryCode=pro.Match_Maker__Country_Code__c;
            profilew.phone=pro.Match_Maker__Mobile__c;
            profilew.gender=pro.Match_Maker__Gender__c;
            profilew.lookingForGender=pro.Match_Maker__Opposite_Gender__c;
            profilew.dob=pro.Match_Maker__DOB__c;
            profilew.placeOfBirth=pro.Match_Maker__Place_of_Birth__c;
            profilew.birthTime=pro.Match_Maker__Birth_Time__c;
            profilew.maritalStatus=pro.Match_Maker__Marital_Status__c;
            profilew.sexuality=pro.Match_Maker__Sexuality__c; 
            profilew.zodiac=pro.Match_Maker__Zodiac__c;
            profilew.havingChildren=pro.Match_Maker__Does_He_She_They_have_children__c;
            System.debug('profilew.havingChildren'+profilew.havingChildren);
            profilew.noOfChildren=pro.Match_Maker__No_of_Children__c;
            System.debug('Number OF Children'+profilew.noOfChildren);
            profilew.challenges=pro.Match_Maker__Challenges__c;
            profilew.livesInCity=pro.Match_Maker__Lives_In__City__s;
            profilew.livesInCountry=pro.Match_Maker__Lives_In__CountryCode__s;
            System.debug('Country values'+pro.Match_Maker__Lives_In__CountryCode__s);
            profilew.livesInStreet=pro.Match_Maker__Lives_In__Street__s;
            profilew.livesInStateCode=pro.Match_Maker__Lives_In__StateCode__s;
            System.debug('Country values'+pro.Match_Maker__Lives_In__StateCode__s);
            profilew.livesInPostalCode=pro.Match_Maker__Lives_In__PostalCode__s;
            profilew.livingWithFamily=pro.Match_Maker__Living_with_Family__c;
            profilew.familyCountryCode=pro.Match_Maker__Family_Lives_In__CountryCode__s;
            profilew.familyStreet=pro.Match_Maker__Family_Lives_In__Street__s;
            profilew.familyCity=pro.Match_Maker__Family_Lives_In__City__s;
            profilew.familyStateCode=pro.Match_Maker__Family_Lives_In__StateCode__s;
            profilew.familyPostalCode=pro.Match_Maker__Family_Lives_In__PostalCode__s;
            profilew.highestQualification=pro.Match_Maker__Highest_Qualification__c;
            profilew.collegeUniversityName=pro.Match_Maker__College_University_Name__c;
            profilew.workingWith=pro.Match_Maker__Working_with__c;
            profilew.companyName=pro.Match_Maker__Company_Name_current__c;
            profilew.professionalArea=pro.Match_Maker__Professional_Area__c;
            profilew.income=pro.Match_Maker__Income_yearly__c;
            profilew.religion=pro.Match_Maker__Religion__c;
            profilew.otherReligion=pro.Match_Maker__Other_Religion__c;
            profilew.subReligion=pro.Match_Maker__Sub_Religion__c;
            profilew.motherTongue=pro.Match_Maker__Community_Mother_Tounge__c;
            profilew.bodyType=pro.Match_Maker__Body_Type__c;
            profilew.bloodGroup=pro.Match_Maker__Blood_Group__c;
            profilew.height=pro.Match_Maker__Height__c;
            profilew.weight=pro.Match_Maker__Weight__c;
            profilew.smoke=pro.Match_Maker__Smoke__c;
            profilew.drinks=pro.Match_Maker__Drinks__c;
            profilew.diet=pro.Match_Maker__Your_Diet__c;
            profilew.skinTone=pro.Match_Maker__Skin_Tone_C__c;
            profilew.hobbbies=pro.Match_Maker__Hobbies__c;
            profilew.interest=pro.Match_Maker__Interest__c;
            profilew.music=pro.Match_Maker__Favourite_Music__c;
            profilew.movies=pro.Match_Maker__Preferred_Movies__c;
            profilew.read=pro.Match_Maker__Favourite_Read__c;
            profilew.cuisine=pro.Match_Maker__Favourite_Criuisne__c;
            profilew.sport=pro.Match_Maker__Sport_Fitness_Activities__c;
            profilew.dress=pro.Match_Maker__Preferred_Dress_Style__c;
            profilew.fatherStatus=pro.Match_Maker__Father_Status__c;
            profilew.motherStatus=pro.Match_Maker__Mother_Status__c;
            System.debug('motherStatus1'+profilew.motherStatus);
            profilew.brother=pro.Match_Maker__No_of_Brothers__c;
            profilew.marriedBrother=pro.Match_Maker__Number_of_Married_Brother__c;
            profilew.sister=pro.Match_Maker__No_of_Sisters__c;
            profilew.marriedSister=pro.Match_Maker__No_of_Married_Sisters__c;
            profilew.familyStatus=pro.Match_Maker__Family_Status__c;
            profilew.familyType=pro.Match_Maker__Family_Type__c;
            profilew.status=pro.Match_Maker__Status__c;
            results = new Map<String, List<String>>();
            listvalueOfTextBox = new List<VersionDataInner>();
            states = new List<State>();
            countries=new List<Country>();
            this.controller = controller;
            if(profilew.havingChildren  == 'No' || profilew.havingChildren  == ''||profilew.havingChildren  == null){
                shouldRender = true;
                profilew.noOfChildren='';
            }
            else{
                shouldRender = false; 
            }
            havingChildrenList = new List<SelectOption>();
            noOfChildrenList = new List<SelectOption>();
            havingChildrenList.add(new SelectOption('','--None--'));
            for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Does_He_She_They_have_children__c.getDescribe().getPicklistValues()){
                //SObjectField controllingPicklist = Match_Maker__Profile__c.Match_Maker__No_of_Children__c.getDescribe().getController();
                havingChildrenList.add(new SelectOption(c.getLabel(),c.getValue()));
            }
            noOfChildrenList.add(new SelectOption('','--None--'));
            for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__No_of_Children__c.getDescribe().getPicklistValues()){
                //SObjectField controllingPicklist = Match_Maker__Profile__c.Match_Maker__No_of_Children__c.getDescribe().getController();
                noOfChildrenList.add(new SelectOption(c.getLabel(),c.getValue()));
            }
            stateCodeList=new List<SelectOption>();
            stateCodeList.add(new SelectOption('','--None--'));
           /* for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Lives_In__StateCode__s.getDescribe().getPicklistValues()){
                //SObjectField controllingPicklist = Match_Maker__Profile__c.Match_Maker__Lives_In__StateCode__s.getDescribe().getController();
                stateCodeList.add(new SelectOption(c.getValue(),c.getValue()));
            }*/
            familyStateCodeList=new List<SelectOption>();
            familyStateCodeList.add(new SelectOption('','--None--'));
           /* for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Family_Lives_In__StateCode__s.getDescribe().getPicklistValues()){
                //SObjectField controllingPicklist = Match_Maker__Profile__c.Match_Maker__Lives_In__StateCode__s.getDescribe().getController();
                familyStateCodeList.add(new SelectOption(c.getValue(),c.getValue()));
            }*/
             if (pro.Match_Maker__Lives_In__CountryCode__s != null  ) {
            
            cache = new Map<String, Set<Integer>>();
            
            List<String> controllingValues = new List<String>();
            String selectedCountry=(String)profilew.livesInCountry;
            
            for (PicklistEntry pe : Match_Maker__Profile__c.Match_Maker__Lives_In__CountryCode__s.getDescribe().getPicklistValues()) {
                if (pe.isActive() && pe.getValue()!=null && pe.getValue()!='') {
                    results.put(pe.getValue(), new String[] {});
                    
                    controllingValues.add(pe.getValue());
                    
                }
            }
            System.debug('results initial'+results);  
            System.debug('controllingValues'+controllingValues);
            set<String> stateValue=new set<String>();
            System.debug('selectedCountry'+selectedCountry);
            for (PicklistEntryBean pe : picklistEntryBeans(Match_Maker__Profile__c.Match_Maker__Lives_In__StateCode__s.getDescribe().getPicklistValues())) {
                if (pe.active ) {
                    for (Integer index : validForToIndices(pe.validFor)) {
                        if(controllingValues.get(index)==selectedCountry){
                            results.get(controllingValues.get(index)).add(pe.value);
                        } 
                    } 
                }
            }
            System.debug('results final========='+results); 
            for(String idValue : results.keyset())
            { 
                stateValue.addAll(results.get(idValue));
            }
            System.debug('stateCodeList============'+stateCodeList);
            List<String> stateStrings = new List<String>(stateValue);
            for( String c:stateStrings){
                stateCodeList.add(new SelectOption(c,c));
            }
            System.debug('stateCodeList'+stateCodeList);
        }
            if (pro.Match_Maker__Family_Lives_In__CountryCode__s != null  ) {
            
            cache = new Map<String, Set<Integer>>();
            
            List<String> controllingValues = new List<String>();
            String selectedCountry=(String)profilew.familyCountryCode;
            
            for (PicklistEntry pe : Match_Maker__Profile__c.Match_Maker__Family_Lives_In__CountryCode__s.getDescribe().getPicklistValues()) {
                if (pe.isActive() && pe.getValue()!=null && pe.getValue()!='') {
                    results.put(pe.getValue(), new String[] {});
                    controllingValues.add(pe.getValue());
                }
            }
            System.debug('results initial'+results);  
            System.debug('controllingValues'+controllingValues);
            set<String> stateValue=new set<String>();
            System.debug('selectedCountry'+selectedCountry);
            for (PicklistEntryBean pe : picklistEntryBeans(Match_Maker__Profile__c.Match_Maker__Family_Lives_In__StateCode__s.getDescribe().getPicklistValues())) {
                if (pe.active ) {
                    for (Integer index : validForToIndices(pe.validFor)) {
                        if(controllingValues.get(index)==selectedCountry){
                            results.get(controllingValues.get(index)).add(pe.value);
                        } 
                    } 
                }
            }
            System.debug('results final========='+results); 
            for(String idValue : results.keyset())
            { 
                stateValue.addAll(results.get(idValue));
            }
            System.debug('familyStateCodeList============'+familyStateCodeList);
            List<String> stateStrings = new List<String>(stateValue);
            for( String c:stateStrings){
                familyStateCodeList.add(new SelectOption(c,c));
            }
            System.debug('familyStateCodeList'+familyStateCodeList);
        }
        }
        catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Message '+e.getMessage()));
        }
    }
    public PageReference  doSave() {
        
        PageReference result=null;
        List<ContentVersion> listToInsert = new List<ContentVersion>() ; 
        System.debug('Country values'+profilew.livesInCountry);
        Match_Maker__Profile__c toUpdateProfile = new Match_Maker__Profile__c ();
        toUpdateProfile.Id =profilew.Id;
        toUpdateProfile.Name =profilew.Name;
        toUpdateProfile.Match_Maker__Email__c =profilew.email;
        toUpdateProfile.Match_Maker__Country_Code__c=profilew.countryCode;
        toUpdateProfile.Match_Maker__Mobile__c=profilew.phone; 
        if(String.IsBlank(profilew.gender)) {
            pro.Match_Maker__Gender__c.addError('Please select Gender value');
            saved =false; 
            return null;
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Gender value'));
        }
        else{
            toUpdateProfile.Match_Maker__Gender__c=profilew.gender;
        }
        // toUpdateProfile.Match_Maker__Gender__c=profilew.gender;
        if(String.IsBlank(profilew.lookingForGender)) {
            pro.Match_Maker__Opposite_Gender__c.addError('Please select Looking for Gender value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Opposite_Gender__c=profilew.lookingForGender;
        }
        
        toUpdateProfile.Match_Maker__DOB__c= profilew.dob;
        toUpdateProfile.Match_Maker__Place_of_Birth__c=profilew.placeOfBirth;
        toUpdateProfile.Match_Maker__Birth_Time__c=profilew.birthTime;
        if(String.IsBlank(profilew.maritalStatus)) {
            pro.Match_Maker__Marital_Status__c.addError('Please select Marital Status value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Marital_Status__c=profilew.maritalStatus;
        }  
        //toUpdateProfile.Match_Maker__Marital_Status__c=profilew.maritalStatus;
        if(String.IsBlank(profilew.sexuality)) {
            pro.Match_Maker__Sexuality__c.addError('Please select Sexuality value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Sexuality__c=profilew.sexuality;
        }
        //toUpdateProfile.Match_Maker__Sexuality__c=profilew.sexuality;
         if(String.IsBlank(profilew.zodiac)){
            pro.Match_Maker__Zodiac__c.addError('Please select Zodiac value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Zodiac__c=profilew.zodiac;
        }
        if(String.IsBlank(profilew.havingChildren)){
            pro.Match_Maker__Does_He_She_They_have_children__c.addError('Please select Does He/She/They have children? value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Does_He_She_They_have_children__c=profilew.havingChildren;
        }
        //toUpdateProfile.Match_Maker__Does_He_She_They_have_children__c=profilew.havingChildren;
        toUpdateProfile.Match_Maker__No_of_Children__c=profilew.noOfChildren;
        toUpdateProfile.Match_Maker__Challenges__c=profilew.challenges;
        toUpdateProfile.Match_Maker__Lives_In__City__s=profilew.livesInCity;
        toUpdateProfile.Match_Maker__Lives_In__CountryCode__s=profilew.livesInCountry;
        System.debug('Country values============='+profilew.livesInCountry);
        toUpdateProfile.Match_Maker__Lives_In__Street__s=profilew.livesInStreet;
        toUpdateProfile.Match_Maker__Lives_In__StateCode__s=profilew.livesInStateCode;
        toUpdateProfile.Match_Maker__Lives_In__PostalCode__s=profilew.livesInPostalCode;
        toUpdateProfile.Match_Maker__Living_with_Family__c=profilew.livingWithFamily;
        toUpdateProfile.Match_Maker__Family_Lives_In__CountryCode__s=profilew.familyCountryCode;
        toUpdateProfile.Match_Maker__Family_Lives_In__Street__s=profilew.familyStreet;
        toUpdateProfile.Match_Maker__Family_Lives_In__City__s=profilew.familyCity;
        toUpdateProfile.Match_Maker__Family_Lives_In__StateCode__s=profilew.familyStateCode;
        toUpdateProfile.Match_Maker__Family_Lives_In__PostalCode__s=profilew.familyPostalCode;
        if(String.IsBlank(profilew.highestQualification)) {
            pro.Match_Maker__Highest_Qualification__c.addError('Please select Highest Qualification value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Highest_Qualification__c=profilew.highestQualification;
        }
        //toUpdateProfile.Match_Maker__Highest_Qualification__c=profilew.highestQualification;
        toUpdateProfile.Match_Maker__College_University_Name__c=profilew.collegeUniversityName;
        if(String.IsBlank(profilew.workingWith)) {
            pro.Match_Maker__Working_with__c.addError('Please select Working with value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Working_with__c=profilew.workingWith;
        }
        //toUpdateProfile.Match_Maker__Working_with__c=profilew.workingWith;
        toUpdateProfile.Match_Maker__Company_Name_current__c=profilew.companyName;
        toUpdateProfile.Match_Maker__Professional_Area__c=profilew.professionalArea;
        toUpdateProfile.Match_Maker__Income_yearly__c=profilew.income;
        if(String.IsBlank(profilew.religion)) {
            pro.Match_Maker__Religion__c.addError('Please select Religion value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Religion__c=profilew.religion;
        }
        //toUpdateProfile.Match_Maker__Religion__c=profilew.religion;
        toUpdateProfile.Match_Maker__Other_Religion__c=profilew.otherReligion;
        toUpdateProfile.Match_Maker__Sub_Religion__c=profilew.subReligion;
        toUpdateProfile.Match_Maker__Community_Mother_Tounge__c=profilew.motherTongue;
        toUpdateProfile.Match_Maker__Body_Type__c=profilew.bodyType;
        toUpdateProfile.Match_Maker__Blood_Group__c=profilew.bloodGroup;
        if(String.IsBlank(profilew.height)) {
            pro.Match_Maker__Height__c.addError('Please select Height value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Height__c=profilew.height;
        }
        //toUpdateProfile.Match_Maker__Height__c=profilew.height;
        toUpdateProfile.Match_Maker__Weight__c=profilew.weight;
        if(String.IsBlank(profilew.smoke)) {
            pro.Match_Maker__Smoke__c.addError('Please select Does Smoke value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Smoke__c=profilew.smoke;
        }
        //toUpdateProfile.Match_Maker__Smoke__c=profilew.smoke;
        if(String.IsBlank(profilew.drinks)) {
            pro.Match_Maker__Drinks__c.addError('Please select Alcohol value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Drinks__c=profilew.drinks;
        }
        //toUpdateProfile.Match_Maker__Drinks__c=profilew.drinks;
        if(String.IsBlank(profilew.diet)) {
            pro.Match_Maker__Your_Diet__c.addError('Please select Diet value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Your_Diet__c=profilew.diet;
        }
        //toUpdateProfile.Match_Maker__Your_Diet__c=profilew.diet;
        if(String.IsBlank(profilew.skinTone)) {
            pro.Match_Maker__Skin_Tone_C__c.addError('Please select Skin Tone value');
            saved =false; 
            return null;
        }
        else{
            toUpdateProfile.Match_Maker__Skin_Tone_C__c=profilew.skinTone;
        }
        toUpdateProfile.Match_Maker__Hobbies__c=profilew.hobbbies;
        toUpdateProfile.Match_Maker__Interest__c=profilew.interest;
        toUpdateProfile.Match_Maker__Favourite_Music__c=profilew.music;
        toUpdateProfile.Match_Maker__Preferred_Movies__c=profilew.movies;
        toUpdateProfile.Match_Maker__Favourite_Read__c=profilew.read;
        toUpdateProfile.Match_Maker__Favourite_Criuisne__c=profilew.cuisine;
        toUpdateProfile.Match_Maker__Sport_Fitness_Activities__c=profilew.sport;
        toUpdateProfile.Match_Maker__Preferred_Dress_Style__c=profilew.dress;
        toUpdateProfile.Match_Maker__Father_Status__c=profilew.fatherStatus;
        toUpdateProfile.Match_Maker__Mother_Status__c=profilew.motherStatus;
        System.debug('motherStatus2'+profilew.motherStatus);
        toUpdateProfile.Match_Maker__No_of_Brothers__c=profilew.brother;
        toUpdateProfile.Match_Maker__Number_of_Married_Brother__c=profilew.marriedBrother;
        toUpdateProfile.Match_Maker__No_of_Sisters__c=profilew.sister;
        toUpdateProfile.Match_Maker__No_of_Married_Sisters__c=profilew.marriedSister;
        toUpdateProfile.Match_Maker__Family_Status__c=profilew.familyStatus;
        toUpdateProfile.Match_Maker__Family_Type__c=profilew.familyType;
        try{
            upsert toUpdateProfile; 
            
            if(listvalueOfTextBox!=null){
                
                for(VersionDataInner v: listvalueOfTextBox)  
                { 
                    if(String.IsBlank(v.Title)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select files for choose files')); 
                        saved =false; 
                        return null;
                        
                    }
                    else{
                        System.debug('listvalueOfTextBox'+listvalueOfTextBox);
                        for(VersionDataInner a: listvalueOfTextBox)  
                        { 
                            
                            listToInsert.add(new ContentVersion (
                                Title = a.Title,
                                VersionData = a.file,
                                PathOnClient = a.Title
                            ));
                            
                        }
                        
                        System.debug('listToInsert'+listToInsert);
                        insert listToInsert;
                        ContentDocumentLink[] cdls = new List<ContentDocumentLink>();
                        for (ContentVersion cv: [select ContentDocumentId FROM ContentVersion WHERE Id IN: listToInsert]) {
                            cdls.add(new ContentDocumentLink (
                                LinkedEntityId = pro.Id,
                                ShareType = 'V',    
                                ContentDocumentId = cv.ContentDocumentId)   
                                    );
                        }
                        try{
                            insert cdls;
                            System.debug('cdls========'+cdls);
                        } 
                        
                        catch (DMLException e) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                            listToInsert.clear();
                            System.debug('Exception e '+e);
                            System.debug('Exception e '+e.getLineNumber());
                            saved =false; 
                            count=null;
                            return null;
                        } 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,+'Attachment uploaded successfully'));
                        Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.Confirm,'Your profile Saved Successfully')); 
                        saved =true; 
                        count=null;
                        listvalueOfTextBox.clear();
                        listToInsert.clear();
                        return null;
                    } 
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Your profile Saved Successfully'));
                count=null;
                listToInsert.clear(); 
                saved =true; 
                return null;
            }
            else
            {
                saved =false; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Refresh Page'));
                listToInsert.clear();
                count=null;
                return ApexPages.currentPage();
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Enter Correct values'));
            listToInsert.clear(); 
            count=null;
            saved =false; 
            return null;
        }
    }
    public pagereference doSubmit() {
        try{
            if(profilew.status=='Request for Completion')
            {
                Match_Maker__Profile__c toUpdateProfile = new Match_Maker__Profile__c ();
                toUpdateProfile.Id =profilew.Id;
                toUpdateProfile.Name =profilew.Name;
                toUpdateProfile.Match_Maker__Email__c =profilew.email;
                toUpdateProfile.Match_Maker__Country_Code__c=profilew.countryCode;
                toUpdateProfile.Match_Maker__Mobile__c=profilew.phone;
                toUpdateProfile.Match_Maker__Gender__c=profilew.gender;
                toUpdateProfile.Match_Maker__Opposite_Gender__c=profilew.lookingForGender;
                toUpdateProfile.Match_Maker__DOB__c= profilew.dob;
                toUpdateProfile.Match_Maker__Place_of_Birth__c=profilew.placeOfBirth;
                toUpdateProfile.Match_Maker__Birth_Time__c=profilew.birthTime;
                toUpdateProfile.Match_Maker__Marital_Status__c=profilew.maritalStatus;
                toUpdateProfile.Match_Maker__Sexuality__c=profilew.sexuality;
                toUpdateProfile.Match_Maker__Zodiac__c=profilew.zodiac;   
                toUpdateProfile.Match_Maker__Does_He_She_They_have_children__c=profilew.havingChildren;
                toUpdateProfile.Match_Maker__No_of_Children__c=profilew.noOfChildren;
                toUpdateProfile.Match_Maker__Challenges__c=profilew.challenges;
                toUpdateProfile.Match_Maker__Lives_In__City__s=profilew.livesInCity;
                toUpdateProfile.Match_Maker__Lives_In__CountryCode__s=profilew.livesInCountry;
                toUpdateProfile.Match_Maker__Lives_In__Street__s=profilew.livesInStreet;
                toUpdateProfile.Match_Maker__Lives_In__StateCode__s=profilew.livesInStateCode;
                toUpdateProfile.Match_Maker__Lives_In__PostalCode__s=profilew.livesInPostalCode;
                toUpdateProfile.Match_Maker__Living_with_Family__c=profilew.livingWithFamily;
                toUpdateProfile.Match_Maker__Family_Lives_In__CountryCode__s=profilew.familyCountryCode;
                toUpdateProfile.Match_Maker__Family_Lives_In__Street__s=profilew.familyStreet;
                toUpdateProfile.Match_Maker__Family_Lives_In__City__s=profilew.familyCity;
                toUpdateProfile.Match_Maker__Family_Lives_In__StateCode__s=profilew.familyStateCode;
                toUpdateProfile.Match_Maker__Family_Lives_In__PostalCode__s=profilew.familyPostalCode;
                toUpdateProfile.Match_Maker__Highest_Qualification__c=profilew.highestQualification;
                toUpdateProfile.Match_Maker__College_University_Name__c=profilew.collegeUniversityName;
                toUpdateProfile.Match_Maker__Working_with__c=profilew.workingWith;
                toUpdateProfile.Match_Maker__Company_Name_current__c=profilew.companyName;
                toUpdateProfile.Match_Maker__Professional_Area__c=profilew.professionalArea;
                toUpdateProfile.Match_Maker__Income_yearly__c=profilew.income;
                toUpdateProfile.Match_Maker__Religion__c=profilew.religion;
                toUpdateProfile.Match_Maker__Other_Religion__c=profilew.otherReligion;
                toUpdateProfile.Match_Maker__Sub_Religion__c=profilew.subReligion;
                toUpdateProfile.Match_Maker__Community_Mother_Tounge__c=profilew.motherTongue;
                toUpdateProfile.Match_Maker__Body_Type__c=profilew.bodyType;
                toUpdateProfile.Match_Maker__Blood_Group__c=profilew.bloodGroup;
                toUpdateProfile.Match_Maker__Height__c=profilew.height;
                toUpdateProfile.Match_Maker__Weight__c=profilew.weight;
                toUpdateProfile.Match_Maker__Smoke__c=profilew.smoke;
                toUpdateProfile.Match_Maker__Drinks__c=profilew.drinks;
                toUpdateProfile.Match_Maker__Your_Diet__c=profilew.diet;
                toUpdateProfile.Match_Maker__Skin_Tone_C__c=profilew.skinTone;
                toUpdateProfile.Match_Maker__Hobbies__c=profilew.hobbbies;
                toUpdateProfile.Match_Maker__Interest__c=profilew.interest;
                toUpdateProfile.Match_Maker__Favourite_Music__c=profilew.music;
                toUpdateProfile.Match_Maker__Preferred_Movies__c=profilew.movies;
                toUpdateProfile.Match_Maker__Favourite_Read__c=profilew.read;
                toUpdateProfile.Match_Maker__Favourite_Criuisne__c=profilew.cuisine;
                toUpdateProfile.Match_Maker__Sport_Fitness_Activities__c=profilew.sport;
                toUpdateProfile.Match_Maker__Preferred_Dress_Style__c=profilew.dress;
                toUpdateProfile.Match_Maker__Father_Status__c=profilew.fatherStatus;
                toUpdateProfile.Match_Maker__Mother_Status__c=profilew.motherStatus;
                toUpdateProfile.Match_Maker__No_of_Brothers__c=profilew.brother;
                toUpdateProfile.Match_Maker__Number_of_Married_Brother__c=profilew.marriedBrother;
                toUpdateProfile.Match_Maker__No_of_Sisters__c=profilew.sister;
                toUpdateProfile.Match_Maker__No_of_Married_Sisters__c=profilew.marriedSister;
                toUpdateProfile.Match_Maker__Family_Status__c=profilew.familyStatus;
                toUpdateProfile.put('Match_Maker__Submitted__c',true);
                toUpdateProfile.put('Match_Maker__Status__c','Completed');
                toUpdateProfile.put('Match_Maker__Active__c',true); 
                update toUpdateProfile;
                Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.Confirm,'Your Profile Submitted Successfully'));
                Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.Confirm,'Your Profile Submitted Successfully'));
                pagereference pg= New pagereference ('/apex/ThankYouPageForSiteform');
                return pg; 
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Profile was alreary Submitted'));
                return null;
            }
        }
        catch(Exception e){
            //System.debug('Exception e '+e);
            //System.debug('Exception e '+e.getLineNumber());
            saved =false; 
            return null;
        }
    }
    
    
    public List<SelectOption> getcountryCode(){
        List<SelectOption> countryCodeList = new List<selectOption>();
        countryCodeList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Country_Code__c.getDescribe().getPicklistValues()){
            countryCodeList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return countryCodeList;
    } 
    public List<SelectOption> getgenderValues(){
        List<SelectOption> genderValuesList = new List<selectOption>();
        genderValuesList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Gender__c.getDescribe().getPicklistValues()){
            genderValuesList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return genderValuesList;
    } 
    public List<SelectOption> getlookingGenderValues(){
        List<SelectOption> lookingGenderValues = new List<selectOption>();
        lookingGenderValues.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Opposite_Gender__c.getDescribe().getPicklistValues()){
            lookingGenderValues.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return lookingGenderValues;
    } 
    public List<SelectOption> getmaritalStatusValues(){
        List<SelectOption> maritalStatusList = new List<selectOption>();
        maritalStatusList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Marital_Status__c.getDescribe().getPicklistValues()){
            maritalStatusList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return maritalStatusList;
    } 
    public List<SelectOption> getsexualityValues(){
        List<SelectOption> sexualityList = new List<selectOption>();
        sexualityList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Sexuality__c.getDescribe().getPicklistValues()){
            sexualityList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return sexualityList;
    } 
    public List<SelectOption> getzodiacValues(){
        List<SelectOption> zodiacList = new List<selectOption>();
        zodiacList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Zodiac__c.getDescribe().getPicklistValues()){
            zodiacList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return zodiacList;
    }
    
    public List<SelectOption> getchallengesValues(){
        List<SelectOption> challengesList = new List<selectOption>();
        challengesList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Challenges__c.getDescribe().getPicklistValues()){
            challengesList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return challengesList;
    } 
    public Map<String,String> getlivesincountryValues(){
        Map<String,String> mapLabelVal=new Map<String,String>();
        Schema.sObjectType objType = Match_Maker__Profile__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('Match_Maker__Lives_In__CountryCode__s').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values){
            mapLabelVal.put(a.getLabel(), a.getValue());
        }
        return mapLabelVal;
    }
    public Map<String,String> getfamilyCountryValues(){
        Map<String,String> mapLabelVal=new Map<String,String>();
        Schema.sObjectType objType = Match_Maker__Profile__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('Match_Maker__Family_Lives_In__CountryCode__s').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values){
            mapLabelVal.put(a.getLabel(), a.getValue());
        }
        return mapLabelVal;
    }
    public List<SelectOption> getlivingwithfamilyValues(){
        List<SelectOption> livingWithFamilyList = new List<selectOption>();
        livingWithFamilyList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Living_with_Family__c.getDescribe().getPicklistValues()){
            livingWithFamilyList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return livingWithFamilyList;
    }
    public List<SelectOption> gethighestQualificationValues(){
        List<SelectOption> highestQualificationList = new List<selectOption>();
        highestQualificationList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Highest_Qualification__c.getDescribe().getPicklistValues()){
            highestQualificationList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return highestQualificationList;
    }
    public List<SelectOption> getworkingwithValues(){
        List<SelectOption> workingWithList = new List<selectOption>();
        workingWithList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Working_with__c.getDescribe().getPicklistValues()){
            workingWithList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return workingWithList;
    }
    public List<SelectOption> getreligionValues(){
        List<SelectOption> religionList = new List<selectOption>();
        religionList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Religion__c.getDescribe().getPicklistValues()){
            religionList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return religionList;
    }  
    public List<SelectOption> getbodyTypeValues(){
        List<SelectOption> bodyTypeList = new List<selectOption>();
        bodyTypeList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Body_Type__c.getDescribe().getPicklistValues()){
            bodyTypeList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return bodyTypeList;
    } 
    public List<SelectOption> getbloodGroupValues(){
        List<SelectOption> bloodGroupList = new List<selectOption>();
        bloodGroupList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Blood_Group__c.getDescribe().getPicklistValues()){
            bloodGroupList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return bloodGroupList;
    }
    public List<SelectOption> getheightValues(){
        List<SelectOption> heightList = new List<selectOption>();
        heightList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Height__c.getDescribe().getPicklistValues()){
            heightList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return heightList;
    }  
    public List<SelectOption> getweightValues(){
        List<SelectOption> weightList = new List<selectOption>();
        weightList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Weight__c.getDescribe().getPicklistValues()){
            weightList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return weightList;
    }  
    public List<SelectOption> getsmokeValues(){
        List<SelectOption> smokeList = new List<selectOption>();
        smokeList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Smoke__c.getDescribe().getPicklistValues()){
            smokeList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return smokeList;
    }  
    public List<SelectOption> getdrinkValues(){
        List<SelectOption> drinkList = new List<selectOption>();
        drinkList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Drinks__c.getDescribe().getPicklistValues()){
            drinkList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return drinkList;
    }  
    public List<SelectOption> getdietValues(){
        List<SelectOption> dietList = new List<selectOption>();
        dietList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Your_Diet__c.getDescribe().getPicklistValues()){
            dietList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return dietList;
    }  
    public List<SelectOption> getskintoneValues(){
        List<SelectOption> skinToneList = new List<selectOption>();
        skinToneList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Skin_Tone_C__c.getDescribe().getPicklistValues()){
            skinToneList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return skinToneList;
    }  
    public List<SelectOption> getfatherstatusValues(){
        List<SelectOption> fatherStatusList = new List<selectOption>();
        fatherStatusList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Father_Status__c.getDescribe().getPicklistValues()){
            fatherStatusList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return fatherStatusList;
    }  
    public List<SelectOption> getmotherstatusValues(){
        List<SelectOption> motherStatusList = new List<selectOption>();
        motherStatusList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Mother_Status__c.getDescribe().getPicklistValues()){
            motherStatusList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return motherStatusList;
    } 
    public List<SelectOption> getfamilyeconomicalstatusValues(){
        List<SelectOption> familyEconomicalList = new List<selectOption>();
        familyEconomicalList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Family_Status__c.getDescribe().getPicklistValues()){
            familyEconomicalList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return familyEconomicalList;
    } 
    public List<SelectOption> getfamilytypeValues(){
        List<SelectOption> familyTypeList = new List<selectOption>();
        familyTypeList.add(new SelectOption('','-None-'));
        for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__Family_Type__c.getDescribe().getPicklistValues()){
            familyTypeList.add(new SelectOption(c.getLabel(),c.getValue()));
        }
        return familyTypeList;
    } 
    public void createDependPick(){
        noOfChildrenList.clear();
        noOfChildrenList.add(new SelectOption('','-None-'));
        if(profilew.havingChildren  == 'Yes - Living Together' || profilew.havingChildren  == 'Yes - Not Living together'){
            
            for(schema.picklistEntry c : Match_Maker__Profile__c.Match_Maker__No_of_Children__c.getDescribe().getPicklistValues()){
                
                noOfChildrenList.add(new SelectOption(c.getLabel(), c.getValue()));
                System.debug('noOfChildrenList'+noOfChildrenList);
                shouldRender = false; 
            }
        }
        else{
            shouldRender = true; 
        }
    }
    public void controllingToDependentValues() {
        System.debug('Method entered');
        
        stateCodeList = new List<SelectOption>();
        //stateCodeList = new List<String>();        
        stateCodeList.clear();
        stateCodeList.add(new SelectOption('','-None-'));
        
        results = new Map<String, List<String>>();
        
        if (pro.Match_Maker__Lives_In__CountryCode__s != null  ) {
            
            cache = new Map<String, Set<Integer>>();
            
            List<String> controllingValues = new List<String>();
            String selectedCountry=(String)profilew.livesInCountry;
            
            for (PicklistEntry pe : Match_Maker__Profile__c.Match_Maker__Lives_In__CountryCode__s.getDescribe().getPicklistValues()) {
                if (pe.isActive() && pe.getValue()!=null && pe.getValue()!='') {
                    results.put(pe.getValue(), new String[] {});
                    
                    controllingValues.add(pe.getValue());
                    
                }
            }
            System.debug('results initial'+results);  
            System.debug('controllingValues'+controllingValues);
            set<String> stateValue=new set<String>();
            System.debug('selectedCountry'+selectedCountry);
            for (PicklistEntryBean pe : picklistEntryBeans(Match_Maker__Profile__c.Match_Maker__Lives_In__StateCode__s.getDescribe().getPicklistValues())) {
                if (pe.active ) {
                    for (Integer index : validForToIndices(pe.validFor)) {
                        if(controllingValues.get(index)==selectedCountry){
                            results.get(controllingValues.get(index)).add(pe.value);
                        } 
                    } 
                }
            }
            System.debug('results final========='+results); 
            for(String idValue : results.keyset())
            { 
                stateValue.addAll(results.get(idValue));
            }
            System.debug('stateCodeList============'+stateCodeList);
            List<String> stateStrings = new List<String>(stateValue);
            for( String c:stateStrings){
                stateCodeList.add(new SelectOption(c,c));
            }
            System.debug('stateCodeList'+stateCodeList);
        }
    }
    public void familyControllingToDependentValues() {
        familyStateCodeList = new List<SelectOption>();
        //statecodelist = new List<String>();        
        familyStateCodeList.clear();
        familyStateCodeList.add(new SelectOption('','-None-'));
        
        results = new Map<String, List<String>>();
        
        if (pro.Match_Maker__Family_Lives_In__CountryCode__s != null  ) {
            
            cache = new Map<String, Set<Integer>>();
            
            List<String> controllingValues = new List<String>();
            String selectedCountry=(String)profilew.familyCountryCode;
            
            for (PicklistEntry pe : Match_Maker__Profile__c.Match_Maker__Family_Lives_In__CountryCode__s.getDescribe().getPicklistValues()) {
                if (pe.isActive() && pe.getValue()!=null && pe.getValue()!='') {
                    results.put(pe.getValue(), new String[] {});
                    controllingValues.add(pe.getValue());
                }
            }
            System.debug('results initial'+results);  
            System.debug('controllingValues'+controllingValues);
            set<String> stateValue=new set<String>();
            System.debug('selectedCountry'+selectedCountry);
            for (PicklistEntryBean pe : picklistEntryBeans(Match_Maker__Profile__c.Match_Maker__Family_Lives_In__StateCode__s.getDescribe().getPicklistValues())) {
                if (pe.active ) {
                    for (Integer index : validForToIndices(pe.validFor)) {
                        if(controllingValues.get(index)==selectedCountry){
                            results.get(controllingValues.get(index)).add(pe.value);
                        } 
                    } 
                }
            }
            System.debug('results final========='+results); 
            for(String idValue : results.keyset())
            { 
                stateValue.addAll(results.get(idValue));
            }
            System.debug('familyStateCodeList============'+familyStateCodeList);
            List<String> stateStrings = new List<String>(stateValue);
            for( String c:stateStrings){
                familyStateCodeList.add(new SelectOption(c,c));
            }
            System.debug('familyStateCodeList'+familyStateCodeList);
        }
    }
    private Set<Integer> validForToIndices(String validFor) {
        Set<Integer> indices = cache.get(validFor);
        if (indices == null) {
            indices = new Set<Integer>();
            String validForBits = base64ToBits(validFor);
            for (Integer i = validForBits.indexOf('1'); i >= 0; i = validForBits.indexOf('1', i + 1)) {
                indices.add(i);
            }
            cache.put(validFor, indices);
        }
        return indices;
    }
    
    private static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    private static String base64ToBits(String validFor) {
        
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = BASE_64_CHARS.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        return validForBits;
    }
    private static PicklistEntryBean[] picklistEntryBeans(List<PicklistEntry> pes) {
        
        return (List<PicklistEntryBean>) JSON.deserialize(JSON.serialize(pes), List<PicklistEntryBean>.class);
    }
    
    public class VersionDataInner
    {
        public string VersionData{get;set;}
        public string Title{get;set;}
        public Blob file{get;set;}
        public Blob img{get;set;}
        public String recCount{get;set;}
        public List<VersionDataInner> listValueOfTextBox {set;get;}
        public VersionDataInner(String VersionData)
        {   
            Integer intCount;
            listValueOfTextBox=new List<VersionDataInner>();
            this.VersionData = VersionData;
            recCount = String.valueOf(intCount);
        }
    }
    public PageReference addTextBox() 
    {  
        count=0;
        count = count+1;
        if(listvalueOfTextBox!=null){
            listvalueOfTextBox.add(new VersionDataInner('inputfile' + (listvalueOfTextBox.size() +  1)));
        }  
        return null;
    }
    public void Del(){
        listvalueOfTextBox.remove(Integer.valueOf(listvalueOfTextBox.size() -  1));
        count = count -1;
    }
    
}