@isTest(SeeAllData=true)
public class Test_EditProfileWithWrapper {
     @isTest
    public static void geteditProfileWithWrapperTestMethod1(){
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
        pro.Match_Maker__Status__c='Request for Completion';
        pro.Match_Maker__Email__c='Nk@gmail.com';
        pro.Match_Maker__Mobile__c='1234567890';
        pro.Match_Maker__Gender__c='Male';
        pro.Match_Maker__Opposite_Gender__c='Female';
        pro.Match_Maker__DOB__c=Date.newInstance(1998, 2, 8);
        pro.Match_Maker__Marital_Status__c='Unmarried';
        pro.Match_Maker__Sexuality__c='Homosexual';
        pro.Match_Maker__Zodiac__c='Aries/Mesh';
        pro.Match_Maker__Does_He_She_They_have_children__c='Yes - Living Together';
        pro.Match_Maker__No_of_Children__c='2';
        pro.Match_Maker__Challenges__c='Physically from Birth';
        pro.Match_Maker__Lives_In__Street__s='Arunodhaya Colony';
        pro.Match_Maker__Lives_In__StateCode__s='TG';
        pro.Match_Maker__Lives_In__City__s='hyderabad';
        pro.Match_Maker__Lives_In__CountryCode__s='IN';
        pro.Match_Maker__Lives_In__PostalCode__s='500081';
        pro.Match_Maker__Highest_Qualification__c='Bachelors';
        pro.Match_Maker__Working_with__c='Private Company';
        pro.Match_Maker__Religion__c='Hindu';
        pro.Match_Maker__Other_Religion__c='BC';
        pro.Match_Maker__Height__c='170 cm';
        pro.Match_Maker__Smoke__c='No';
        pro.Match_Maker__Drinks__c='No';
        pro.Match_Maker__Contact__c = con.id;
        pro.Match_Maker__Active__c=True;
        pro.Match_Maker__Professional_Area__c='Software Developer';
        pro.Match_Maker__Company_Name_current__c='Druvsoft';
        pro.Match_Maker__Community_Mother_Tounge__c='Telugu';
        pro.Match_Maker__Body_Type__c='Athletic';
        pro.Match_Maker__Blood_Group__c='A+';
        pro.Match_Maker__Weight__c='86kg to 90kg';
        pro.Match_Maker__Drinks__c='No';
        pro.Match_Maker__Hobbies__c='Cricket';
        pro.Match_Maker__Interest__c='Cricket';
        pro.Match_Maker__Favourite_Music__c='Classical';
        pro.Match_Maker__Preferred_Movies__c='Classical';
        pro.Match_Maker__Favourite_Read__c='Classical';
        pro.Match_Maker__Favourite_Criuisne__c='Classical';
        pro.Match_Maker__Sport_Fitness_Activities__c='Cricket';
        pro.Match_Maker__Preferred_Dress_Style__c='Classical';
        pro.Match_Maker__Father_Status__c='Employed';
        pro.Match_Maker__Mother_Status__c='Homemaker';
        pro.Match_Maker__No_of_Brothers__c=2;
        pro.Match_Maker__Number_of_Married_Brother__c=1;
        pro.Match_Maker__No_of_Sisters__c=2;
        pro.Match_Maker__No_of_Married_Sisters__c=1;
        pro.Match_Maker__Family_Status__c='Middle Class';
        pro.Match_Maker__Family_Type__c='Nuclear Family';
        pro.Match_Maker__Income_yearly__c=500000;
        pro.Match_Maker__Your_Diet__c='Non-Veg';
        pro.Match_Maker__Skin_Tone_C__c='Normal';
        
        insert pro;
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
        
      
        test.startTest();
      ApexPages.currentPage().getParameters().put('id', String.valueOf(pro.Id));
			EditProfileWithWrapper  testAccPlan = new EditProfileWithWrapper();
			testAccPlan.doSave();
			testAccPlan.doSubmit();
			testAccPlan.getcountryCode();
        	testAccPlan.getgenderValues();
        	testAccPlan.getlookingGenderValues();
			testAccPlan.getmaritalStatusValues();
			testAccPlan.getsexualityValues();
        	testAccPlan.getchallengesValues();
			testAccPlan.getlivesincountryValues();
			//testAccPlan.getstateCodeValues();
        	testAccPlan.getfamilyCountryValues();
			//testAccPlan.getfamilystateValues();
			testAccPlan.getlivingwithfamilyValues();
        	testAccPlan.gethighestqualificationValues();
        	testAccPlan.getworkingwithValues();
			testAccPlan.getreligionValues();
			testAccPlan.getbodyTypeValues();
        	testAccPlan.getbloodGroupValues();
			testAccPlan.getheightValues();
			testAccPlan.getweightValues();
        
            testAccPlan.getsmokeValues();
        	testAccPlan.getdrinkValues();
			testAccPlan.getdietValues();
			testAccPlan.getskintoneValues();
        	testAccPlan.getfatherstatusValues();
        	testAccPlan.getmotherstatusValues();
			testAccPlan.getfamilyeconomicalstatusValues();
			testAccPlan.getfamilytypeValues();
        	testAccPlan.createDependPick();
			testAccPlan.controllingToDependentValues();
			testAccPlan.familyControllingToDependentValues();
			
			testAccPlan.addTextBox();
			
        	//testAccPlan.Del();
			//editProfileWithWrapper.getDependentPicklist();
		Test.stopTest();
    }

}