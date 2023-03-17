@isTest
public class Test_Email_Event_Helper {
    @isTest
    public static void beforeInsertTestMethod(){
        
        List<Event> lstEvents = new List<Event>();
        Account a= new Account ();
        a.name='Test Account';
        insert a;
        
        Contact con = new Contact();
        con.LastName='test';
        con.Email='abc@test.com';
        insert con;
        
        Event e = new Event();
        e.WhatId=a.id;
        e.WhoId=con.id;
        e.OwnerId=UserInfo.getUserId();
        e.StartDateTime=system.today();
        e.EndDateTime=system.today()+5;
        lstEvents.add(e);
        insert lstEvents;
        System.assert(true);
        Email_Event_Helper 	evtObj = new Email_Event_Helper(lstEvents);
        evtObj.beforeInsert();
    } 
    
}