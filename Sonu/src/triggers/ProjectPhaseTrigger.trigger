/*
 * Trigger Written By: Saira
 * Date: 02/25/2019
 * Description: Trigger to update the Project Start Date based on the Project Phase
 * Revision Date: 
 * Revised By: 
*/ 
 
trigger ProjectPhaseTrigger on Project_Phase__c (after insert,after update) {
   if(Trigger.isUpdate)
    ProjectPhaseTriggerHelper.updateStartDate(trigger.new,trigger.oldMap);
    if(Trigger.isInsert)
    ProjectPhaseTriggerHelper.updateStartDateAfterInsert(trigger.new);

}