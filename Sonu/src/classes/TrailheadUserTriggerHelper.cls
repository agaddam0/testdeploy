public class TrailheadUserTriggerHelper {
    
    public static void triggerHelper()
    {
        if(trigger.isAfter)
        {
            if(trigger.isInsert)
            {
                TrailheadUserTriggerHelper.afterInsert(trigger.new);
            }
        }
    }
    
    public static void afterInsert(List<Trailhead_User__c> triggerNew)
    {
        //save trailhead stats for today
        TrailheadUserTriggerHelper.initSaveDailyStats(trigger.new);
    }
    public static void initSaveDailyStats(List<Trailhead_User__c> triggerNew)
    {
        List<String> trailheadUserIds = new  List<String>();
        List<String> trailheadUserTrailheadIds = new  List<String>();
        for(Trailhead_User__c trailheadUser : triggerNew) 
        {
            trailheadUserIds.add(trailheadUser.Id);
            trailheadUserTrailheadIds.add(trailheadUser.Trailhead_Id__c);
        }
        saveDailyStats(trailheadUserIds, trailheadUserTrailheadIds);
    }
    
    @Future(callout=true)	
    public static void saveDailyStats(List<String> trailheadUserIds, List<String> trailheadUserTrailheadIds)
    {
        TrailheadTrackerHelper.saveTrailheadStats(trailheadUserIds, trailheadUserTrailheadIds);
    }
}