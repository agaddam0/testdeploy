/*
*@Description:LifeMomentsNotificationBatchTest testclass (W-000091: Capture important life moments)
*@Referrence: LifeMomentsNotificationBatch
*@Author: Nithi Natarajan
*@Date: 08/17/2018
*/
@isTest
public class LifeMomentsNotificationBatchTest {
    static testmethod void LifeMomentsNotificationBatchTestMethod(){
        
        list<Contact> ContactList = new list<contact>();
        contact conrec= new contact();
        conrec.FirstName = 'Amrita';
        conrec.LastName = 'Hegde';
        conrec.Email = 'amhegde@teksystems.com';
        conrec.Birthdate = system.today();
        conrec.Joining_date__c = system.today();
        ContactList.add(conrec);
        Test.startTest();        
        insert ContactList;
		LifeMomentsNotificationBatch objclass = new LifeMomentsNotificationBatch();
		Database.executeBatch(objclass);   
		Test.stopTest();
    }
}