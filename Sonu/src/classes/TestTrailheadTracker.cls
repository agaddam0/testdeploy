@isTest
public class TestTrailheadTracker {
    
    @TestSetup
    public static void testSetupMethod()
    {
        TestDataFactory.createMetadataTrailheadTracker(); 
    }
    
    @isTest
    public static void testTrailheadTrackerHomeController()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());
        
        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(1);
        system.assertEquals(1, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        system.assertEquals(1, listDailyStats.size());
        TestDataFactory.createTrailheadBadges('module', 1);
        TestDataFactory.createTrailheadBadges('project', 1);
        TestDataFactory.createTrailheadBadges('superbadge', 1);
        TestDataFactory.createTrailheadBadges('event', 1);        
        TrailheadTrackerHomeController varTrailheadTrackerHomeController = new TrailheadTrackerHomeController();
        
        varTrailheadTrackerHomeController.leaderboardFilter = 'Last5Days';
        varTrailheadTrackerHomeController.leaderboardFilterChanged();
        varTrailheadTrackerHomeController.leaderboardFilter = 'Last30Days';
        varTrailheadTrackerHomeController.leaderboardFilterChanged();
        varTrailheadTrackerHomeController.chartFilter = 'Last5Days';
        varTrailheadTrackerHomeController.chartFilterChanged();
        varTrailheadTrackerHomeController.chartFilter = 'Last30Days';
        varTrailheadTrackerHomeController.chartFilterChanged();
        
    }
    
    @isTest
    public static void testTrailheadTrackerHomeControllerSaveTrailheadUser()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());

        Test.setCurrentPageReference(new PageReference('Page.TrailheadTrackerHomeController'));
        System.currentPageReference().getParameters().put('leaderboardFilter', 'Last5Days');
        TrailheadTrackerHomeController varTrailheadTrackerHomeController = new TrailheadTrackerHomeController();
        System.currentPageReference().getParameters().put('trailheadId', '');
        varTrailheadTrackerHomeController.saveTrailheadUser();
        System.currentPageReference().getParameters().put('trailheadId', 'test123');
        varTrailheadTrackerHomeController.saveTrailheadUser();
        Test.startTest();
        varTrailheadTrackerHomeController.saveTrailheadUser();
        Test.stopTest();

        List<Trailhead_User__c> listTrailheadUsers = [Select Id from Trailhead_User__c where Trailhead_Id__c = 'test123'];
        system.assertEquals(1, listTrailheadUsers.size());
    }
    
    @isTest
    public static void testTrailheadTrackerHomeControllerRerunBatch()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());

        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(1);
        system.assertEquals(1, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        TrailheadTrackerHomeController varTrailheadTrackerHomeController = new TrailheadTrackerHomeController();
        varTrailheadTrackerHomeController.reRunBatch();            
    }
    
    @isTest
    public static void testTrailheadTrackerSystemStatusController()
    {
        TrailheadTrackerSystemStatusController varTrailheadTrackerSystemStatusController = new TrailheadTrackerSystemStatusController();
        system.assert(varTrailheadTrackerSystemStatusController.batchJobsList != null);
    }
    
    @isTest
    public static void testTrailheadTrackerDetailsController()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());

        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(1);
        system.assertEquals(1, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        List<Trailhead_Badge__c> listTrailheadBadgesModules = TestDataFactory.createTrailheadBadges('module', 1);
        List<Trailhead_Badge__c> listTrailheadBadgesProjects = TestDataFactory.createTrailheadBadges('project', 1);
        List<Trailhead_Badge__c> listTrailheadBadgesSuperbadges = TestDataFactory.createTrailheadBadges('superbadge', 1);
        List<Trailhead_Badge__c> listTrailheadBadgesEvents = TestDataFactory.createTrailheadBadges('event', 1);  
        
        Test.setCurrentPageReference(new PageReference('Page.TrailheadTrackerDetailsController'));
        System.currentPageReference().getParameters().put('id', listTrailheadUsers[0].Id);
        TrailheadTrackerDetailsController varTrailheadTrackerDetailsController = new TrailheadTrackerDetailsController();
        
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesModules);
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesProjects);
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesSuperbadges);
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesEvents);
        
        Test.setCurrentPageReference(new PageReference('Page.TrailheadTrackerDetailsController'));
        System.currentPageReference().getParameters().put('id', listTrailheadUsers[0].Id);
        varTrailheadTrackerDetailsController = new TrailheadTrackerDetailsController();
        System.currentPageReference().getParameters().put('searchInput', 'Test');
        varTrailheadTrackerDetailsController.performSearch();
        System.currentPageReference().getParameters().put('searchInput', '');
        varTrailheadTrackerDetailsController.performSearch();   
        varTrailheadTrackerDetailsController.reRunBatch();
        varTrailheadTrackerDetailsController.chartFilterChanged();
        varTrailheadTrackerDetailsController.chartFilter = 'Last5Days';       
        varTrailheadTrackerDetailsController.chartFilterChanged();
        varTrailheadTrackerDetailsController.chartFilter = 'Last30Days';
        varTrailheadTrackerDetailsController.chartFilterChanged();
    }
    
    @isTest
    public static void testTrailheadTrackerBadgesController()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());

        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(2);
        system.assertEquals(2, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        List<Trailhead_Badge__c> listTrailheadBadgesModules = TestDataFactory.createTrailheadBadges('module', 2);
        List<Trailhead_Badge__c> listTrailheadBadgesProjects = TestDataFactory.createTrailheadBadges('project', 2);
        List<Trailhead_Badge__c> listTrailheadBadgesSuperbadges = TestDataFactory.createTrailheadBadges('superbadge', 2);
        List<Trailhead_Badge__c> listTrailheadBadgesEvents = TestDataFactory.createTrailheadBadges('event', 2);  
        
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesModules);
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesProjects);
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesSuperbadges);
        TestDataFactory.createBadgesAchieved(listTrailheadUsers[0].id, listTrailheadBadgesEvents);
        
        Test.setCurrentPageReference(new PageReference('Page.TrailheadTrackerBadgesController'));
        System.currentPageReference().getParameters().put('viewBadge', 'Test');
        TrailheadTrackerBadgesController varTrailheadTrackerBadgesController = new TrailheadTrackerBadgesController();
        
        System.currentPageReference().getParameters().put('viewBadge', null);
        varTrailheadTrackerBadgesController = new TrailheadTrackerBadgesController();
        System.currentPageReference().getParameters().put('searchInput', 'Test');
        varTrailheadTrackerBadgesController.setSeachKeyword();
        varTrailheadTrackerBadgesController.performSearch();   
        System.currentPageReference().getParameters().put('searchInput', '');
        varTrailheadTrackerBadgesController.setSeachKeyword();
        varTrailheadTrackerBadgesController.performSearch();  
        
        System.currentPageReference().getParameters().put('sortByValue', 'Newest');
        varTrailheadTrackerBadgesController.reSortBadges();                
        System.currentPageReference().getParameters().put('sortByValue', 'Name');
        varTrailheadTrackerBadgesController.reSortBadges();
        System.currentPageReference().getParameters().put('sortByValue', 'Completed By Count');
        varTrailheadTrackerBadgesController.reSortBadges();
        System.currentPageReference().getParameters().put('sortByValue', 'Test');
        varTrailheadTrackerBadgesController.reSortBadges();
        
    }
    
    @isTest
    public static void testTrailheadTrackerBadgesControllerRerunBatch()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());

        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(1);
        system.assertEquals(1, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        TrailheadTrackerBadgesController varTrailheadTrackerBadgesController = new TrailheadTrackerBadgesController();
        varTrailheadTrackerBadgesController.reRunBatch();            
    }
    
    @isTest
    public static void testTrailheadTrackerBatch()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerMockHttp());

        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(1);
        system.assertEquals(1, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        
        Test.StartTest();
        ScheduleBatchToUpdateTrailheadStats varScheduleBatchToUpdateTrailheadStats = new ScheduleBatchToUpdateTrailheadStats();        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Batch', sch, varScheduleBatchToUpdateTrailheadStats); 
       	
		List<String> errors = new List<String>();
        TrailheadTrackerHelper.sendErrorsEmail(errors);
            
        Test.stopTest(); 
    }
    
     @isTest
    public static void testTrailheadTrackerBatchRedirect()
    {
        Test.setMock(HttpCalloutMock.class, new TrailheadTrackerRedirectMockHttp());

        List<Trailhead_User__c> listTrailheadUsers = TestDataFactory.createTrailheadUsers(1);
        system.assertEquals(1, listTrailheadUsers.size());
        List<Daily_Stats__c> listDailyStats = TestDataFactory.createDailyStats(listTrailheadUsers, 1);
        
        Test.StartTest();
        ScheduleBatchToUpdateTrailheadStats varScheduleBatchToUpdateTrailheadStats = new ScheduleBatchToUpdateTrailheadStats();        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Batch', sch, varScheduleBatchToUpdateTrailheadStats); 
       	
		List<String> errors = new List<String>();
        TrailheadTrackerHelper.sendErrorsEmail(errors);
            
        Test.stopTest(); 
    }

}