@isTest
public class Test_Search_MM{
    
  @isTest
    public static void getMatchedProfilesTestMethod1(){
        List<Match_Maker__Shortlisted_Contact__c> shpf=new List<Match_Maker__Shortlisted_Contact__c>();
            Account acc=new Account();
        acc.Name ='Test1';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Test1';
        con.Email='test@test.com';
        insert con;
        
        Match_Maker__Profile__c pro=new Match_Maker__Profile__c();
        pro.Name='NK';
        pro.Match_Maker__Email__c='Nk@gmail.com';
        pro.Match_Maker__Mobile__c='1234567890';
        pro.Match_Maker__Gender__c='Male';
        pro.Match_Maker__Opposite_Gender__c='Female';
        pro.Match_Maker__DOB__c=Date.newInstance(1998, 2, 8);
        pro.Match_Maker__Marital_Status__c='Unmarried';
        pro.Match_Maker__Does_He_She_They_have_children__c='No';
        pro.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro.Match_Maker__Lives_In__StateCode__s='TG';
        pro.Match_Maker__Lives_In__City__s='hyderabad';
        pro.Match_Maker__Lives_In__CountryCode__s='IN';
        pro.Match_Maker__Lives_In__PostalCode__s='500081';
        pro.Match_Maker__Highest_Qualification__c='Bachelors';
        pro.Match_Maker__Working_with__c='Private Company';
        pro.Match_Maker__Religion__c='Hindu';
        pro.Match_Maker__Height__c='170 cm';
        pro.Match_Maker__Smoke__c='No';
        pro.Match_Maker__Drinks__c='No';
        pro.Match_Maker__Contact__c = con.id;
        pro.Match_Maker__Active__c=True;
        pro.Match_Maker__Professional_Area__c='Software Developer';
        pro.Match_Maker__Income_yearly__c=500000;
        pro.Match_Maker__Your_Diet__c='Non-Veg';
        pro.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro;
        
        Account acc2=new Account();
        acc2.Name ='Test2';
        insert acc2;
        
        Contact con2=new Contact();
        con2.AccountId=acc2.id;
        con2.LastName='Test2';
        con2.Email='test2@test.com';
        insert con2;
        
        Match_Maker__Profile__c pro2=new Match_Maker__Profile__c();
        pro2.Name='NKR';
        pro2.Match_Maker__Email__c='Nk2@gmail.com';
        pro2.Match_Maker__Mobile__c='1234567800';
        pro2.Match_Maker__Gender__c='Female';
        pro2.Match_Maker__Opposite_Gender__c='Male';
        pro2.Match_Maker__DOB__c=Date.newInstance(2001, 2, 8);
        pro2.Match_Maker__Marital_Status__c='Unmarried';
        pro2.Match_Maker__Does_He_She_They_have_children__c='No';
        pro2.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro2.Match_Maker__Lives_In__StateCode__s='TG';
        pro2.Match_Maker__Lives_In__City__s='hyderabad';
        pro2.Match_Maker__Lives_In__CountryCode__s='IN';
        pro2.Match_Maker__Lives_In__PostalCode__s='500081';
        pro2.Match_Maker__Highest_Qualification__c='Bachelors';
        pro2.Match_Maker__Working_with__c='Private Company';
        pro2.Match_Maker__Religion__c='Hindu';
        pro2.Match_Maker__Height__c='170 cm';
        pro2.Match_Maker__Smoke__c='No';
        pro2.Match_Maker__Drinks__c='No';
        pro2.Match_Maker__Contact__c = con2.id;
        pro2.Match_Maker__Active__c=True;
        pro2.Match_Maker__Professional_Area__c='Software Developer';
        pro2.Match_Maker__Income_yearly__c=1000000;
        pro2.Match_Maker__Your_Diet__c='Non-Veg';
        pro2.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro2;  
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        system.debug('ContentVersionID : ' + cvList[0].Id);
        Map<Id,String> contentDocMap=new Map<Id,String>();

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pro.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        System.assertEquals(cdl.ContentDocumentId,cvList[0].ContentDocumentId);
        contentDocMap.put(cdl.ContentDocumentId,cdl.id);
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=pro.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='130 cm';
        m.Match_Maker__Max_Height__c='220 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Hindu';
        m.Match_Maker__Material_Status__c='Unmarried';
        m.Match_Maker__Annual_Income__c=1000000;
        m.Match_Maker__Diet__c='Non-Veg';
        m.Match_Maker__Skin_Tone_Complexion__c='Open to All';
        m.Match_Maker__Alcohol__c = 'Does not matter';
        m.Match_Maker__Does_Smoke__c = 'No';
        insert m;
        Match_Maker__Match_Preference__c m1=new Match_Maker__Match_Preference__c();
        m1.Match_Maker__Profile__c=pro.id;
        m1.Match_Maker__Min_Age__c='18';
        m1.Match_Maker__Max_Age__c='40';
        m1.Match_Maker__Min_Height__c='130 cm';
        m1.Match_Maker__Max_Height__c='220 cm';
        m1.Match_Maker__Highest_Qualification__c='Bachelors';
        m1.Match_Maker__Working_with__c='Private Company';
        m1.Match_Maker__Religion__c='Open to All';
        m1.Match_Maker__Material_Status__c='Open to All';
        m1.Match_Maker__Annual_Income__c=1000000;
        m1.Match_Maker__Diet__c='Non-Veg';
        m1.Match_Maker__Skin_Tone_Complexion__c='Open to All';
        m1.Match_Maker__Alcohol__c = 'No';
        m1.Match_Maker__Does_Smoke__c = 'Does not matter';
        m1.Match_Maker__Professional_Area__c='Software Developer';
        m1.Match_Maker__Having_Children__c='No';
        insert m1;
        
        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=pro.id;
        s.Match_Maker__Match_Preference__c=m.Id;
        s.Match_Maker__Match_Preference__c=m1.Id;
        s.Match_Maker__Status__c='Selected';
        shpf.add(s);
        //string str='new';
        List<string> lststr= new List<String>();
        lststr.add(pro.id);
        test.startTest();
        // List<Search_MM.ProfileMatchWrapper> wrapper= Search_MM.getMatchedProfiles();
       Search_MM.getMatchedProfiles(m1.id);
        Search_MM.shortListedProfiles(lststr,m1.id);
        test.stopTest();
    }
  @isTest
    public static void getMatchedProfilesTestMethod2(){
        List<Match_Maker__Shortlisted_Contact__c> shpf=new List<Match_Maker__Shortlisted_Contact__c>();
            Account acc=new Account();
        acc.Name ='Test1';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Test1';
        con.Email='test@test.com';
        insert con;
        
        Match_Maker__Profile__c pro=new Match_Maker__Profile__c();
        pro.Name='NK';
        pro.Match_Maker__Email__c='Nk@gmail.com';
        pro.Match_Maker__Mobile__c='1234567890';
        pro.Match_Maker__Gender__c='Male';
        pro.Match_Maker__Opposite_Gender__c='Female';
        pro.Match_Maker__DOB__c=Date.newInstance(1998, 2, 8);
        pro.Match_Maker__Marital_Status__c='Unmarried';
        pro.Match_Maker__Does_He_She_They_have_children__c='No';
        pro.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro.Match_Maker__Lives_In__StateCode__s='TG';
        pro.Match_Maker__Lives_In__City__s='hyderabad';
        pro.Match_Maker__Lives_In__CountryCode__s='IN';
        pro.Match_Maker__Lives_In__PostalCode__s='500081';
        pro.Match_Maker__Highest_Qualification__c='Bachelors';
        pro.Match_Maker__Working_with__c='Private Company';
        pro.Match_Maker__Religion__c='Hindu';
        pro.Match_Maker__Height__c='170 cm';
        pro.Match_Maker__Smoke__c='No';
        pro.Match_Maker__Drinks__c='No';
        pro.Match_Maker__Contact__c = con.id;
        pro.Match_Maker__Active__c=True;
        pro.Match_Maker__Professional_Area__c='Software Developer';
        pro.Match_Maker__Income_yearly__c=500000;
        pro.Match_Maker__Your_Diet__c='Non-Veg';
        pro.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro;
        
        Account acc2=new Account();
        acc2.Name ='Test2';
        insert acc2;
        
        Contact con2=new Contact();
        con2.AccountId=acc2.id;
        con2.LastName='Test2';
        con2.Email='test2@test.com';
        insert con2;
        
        Match_Maker__Profile__c pro2=new Match_Maker__Profile__c();
        pro2.Name='NKR';
        pro2.Match_Maker__Email__c='Nk2@gmail.com';
        pro2.Match_Maker__Mobile__c='1234567800';
        pro2.Match_Maker__Gender__c='Female';
        pro2.Match_Maker__Opposite_Gender__c='Male';
        pro2.Match_Maker__DOB__c=Date.newInstance(2001, 2, 8);
        pro2.Match_Maker__Marital_Status__c='Unmarried';
        pro2.Match_Maker__Does_He_She_They_have_children__c='No';
        pro2.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro2.Match_Maker__Lives_In__StateCode__s='TG';
        pro2.Match_Maker__Lives_In__City__s='hyderabad';
        pro2.Match_Maker__Lives_In__CountryCode__s='IN';
        pro2.Match_Maker__Lives_In__PostalCode__s='500081';
        pro2.Match_Maker__Highest_Qualification__c='Bachelors';
        pro2.Match_Maker__Working_with__c='Private Company';
        pro2.Match_Maker__Religion__c='Hindu';
        pro2.Match_Maker__Height__c='170 cm';
        pro2.Match_Maker__Smoke__c='No';
        pro2.Match_Maker__Drinks__c='No';
        pro2.Match_Maker__Contact__c = con2.id;
        pro2.Match_Maker__Active__c=True;
        pro2.Match_Maker__Professional_Area__c='Software Developer';
        pro2.Match_Maker__Income_yearly__c=1000000;
        pro2.Match_Maker__Your_Diet__c='Non-Veg';
        pro2.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro2;  
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        system.debug('ContentVersionID : ' + cvList[0].Id);
        Map<Id,String> contentDocMap=new Map<Id,String>();

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pro.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        System.assertEquals(cdl.ContentDocumentId,cvList[0].ContentDocumentId);
        contentDocMap.put(cdl.ContentDocumentId,cdl.id);
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=pro.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='130 cm';
        m.Match_Maker__Max_Height__c='220 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Hindu';
        m.Match_Maker__Material_Status__c='Unmarried';
        m.Match_Maker__Annual_Income__c=1000000;
        m.Match_Maker__Diet__c='Non-Veg';
        m.Match_Maker__Skin_Tone_Complexion__c='Open to All';
        m.Match_Maker__Alcohol__c = 'Does not matter';
        m.Match_Maker__Does_Smoke__c = 'No';
        m.Match_Maker__Professional_Area__c='Software Developer';
        m.Match_Maker__Having_Children__c='No';
        insert m;
        Match_Maker__Match_Preference__c m1=new Match_Maker__Match_Preference__c();
        m1.Match_Maker__Profile__c=pro.id;
        m1.Match_Maker__Min_Age__c='18';
        m1.Match_Maker__Max_Age__c='40';
        m1.Match_Maker__Min_Height__c='130 cm';
        m1.Match_Maker__Max_Height__c='220 cm';
        m1.Match_Maker__Highest_Qualification__c='Bachelors';
        m1.Match_Maker__Working_with__c='Private Company';
        m1.Match_Maker__Religion__c='Open to All';
        m1.Match_Maker__Material_Status__c='Unmarried';
        m1.Match_Maker__Annual_Income__c=1000000;
        m1.Match_Maker__Diet__c='Non-Veg';
        m1.Match_Maker__Skin_Tone_Complexion__c='Normal';
        m1.Match_Maker__Alcohol__c = 'Does not matter';
        m1.Match_Maker__Does_Smoke__c = 'Does not matter';
        m1.Match_Maker__Professional_Area__c='Software Developer';
        m1.Match_Maker__Professional_Area__c='Software Developer';
        m1.Match_Maker__Having_Children__c='No';
        insert m1;
        
        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=pro.id;
        s.Match_Maker__Match_Preference__c=m1.Id;
        s.Match_Maker__Match_Preference__c=m1.Id;
        s.Match_Maker__Status__c='Selected';
        shpf.add(s);
        //string str='new';
        List<string> lststr= new List<String>();
        lststr.add(pro.id);
        test.startTest();
        // List<Search_MM.ProfileMatchWrapper> wrapper= Search_MM.getMatchedProfiles();
       Search_MM.getMatchedProfiles(m.id);
        Search_MM.shortListedProfiles(lststr,m.id);
        test.stopTest();
    }
  @isTest
    public static void getMatchedProfilesTestMethod3(){
        List<Match_Maker__Shortlisted_Contact__c> shpf=new List<Match_Maker__Shortlisted_Contact__c>();
            Account acc=new Account();
        acc.Name ='Test1';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Test1';
        con.Email='test@test.com';
        insert con;
        
        Match_Maker__Profile__c pro=new Match_Maker__Profile__c();
        pro.Name='NK';
        pro.Match_Maker__Email__c='Nk@gmail.com';
        pro.Match_Maker__Mobile__c='1234567890';
        pro.Match_Maker__Gender__c='Male';
        pro.Match_Maker__Opposite_Gender__c='Female';
        pro.Match_Maker__DOB__c=Date.newInstance(1998, 2, 8);
        pro.Match_Maker__Marital_Status__c='Unmarried';
        pro.Match_Maker__Does_He_She_They_have_children__c='No';
        pro.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro.Match_Maker__Lives_In__StateCode__s='TG';
        pro.Match_Maker__Lives_In__City__s='hyderabad';
        pro.Match_Maker__Lives_In__CountryCode__s='IN';
        pro.Match_Maker__Lives_In__PostalCode__s='500081';
        pro.Match_Maker__Highest_Qualification__c='Bachelors';
        pro.Match_Maker__Working_with__c='Private Company';
        pro.Match_Maker__Religion__c='Hindu';
        pro.Match_Maker__Height__c='170 cm';
        pro.Match_Maker__Smoke__c='No';
        pro.Match_Maker__Drinks__c='No';
        pro.Match_Maker__Contact__c = con.id;
        pro.Match_Maker__Active__c=True;
        pro.Match_Maker__Professional_Area__c='Software Developer';
        pro.Match_Maker__Income_yearly__c=500000;
        pro.Match_Maker__Your_Diet__c='Non-Veg';
        pro.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro;
        
        Account acc2=new Account();
        acc2.Name ='Test2';
        insert acc2;
        
        Contact con2=new Contact();
        con2.AccountId=acc2.id;
        con2.LastName='Test2';
        con2.Email='test2@test.com';
        insert con2;
        
        Match_Maker__Profile__c pro2=new Match_Maker__Profile__c();
        pro2.Name='NKR';
        pro2.Match_Maker__Email__c='Nk2@gmail.com';
        pro2.Match_Maker__Mobile__c='1234567800';
        pro2.Match_Maker__Gender__c='Female';
        pro2.Match_Maker__Opposite_Gender__c='Male';
        pro2.Match_Maker__DOB__c=Date.newInstance(2001, 2, 8);
        pro2.Match_Maker__Marital_Status__c='Unmarried';
        pro2.Match_Maker__Does_He_She_They_have_children__c='No';
        pro2.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro2.Match_Maker__Lives_In__StateCode__s='TG';
        pro2.Match_Maker__Lives_In__City__s='hyderabad';
        pro2.Match_Maker__Lives_In__CountryCode__s='IN';
        pro2.Match_Maker__Lives_In__PostalCode__s='500081';
        pro2.Match_Maker__Highest_Qualification__c='Bachelors';
        pro2.Match_Maker__Working_with__c='Private Company';
        pro2.Match_Maker__Religion__c='Hindu';
        pro2.Match_Maker__Height__c='170 cm';
        pro2.Match_Maker__Smoke__c='No';
        pro2.Match_Maker__Drinks__c='No';
        pro2.Match_Maker__Contact__c = con2.id;
        pro2.Match_Maker__Active__c=True;
        pro2.Match_Maker__Professional_Area__c='Software Developer';
        pro2.Match_Maker__Income_yearly__c=1000000;
        pro2.Match_Maker__Your_Diet__c='Non-Veg';
        pro2.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro2;  
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        system.debug('ContentVersionID : ' + cvList[0].Id);
        Map<Id,String> contentDocMap=new Map<Id,String>();

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pro.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        System.assertEquals(cdl.ContentDocumentId,cvList[0].ContentDocumentId);
        contentDocMap.put(cdl.ContentDocumentId,cdl.id);
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=pro.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='130 cm';
        m.Match_Maker__Max_Height__c='220 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Hindu';
        m.Match_Maker__Material_Status__c='Unmarried';
        m.Match_Maker__Annual_Income__c=1000000;
        m.Match_Maker__Diet__c='Non-Veg';
        m.Match_Maker__Skin_Tone_Complexion__c='Normal';
        m.Match_Maker__Alcohol__c = 'No';
        m.Match_Maker__Does_Smoke__c = 'No';
        insert m;
        Match_Maker__Match_Preference__c m1=new Match_Maker__Match_Preference__c();
        m1.Match_Maker__Profile__c=pro.id;
        m1.Match_Maker__Min_Age__c='18';
        m1.Match_Maker__Max_Age__c='40';
        m1.Match_Maker__Min_Height__c='130 cm';
        m1.Match_Maker__Max_Height__c='220 cm';
        m1.Match_Maker__Highest_Qualification__c='Bachelors';
        m1.Match_Maker__Working_with__c='Private Company';
        m1.Match_Maker__Religion__c='Hindu';
        m1.Match_Maker__Material_Status__c='Unmarried';
        m1.Match_Maker__Annual_Income__c=1000000;
        m1.Match_Maker__Diet__c='Non-Veg';
        m1.Match_Maker__Skin_Tone_Complexion__c='Open to All';
        m1.Match_Maker__Alcohol__c = 'No';
        m1.Match_Maker__Does_Smoke__c = 'Does not matter';
        insert m1;
        
        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=pro.id;
        s.Match_Maker__Match_Preference__c=m.Id;
        s.Match_Maker__Match_Preference__c=m1.Id;
        s.Match_Maker__Status__c='Shortlisted';
        shpf.add(s);
        //string str='new';
        List<string> lststr= new List<String>();
        lststr.add(pro.id);
        test.startTest();
        // List<Search_MM.ProfileMatchWrapper> wrapper= Search_MM.getMatchedProfiles();
       Search_MM.getMatchedProfiles(m1.id);
        Search_MM.shortListedProfiles(lststr,m1.id);
        test.stopTest();
    }
  @isTest
    public static void getMatchedProfilesTestMethod4(){
        List<Match_Maker__Shortlisted_Contact__c> shpf=new List<Match_Maker__Shortlisted_Contact__c>();
            Account acc=new Account();
        acc.Name ='Test1';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Test1';
        con.Email='test@test.com';
        insert con;
        
        Match_Maker__Profile__c pro=new Match_Maker__Profile__c();
        pro.Name='NK';
        pro.Match_Maker__Email__c='Nk@gmail.com';
        pro.Match_Maker__Mobile__c='1234567890';
        pro.Match_Maker__Gender__c='Male';
        pro.Match_Maker__Opposite_Gender__c='Female';
        pro.Match_Maker__DOB__c=Date.newInstance(1998, 2, 8);
        pro.Match_Maker__Marital_Status__c='Unmarried';
        pro.Match_Maker__Does_He_She_They_have_children__c='No';
        pro.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro.Match_Maker__Lives_In__StateCode__s='TG';
        pro.Match_Maker__Lives_In__City__s='hyderabad';
        pro.Match_Maker__Lives_In__CountryCode__s='IN';
        pro.Match_Maker__Lives_In__PostalCode__s='500081';
        pro.Match_Maker__Highest_Qualification__c='Bachelors';
        pro.Match_Maker__Working_with__c='Private Company';
        pro.Match_Maker__Religion__c='Jain';
        pro.Match_Maker__Height__c='170 cm';
        pro.Match_Maker__Smoke__c='No';
        pro.Match_Maker__Drinks__c='Yes';
        pro.Match_Maker__Contact__c = con.id;
        pro.Match_Maker__Active__c=True;
        pro.Match_Maker__Professional_Area__c='Jr.Developer';
        pro.Match_Maker__Income_yearly__c=500000;
        pro.Match_Maker__Your_Diet__c='Vegetarian';
        pro.Match_Maker__Skin_Tone_C__c='Fair';
        insert pro;
        
        Account acc2=new Account();
        acc2.Name ='Test2';
        insert acc2;
        
        Contact con2=new Contact();
        con2.AccountId=acc2.id;
        con2.LastName='Test2';
        con2.Email='test2@test.com';
        insert con2;
        
        Match_Maker__Profile__c pro2=new Match_Maker__Profile__c();
        pro2.Name='NKR';
        pro2.Match_Maker__Email__c='Nk2@gmail.com';
        pro2.Match_Maker__Mobile__c='1234567800';
        pro2.Match_Maker__Gender__c='Female';
        pro2.Match_Maker__Opposite_Gender__c='Male';
        pro2.Match_Maker__DOB__c=Date.newInstance(2001, 2, 8);
        pro2.Match_Maker__Marital_Status__c='Unmarried';
        pro2.Match_Maker__Does_He_She_They_have_children__c='No';
        pro2.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro2.Match_Maker__Lives_In__StateCode__s='TG';
        pro2.Match_Maker__Lives_In__City__s='hyderabad';
        pro2.Match_Maker__Lives_In__CountryCode__s='IN';
        pro2.Match_Maker__Lives_In__PostalCode__s='500081';
        pro2.Match_Maker__Highest_Qualification__c='Associates Degree';
        pro2.Match_Maker__Working_with__c='Private Company';
        pro2.Match_Maker__Religion__c='Hindu';
        pro2.Match_Maker__Height__c='170 cm';
        pro2.Match_Maker__Smoke__c='No';
        pro2.Match_Maker__Drinks__c='No';
        pro2.Match_Maker__Contact__c = con2.id;
        pro2.Match_Maker__Active__c=True;
        pro2.Match_Maker__Professional_Area__c='Software Developer';
        pro2.Match_Maker__Income_yearly__c=1000000;
        pro2.Match_Maker__Your_Diet__c='Non-Veg';
        pro2.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro2;  
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        system.debug('ContentVersionID : ' + cvList[0].Id);
        Map<Id,String> contentDocMap=new Map<Id,String>();

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pro.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        System.assertEquals(cdl.ContentDocumentId,cvList[0].ContentDocumentId);
        contentDocMap.put(cdl.ContentDocumentId,cdl.id);
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=pro.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='130 cm';
        m.Match_Maker__Max_Height__c='220 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Hindu';
        m.Match_Maker__Material_Status__c='Open to All';
        m.Match_Maker__Annual_Income__c=1000000;
        m.Match_Maker__Diet__c='Non-Veg';
        m.Match_Maker__Skin_Tone_Complexion__c='Normal';
        m.Match_Maker__Alcohol__c = 'No';
        m.Match_Maker__Does_Smoke__c = 'No';
        insert m;
        Match_Maker__Match_Preference__c m1=new Match_Maker__Match_Preference__c();
        m1.Match_Maker__Profile__c=pro.id;
        m1.Match_Maker__Min_Age__c='18';
        m1.Match_Maker__Max_Age__c='40';
        m1.Match_Maker__Min_Height__c='130 cm';
        m1.Match_Maker__Max_Height__c='220 cm';
        m1.Match_Maker__Highest_Qualification__c='Bachelors';
        m1.Match_Maker__Working_with__c='Private Company';
        m1.Match_Maker__Material_Status__c='Unmarried';
        m1.Match_Maker__Religion__c='Open to All';
        m1.Match_Maker__Annual_Income__c=1000000;
        m1.Match_Maker__Diet__c='Non-Veg';
        m1.Match_Maker__Skin_Tone_Complexion__c='Normal';
        m1.Match_Maker__Alcohol__c = 'No';
        m1.Match_Maker__Does_Smoke__c = 'No';
        m1.Match_Maker__Professional_Area__c='Software Developer';
        m1.Match_Maker__Having_Children__c='No';
        insert m1;
        
        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=pro.id;
        s.Match_Maker__Match_Preference__c=m.Id;
        s.Match_Maker__Match_Preference__c=m1.Id;
        s.Match_Maker__Status__c='Shortlisted';
        shpf.add(s);
        //string str='new';
        List<string> lststr= new List<String>();
        lststr.add(pro.id);
        test.startTest();
        // List<Search_MM.ProfileMatchWrapper> wrapper= Search_MM.getMatchedProfiles();
       Search_MM.getMatchedProfiles(m1.id);
        Search_MM.shortListedProfiles(lststr,m1.id);
        test.stopTest();
    }
  @isTest  
    public static void getMatchedprofilesTestMethod5(){
        List<Match_Maker__Shortlisted_Contact__c> shpf=new List<Match_Maker__Shortlisted_Contact__c>();
            Account acc=new Account();
        acc.Name ='Test1';
        insert acc;
        
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.LastName='Test1';
        con.Email='test@test.com';
        insert con;
        
        Match_Maker__Profile__c pro=new Match_Maker__Profile__c();
        pro.Name='NK';
        pro.Match_Maker__Email__c='Nk@gmail.com';
        pro.Match_Maker__Mobile__c='1234567890';
        pro.Match_Maker__Gender__c='Male';
        pro.Match_Maker__Opposite_Gender__c='Female';
        pro.Match_Maker__DOB__c=Date.newInstance(1998, 2, 8);
        pro.Match_Maker__Marital_Status__c='Unmarried';
        pro.Match_Maker__Does_He_She_They_have_children__c='No';
        pro.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro.Match_Maker__Lives_In__StateCode__s='TG';
        pro.Match_Maker__Lives_In__City__s='hyderabad';
        pro.Match_Maker__Lives_In__CountryCode__s='IN';
        pro.Match_Maker__Lives_In__PostalCode__s='500081';
        pro.Match_Maker__Highest_Qualification__c='Bachelors';
        pro.Match_Maker__Working_with__c='Private Company';
        pro.Match_Maker__Religion__c='Hindu';
        pro.Match_Maker__Height__c='170 cm';
        pro.Match_Maker__Smoke__c='No';
        pro.Match_Maker__Drinks__c='No';
        pro.Match_Maker__Contact__c = con.id;
        pro.Match_Maker__Active__c=True;
        pro.Match_Maker__Professional_Area__c='Business';
        pro.Match_Maker__Income_yearly__c=500000;
        pro.Match_Maker__Your_Diet__c='Non-Veg';
        pro.Match_Maker__Skin_Tone_C__c='Normal';
        insert pro;
        
        Account acc2=new Account();
        acc2.Name ='Test2';
        insert acc2;
        
        Contact con2=new Contact();
        con2.AccountId=acc2.id;
        con2.LastName='Test2';
        con2.Email='test2@test.com';
        insert con2;
        
        Match_Maker__Profile__c pro2=new Match_Maker__Profile__c();
        pro2.Name='NKR';
        pro2.Match_Maker__Email__c='Nk2@gmail.com';
        pro2.Match_Maker__Mobile__c='1234567800';
        pro2.Match_Maker__Gender__c='Female';
        pro2.Match_Maker__Opposite_Gender__c='Male';
        pro2.Match_Maker__DOB__c=Date.newInstance(2001, 2, 8);
        pro2.Match_Maker__Marital_Status__c='Awaiting Divorce';
        pro2.Match_Maker__Does_He_She_They_have_children__c='Yes - Living Together';
        pro2.Match_Maker__No_of_Children__c='more than 5';
        pro2.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro2.Match_Maker__Lives_In__StateCode__s='TG';
        pro2.Match_Maker__Lives_In__City__s='hyderabad';
        pro2.Match_Maker__Lives_In__CountryCode__s='IN';
        pro2.Match_Maker__Lives_In__PostalCode__s='500081';
        pro2.Match_Maker__Highest_Qualification__c='High School';
        pro2.Match_Maker__Working_with__c='Not Working';
        pro2.Match_Maker__Religion__c='Jain';
        pro2.Match_Maker__Height__c='180 cm';
        pro2.Match_Maker__Smoke__c='Yes';
        pro2.Match_Maker__Drinks__c='Yes';
        pro2.Match_Maker__Contact__c = con2.id;
        pro2.Match_Maker__Active__c=True;
        pro2.Match_Maker__Professional_Area__c='Software Developer';
        pro2.Match_Maker__Income_yearly__c=1000000;
        pro2.Match_Maker__Your_Diet__c='Eggetarian';
        pro2.Match_Maker__Skin_Tone_C__c='Fair';
        insert pro2;  
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        system.debug('ContentVersionID : ' + cvList[0].Id);
        Map<Id,String> contentDocMap=new Map<Id,String>();

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pro.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        System.assertEquals(cdl.ContentDocumentId,cvList[0].ContentDocumentId);
        contentDocMap.put(cdl.ContentDocumentId,cdl.id);
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=pro.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='130 cm';
        m.Match_Maker__Max_Height__c='220 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Open to All';
        m.Match_Maker__Material_Status__c='Widowed';
        m.Match_Maker__Annual_Income__c=1000000;
        m.Match_Maker__Diet__c='Vegetarian';
        m.Match_Maker__Skin_Tone_Complexion__c='Medium';
        m.Match_Maker__Alcohol__c = 'No';
        m.Match_Maker__Does_Smoke__c = 'Yes';
        m.Match_Maker__Having_Children__c='Does not matter';
        insert m;

        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=pro.id;
        s.Match_Maker__Match_Preference__c=m.Id;
        s.Match_Maker__Match_Preference__c=m.Id;
        s.Match_Maker__Status__c='Selected';
        shpf.add(s);
        //string str='new';
        List<string> lststr= new List<String>();
        lststr.add(pro.id);
        test.startTest();
        // List<Search_MM.ProfileMatchWrapper> wrapper= Search_MM.getMatchedProfiles();
       Search_MM.getMatchedProfiles(m.id);
        Search_MM.shortListedProfiles(lststr,m.id);
        test.stopTest();
    }  
}