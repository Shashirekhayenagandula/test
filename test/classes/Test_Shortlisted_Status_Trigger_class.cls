@isTest
public class Test_Shortlisted_Status_Trigger_class {
    @isTest
    public static void updateStatusTestMethod1(){
        List<Match_Maker__Shortlisted_Contact__c> src =New List<Match_Maker__Shortlisted_Contact__c>();
        Account a= new Account ();
        a.name='Test Account';
        insert a;
        
        Contact con = new Contact();
        con.AccountId=a.id;
        con.LastName='test';
        con.Email='abc@test.com';
        insert con;
        
        Match_Maker__Profile__c p=New Match_Maker__Profile__c();
        p.Name='Shashi';
        p.Match_Maker__Email__c='shashirekhay.540@gmail.com';
        p.Match_Maker__Mobile__c='1234567890';
        p.Match_Maker__Gender__c='Female';
        p.Match_Maker__Opposite_Gender__c='Male';
        p.Match_Maker__DOB__c=Date.newInstance(1995, 12, 9);
        p.Match_Maker__Marital_Status__c='Unmarried';
        p.Match_Maker__Does_He_She_They_have_children__c='No';
        p.Match_Maker__Lives_In__Street__s='Bagh Ameeri';
        p.Match_Maker__Lives_In__StateCode__s='TG';
        p.Match_Maker__Lives_In__City__s='hyderabad';
        p.Match_Maker__Lives_In__CountryCode__s='IN';
        p.Match_Maker__Lives_In__PostalCode__s='500072';
        p.Match_Maker__Highest_Qualification__c='Bachelors';
        p.Match_Maker__Working_with__c='Private Company';
        p.Match_Maker__Religion__c='Hindu';
        p.Match_Maker__Height__c='183 cm';
        p.Match_Maker__Smoke__c='No';
        p.Match_Maker__Drinks__c='No';
        p.Match_Maker__Contact__c = con.id;
        p.Match_Maker__Active__c=True;
        // p.Match_Maker__No_of_Children__c='None';
        //p.Match_Maker__Contact__r.AccountId=a.Id;
        p.Match_Maker__Professional_Area__c='Software Engineer';
        p.Match_Maker__Income_yearly__c=1000000;
        insert p;
        
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=p.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='122 cm';
        m.Match_Maker__Max_Height__c='213 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Hindu';
        m.Match_Maker__Annual_Income__c=1000000;
        insert m;
        
        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=p.id;
        s.Match_Maker__Match_Preference__c=m.Id;
        s.Match_Maker__Status__c='Selected';
        //insert s;
        src.add(s);
        test.startTest();
        System.assert(true);
        Shortlisted_Status_Trigger_class obj = new Shortlisted_Status_Trigger_class(src);
        obj.updateStatus();
        test.stopTest();        
        
    }
    @isTest
    public static void updateStatusTestMethod2(){
        List<Match_Maker__Shortlisted_Contact__c> src =New List<Match_Maker__Shortlisted_Contact__c>();
        Account a= new Account ();
        a.name='Test Account';
        insert a;
        
        Contact con = new Contact();
        con.AccountId=a.id;
        con.LastName='test';
        con.Email='abc@test.com';
        insert con;
        
        Match_Maker__Profile__c p=New Match_Maker__Profile__c();
        p.Name='Shashi';
        p.Match_Maker__Email__c='shashirekhay.540@gmail.com';
        p.Match_Maker__Mobile__c='1234567890';
        p.Match_Maker__Gender__c='Female';
        p.Match_Maker__Opposite_Gender__c='Male';
        p.Match_Maker__DOB__c=Date.newInstance(1995, 12, 9);
        p.Match_Maker__Marital_Status__c='Unmarried';
        p.Match_Maker__Does_He_She_They_have_children__c='No';
        p.Match_Maker__Lives_In__Street__s='Bagh Ameeri';
        p.Match_Maker__Lives_In__StateCode__s='TG';
        p.Match_Maker__Lives_In__City__s='hyderabad';
        p.Match_Maker__Lives_In__CountryCode__s='IN';
        p.Match_Maker__Lives_In__PostalCode__s='500072';
        p.Match_Maker__Highest_Qualification__c='Bachelors';
        p.Match_Maker__Working_with__c='Private Company';
        p.Match_Maker__Religion__c='Hindu';
        p.Match_Maker__Height__c='134 cm';
        p.Match_Maker__Smoke__c='No';
        p.Match_Maker__Drinks__c='No';
        p.Match_Maker__Contact__c = con.id;
        p.Match_Maker__Active__c=false;
        // p.Match_Maker__No_of_Children__c='None';
        //p.Match_Maker__Contact__r.AccountId=a.Id;
        p.Match_Maker__Professional_Area__c='Software Engineer';
        p.Match_Maker__Income_yearly__c=1000000;
        insert p;
        
        Match_Maker__Match_Preference__c m=new Match_Maker__Match_Preference__c();
        m.Match_Maker__Profile__c=p.id;
        m.Match_Maker__Min_Age__c='18';
        m.Match_Maker__Max_Age__c='40';
        m.Match_Maker__Min_Height__c='122 cm';
        m.Match_Maker__Max_Height__c='213 cm';
        m.Match_Maker__Highest_Qualification__c='Bachelors';
        m.Match_Maker__Working_with__c='Private Company';
        m.Match_Maker__Religion__c='Hindu';
        m.Match_Maker__Annual_Income__c=1000000;
        insert m;
        
        Match_Maker__Shortlisted_Contact__c s=New Match_Maker__Shortlisted_Contact__c();
        s.Match_Maker__Profile__c=p.id;
        s.Match_Preference__c=m.Id;
        s.Status__c='Contacted';
        //insert s;
        src.add(s);
        test.startTest(); 
        System.assert(true);
        Shortlisted_Status_Trigger_class obj = new Shortlisted_Status_Trigger_class(src);
        obj.updateStatus();
        test.stopTest();        
        
    }
    
}