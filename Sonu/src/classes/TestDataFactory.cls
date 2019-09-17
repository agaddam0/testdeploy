@isTest
public class TestDataFactory {
    
    public static void createMetadataTrailheadTracker()
    {
        Trailhead_Tracker__c tt = new Trailhead_Tracker__c();
        tt.Admin_Email__c = 'test@test.com';
        tt.Http_Request_Timeout__c = 25000;
        tt.Trailhead_Badges_Begin__c = 'data-test-badges-count>';
        tt.Trailhead_Badges_End__c = '<';
        tt.Trailhead_Display_Picture_End__c = '/>';
        tt.Trailhead_Display_Picture_Start__c = '<img class="user-information__avatar-img"';
        tt.Trailhead_Points_Begin__c = 'data-test-points-count>';
        tt.Trailhead_Points_End__c = '<';
        tt.Trailhead_Trails_Begin__c = 'data-test-trails-count>';
        tt.Trailhead_Trails_End__c = '<';
        tt.Trailhead_URL__c = 'https://trailhead.salesforce.com/en/me/';
        tt.Trailhead_User_Name_Begin__c = 'data-react-props="{&quot;full_name&quot;:&quot;';
        tt.Trailhead_User_Name_End__c = '&quot;';        
        insert tt;
    }
    
    public static List<Trailhead_User__c> createTrailheadUsers(Integer size)
    {
        List<Trailhead_User__c> listTrailheaUsers = new List<Trailhead_User__c>();
        for(Integer i=0; i<size; i++) {
            Trailhead_User__c varTrailheadUser = new Trailhead_User__c();
            varTrailheadUser.Name = 'Test Name '+i;
            varTrailheadUser.Trailhead_Id__c = 'Test Id ' + i;
            varTrailheadUser.Profile_Picture_URL__c = 'Test Profile Picture ' + i;            
            listTrailheaUsers.add(varTrailheadUser);
        }
        insert listTrailheaUsers;
        return listTrailheaUsers;
    }
    
    public static List<Daily_Stats__c> createDailyStats(List<Trailhead_User__c> listTrailheadUsers, Integer size)
    {
        List<Daily_Stats__c> listDailyStats = new List<Daily_Stats__c>();
        
        for(Trailhead_User__c varTrailheadUser : listTrailheadUsers)
        {
            for(Integer i=0; i<size; i++) 
            {
                Daily_Stats__c varDailyStats = new Daily_Stats__c();
                varDailyStats.Trailhead_User__c = varTrailheadUser.Id;
                varDailyStats.Date__c = (Date.today()).addDays(-i);
                varDailyStats.Badges__c = 0;
                varDailyStats.Points__c = 0;
                varDailyStats.Superbadges__c = 0;
                varDailyStats.Trails_Completed__c = 0;
                listDailyStats.add(varDailyStats);
            }
        }
        
        insert listDailyStats;
        return listDailyStats;
    }
    
    public static List<Trailhead_Badge__c> createTrailheadBadges(String type, Integer size)
    {
        List<Trailhead_Badge__c> listTrailheadBadges = new List<Trailhead_Badge__c>();
        for(Integer i=0; i<size; i++) {
            Trailhead_Badge__c varTrailheadBadge = new Trailhead_Badge__c();
            varTrailheadBadge.Name = 'Test '+i;
            varTrailheadBadge.Badge_Type__c = type;
            varTrailheadBadge.Icon_URL__c = 'Test Icon URL';
            varTrailheadBadge.Title__c = 'Test Title';
            varTrailheadBadge.URL__c = 'Test URL';                  
            listTrailheadBadges.add(varTrailheadBadge);
        }
        insert listTrailheadBadges;
        return listTrailheadBadges;
    }
    
    public static List<Badge_Achieved__c> createBadgesAchieved(Id trailheadUserId, List<Trailhead_Badge__c> listTrailheadBadges)
    {
        List<Badge_Achieved__c> listBadgesAchieved = new List<Badge_Achieved__c>();
        for(Trailhead_Badge__c varTrailheadBadge : listTrailheadBadges)
        {
            Badge_Achieved__c varBadgeAchieved = new Badge_Achieved__c();
            varBadgeAchieved.Trailhead_User__c = trailheadUserId;
            varBadgeAchieved.Trailhead_Badge__c = varTrailheadBadge.Id;
            listBadgesAchieved.add(varBadgeAchieved);
        }
        insert listBadgesAchieved;
        return listBadgesAchieved;
        
    }
    
}