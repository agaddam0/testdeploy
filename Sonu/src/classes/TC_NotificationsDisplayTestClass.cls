@isTest
public class TC_NotificationsDisplayTestClass {
    @isTest
    static void testDisplayNotifications(){
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sys123', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1234', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='sys123@testorg.com');
        
        insert u;

        
       List<TC_Notifications__C> notifications=new List<TC_Notifications__C>();
        
        TC_Notifications__C notification=new TC_Notifications__C();
        notification.Content__c='Collect ATM Card';
        notification.Publish_Date__c=System.today()-10;
        notification.Header_Description__c='Regarding ATM Card';
        notification.Read__c=false;
        notification.Dedicated_To__c=u.id;
        insert notification;
        
        TC_Notifications__C notification1=new TC_Notifications__C();
        notification1.Content__c='Collect Credit Card';
        notification1.Publish_Date__c=System.today()-5;
        notification1.Header_Description__c='Regarding Credit Card';
        notification1.Read__c=true;
        notification1.Dedicated_To__c=u.id;
        insert notification1;
        
        Test.StartTest();
        TC_notificationsDisplay.displayNotifications(u.id);
        TC_notificationsDisplay.change(u.id,notification.id);
        TC_notificationsDisplay.change(u.id,notification1.id);
        
        Test.StopTest();
        	
        
        
    }
        

}