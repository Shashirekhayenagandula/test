@isTest
public class Test_invoiceProfileLookup {
    @isTest
    static void fetchLookupDataTest1(){
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
        p.Match_Maker__Status__c='	New Profile';
        p.Match_Maker__Religion__c='Hindu';
        p.Match_Maker__Height__c='183 cm';
        p.Match_Maker__Smoke__c='No';
        p.Match_Maker__Drinks__c='No';
        p.Match_Maker__Contact__c = con.id;
        p.Match_Maker__Active__c=True;
        p.Match_Maker__Professional_Area__c='Software Engineer';
        p.Match_Maker__Income_yearly__c=1000000;
        insert p;
        
        List<sObject> result = invoiceProfileLookup.fetchLookupData('Match_Maker__Profile__c', 'p.Name', '');
        System.assertEquals(result != null, true);
    }
     @isTest
    static void fetchLookupDataTest2(){
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
        p.Match_Maker__Status__c='	New Profile';
        p.Match_Maker__Religion__c='Hindu';
        p.Match_Maker__Height__c='183 cm';
        p.Match_Maker__Smoke__c='No';
        p.Match_Maker__Drinks__c='No';
        p.Match_Maker__Contact__c = con.id;
        p.Match_Maker__Active__c=True;
        p.Match_Maker__Professional_Area__c='Software Engineer';
        p.Match_Maker__Income_yearly__c=1000000;
        insert p;
        
        List<sObject> result = invoiceProfileLookup.fetchLookupData('Match_Maker__Profile__c', 'p.Name', 'con.Id');
        System.assertEquals(result.size(), 1);
    }
    
  @isTest
    public static void getItemMasterItem(){
        
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
        p.Match_Maker__Status__c='	New Profile';
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
        
        Match_Maker__Invoice__c vc=New Match_Maker__Invoice__c();
        vc.Match_Maker__Full_Name__c='shashi';
        vc.Match_Maker__Contact__c=con.id;
        vc.Match_Maker__Profile__c=p.id;  
        vc.Match_Maker__Payment_Method__c='	Cash';
        vc.Match_Maker__Payment_Status__c='Unpaid';
        vc.Match_Maker__Phone__c='1234567890';
        vc.Match_Maker__Address__StateCode__s='TG';
        vc.Match_Maker__Address__City__s='hyderabad';
        vc.Match_Maker__Address__CountryCode__s='IN';
        vc.Match_Maker__Address__PostalCode__s= '500072';   
        vc.Match_Maker__Date__c=Date.newInstance(2023, 2, 2);
        vc.Match_Maker__Email__c='shashirekhay.540@gmail.com';
        insert vc;
        
        Match_Maker__Item_Master__c im=new Match_Maker__Item_Master__c();
        im.Name='Gold';
        im.Match_Maker__Rate__c=5000;
        im.Match_Maker__Tax__c= 5;
        insert im;
        
        Match_Maker__Invoice_Line_Item__c il=new Match_Maker__Invoice_Line_Item__c();
        il.Match_Maker__Invoice__c=vc.id;
        il.Match_Maker__Items__c=im.id;
        il.Match_Maker__Amount__c=5000;
        il.Match_Maker__Discount__c=1;
        il.Match_Maker__Taxs__c=5;
        insert il;
         List<Match_Maker__Invoice_Line_Item__c> lstiv = new list<Match_Maker__Invoice_Line_Item__c>();
        lstiv.add(il);
          System.assert(true);
         test.startTest();
         invoiceProfileLookup.getItemMasterItem(im.id);
        invoiceProfileLookup.insertInvoice(lstiv,vc,p.id);
        invoiceProfileLookup.fetchLineItem(il.id);
             invoiceProfileLookup.upsertInvoice(lstiv,vc,vc.id);
         test.stopTest();
            }
}