@isTest
public class Test_UploadPhotoWithGallary {
   @isTest
    
    public static void getVersionFilesTestMethod(){
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
        p.Match_Maker__Active__c=True;
        // p.Match_Maker__No_of_Children__c='None';
        //p.Match_Maker__Contact__r.AccountId=a.Id;
        p.Match_Maker__Professional_Area__c='Software Engineer';
        p.Match_Maker__Income_yearly__c=1000000;
        insert p;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.xml';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        system.debug('ContentVersionID : ' + cvList[0].Id);
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = p.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl; 
        
        
        System.debug('Content DocumentID=='+cdl.ContentDocumentId);
        System.assertEquals(cdl.ContentDocumentId,cvList[0].ContentDocumentId);
        
        
        test.startTest();
        UploadPhotoWithGallary.getVersionFiles(p.id);

        System.assertNotEquals(null, cdl, 'The "cdl" variable should not be null');
        UploadPhotoWithGallary.delFiles(p.id,cdl.ContentDocumentId);
        test.stopTest();
        
    } 
 
}