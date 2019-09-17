/*
*@Description: Contact Trigger to check for any changes on the contact record
*@References: W-000056 - Sync Contact Record with associated User Record
*@Author: Akhil Prabhakaran 
*@Date: 12/06/2018 
*/

trigger conTrigger on Contact (before insert, before update) {
	// Checking for the update operation 	
    if(Trigger.isUpdate){
        contactTriggerHelper.updateUser(Trigger.new,Trigger.oldMap);
    }
    
    // checking for the insert operation
     if(Trigger.isInsert){
        contactTriggerHelper.updateUser(Trigger.new,null);
    }
}