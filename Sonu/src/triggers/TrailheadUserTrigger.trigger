trigger TrailheadUserTrigger on Trailhead_User__c (after insert) 
{
    TrailheadUserTriggerHelper.triggerHelper();
}