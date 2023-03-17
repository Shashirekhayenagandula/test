@isTest
public class Test_EmailClass {
   @isTest
    public static void searchTestMethod1(){
        test.startTest();
        List<Match_Maker__Profile__c> pfs=new List<Match_Maker__Profile__c>();
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
        p.Match_Maker__Professional_Area__c='Software Engineer';
        p.Match_Maker__Income_yearly__c=1000000;
        insert p;
        list<String> lstStrings=new List<String>();
        lstStrings.add('abc@gmail.com');
        //string jsonString ='{"toAddress":"abc@gmail.com","subject":"test subject","profileid":'+' "' + p.Id +'"}';
        JSONclass j =new JSONclass();
        j.toAddress = lstStrings;
        j.subject='test subject';
        j.profileid=p.id;
        string jsonInput = JSON.serialize(j);
        string searchkey='test';
        EmailClass.search(searchkey, lstStrings);
        EmailClass.sendEmailController(jsonInput);
        EmailClass.profileDetails(p.id);
        
       	EmailClass em = new EmailClass();
        PageReference pageRef = page.New_Send_Profile;
    	test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id',p.id);
        em.getProfileInformation();
        System.assert(true);
        test.stopTest();
    }
    public class JSONclass{
        public List<string> toAddress{get;set;}
         public string subject{get;set;}
         public string profileid{get;set;}
    }   
}