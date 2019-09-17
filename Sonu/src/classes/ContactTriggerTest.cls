@istest
public class ContactTriggerTest {
    public static testmethod void TestContact ( )   {
        User u = [SELECT id,FirstName,LastName from user where profile.name like '%System%' limit 1];
        Contact conObj = new Contact();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        conObj.RecordTypeId = conRecordTypeId;
        conObj.FirstName = 'test';
        conObj.LastName = 'test123';
        conObj.User__c = u.id;
        conObj.MailingPostalCode = '85001';
        conObj.MailingCity = 'Pheonix';
        conObj.MailingCountry = 'United States';
        insert conObj;
        
        conObj.FirstName = 'newName';
        update conObj;
        
        
    } 

}