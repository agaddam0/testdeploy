public without sharing class TrailheadTrackerDetailsController {
    
    public Boolean batchesProcessing{get;set;}
    public Trailhead_User__c trailheadUser{get;set;}
    public String totalBadges{get;set;}
    public String totalPoints{get;set;}
    public String totalTrailsCompleted{get;set;}
    public String rank{get;set;}
    public Decimal totalSuperbadges{get;set;}
    public String trailheadDisplayPic{get;set;}
    public String initials{get;set;}
    public List<BadgeData> moduleBadgesList{get;set;}
    public List<BadgeData> projectBadgesList{get;set;}
    public List<BadgeData> superbadgeBadgesList{get;set;}
    public List<BadgeData> moduleBadgesListRaw{get;set;}
    public List<BadgeData> projectBadgesListRaw{get;set;}
    public List<BadgeData> superbadgeBadgesListRaw{get;set;}
    public List<BadgeData> pendingModuleBadgesListRaw{get;set;}
    public List<BadgeData> pendingProjectBadgesListRaw{get;set;}
    public List<BadgeData> pendingSuperbadgeBadgesListRaw{get;set;}
    Map<Date, PerformanceData> performanceDataMap{get;set;} 
    public List<PerformanceData> performanceDataList{get;set;}    
    public String chartFilter{get;set;}
    public boolean toggleAverage{get;set;}
    public boolean showPendingBadges{get;set;}
    public List<PendingModulesCount> pendingModulesCountList{get; set;}
    public List<PendingProjectsCount> pendingProjectsCountList{get; set;}
    public List<PendingSuperbadgesCount> pendingSuperbadgesCountList{get; set;}
    
    
    public TrailheadTrackerDetailsController()
    {
        chartFilter = 'AllTime';
        toggleAverage = false;
        showPendingBadges = false;
        String id = Apexpages.currentPage().getParameters().get('id');
        
        List<AsyncApexJob> asyncApexJobList  = [SELECT Id, Status, ApexClass.Name FROM AsyncApexJob 
                                                where ApexClass.Name = 'BatchToUpdateTrailheadStats' 
                                                AND (Status != 'Aborted' AND Status != 'Completed' AND Status != 'Failed')];       
        
        batchesProcessing = !asyncApexJobList.isEmpty();
        
        performanceDataMap = new Map<Date,PerformanceData>();
        List<Daily_Stats__c> dailyStatsList  = [Select Id, Date__c, Badges__c, Points__c, Trails_Completed__c from Daily_Stats__c where Trailhead_User__c =:id order by Date__c ASC];
        List<AggregateResult> dailyStatsAveragesList  = [select date__c, avg(Badges__c) avgbadges, avg(Points__c) avgpoints, avg(Trails_Completed__c) avgtrails from Daily_Stats__c group by date__c order by Date__c ASC];
        Map<Date, AggregateResult> dailyStatsAveragesMap = new Map<Date, AggregateResult>();
        for(AggregateResult dailyStatsAverageVar : dailyStatsAveragesList)
        {
            dailyStatsAveragesMap.put(Date.valueOf(dailyStatsAverageVar.get('Date__c')), dailyStatsAverageVar);
        }
        
        for(Daily_Stats__c dailyStatsVar : dailyStatsList)
        {
            PerformanceData varPerformanceData = new PerformanceData();
            varPerformanceData.statDate = String.valueOf(dailyStatsVar.Date__c);
            varPerformanceData.badges = dailyStatsVar.Badges__c;
            varPerformanceData.averageBadges = Decimal.valueOf(String.valueOf((dailyStatsAveragesMap.get(dailyStatsVar.Date__c)).get('avgbadges')));
            varPerformanceData.points = dailyStatsVar.Points__c;  
            varPerformanceData.averagePoints = Decimal.valueOf(String.valueOf((dailyStatsAveragesMap.get(dailyStatsVar.Date__c)).get('avgpoints')));
            varPerformanceData.trails = dailyStatsVar.Trails_Completed__c;            
            varPerformanceData.averageTrails = Decimal.valueOf(String.valueOf((dailyStatsAveragesMap.get(dailyStatsVar.Date__c)).get('avgtrails')));
            performanceDataMap.put(dailyStatsVar.Date__c, varPerformanceData);
        }

        trailheadUser = [Select Id, Name, Trailhead_Id__c, Profile_Picture_URL__c, Total_Badges__c, Total_Points__c, Total_Superbadges__c, Rank__c, (Select Id, Badges__c, Points__c, Trails_Completed__c, Superbadges__c from Daily_Stats__r ORDER BY Date__C DESC LIMIT 1) from Trailhead_User__c where Id=:id limit 1];
        String trailheadId = trailheadUser.Trailhead_Id__c;
        
        trailheadDisplayPic = trailheadUser.Profile_Picture_URL__c;
        initials = (String.fromCharArray(new List<integer> { trailheadUser.Name.charAt(0) } )+''+String.fromCharArray(new List<integer> { trailheadUser.Name.charAt(trailheadUser.Name.indexOf(' ')+1) }) ).toUpperCase();
        
        if(trailheadUser.Daily_Stats__r.size() > 0)
        {
            totalBadges = String.valueOf(trailheadUser.Daily_Stats__r[0].Badges__c);
            totalPoints = String.valueOf(trailheadUser.Daily_Stats__r[0].Points__c);
            totalTrailsCompleted = String.valueOf(trailheadUser.Daily_Stats__r[0].Trails_Completed__c);
            totalSuperbadges = trailheadUser.Daily_Stats__r[0].Superbadges__c;
        }
        else
        {
            totalBadges = String.valueOf(trailheadUser.Total_Badges__c);
            totalPoints = String.valueOf(trailheadUser.Total_Points__c);
            totalTrailsCompleted = String.valueOf(0);
            totalSuperbadges = trailheadUser.Total_Superbadges__c;
        }
        
        
        rank = trailheadUser.Rank__c;
        
        moduleBadgesList = new List<BadgeData>();
        projectBadgesList = new List<BadgeData>();
        superbadgeBadgesList = new List<BadgeData>();
        moduleBadgesListRaw = new List<BadgeData>();
        projectBadgesListRaw = new List<BadgeData>();
        superbadgeBadgesListRaw = new List<BadgeData>();
        pendingModuleBadgesListRaw = new List<BadgeData>();
        pendingProjectBadgesListRaw = new List<BadgeData>();
        pendingSuperbadgeBadgesListRaw = new List<BadgeData>();
        pendingModulesCountList = new List<PendingModulesCount>();
        pendingProjectsCountList = new List<PendingProjectsCount>();
        pendingSuperbadgesCountList = new List<PendingSuperbadgesCount>();
        
        //List<Badge_Achieved__c> listBadgesAchieved = [Select Id, Trailhead_Badge__r.Name, Trailhead_Badge__r.Title__c, Trailhead_Badge__r.URL__c, Trailhead_Badge__r.Icon_Url__c, Trailhead_Badge__r.Badge_Type__c from Badge_Achieved__c where Trailhead_User__c = :id ORDER by CreatedDate DESC];
        for(Trailhead_Badge__c varTrailheadBadge : [Select Id, Name, Title__c, URL__c, Icon_Url__c, Badge_Type__c, (Select Id, Trailhead_User__c from Badges_Achieved__r  where Trailhead_User__c = :id ) from Trailhead_Badge__c ORDER by CreatedDate DESC])
        {
            String name = varTrailheadBadge.Title__c;
            String apiName = varTrailheadBadge.Name;
            String path = varTrailheadBadge.URL__c;
            String imageSRC = varTrailheadBadge.Icon_Url__c;
            String badgeType =  varTrailheadBadge.Badge_Type__c ;
            List<Badge_Achieved__c> listBadgesAchieved = varTrailheadBadge.Badges_Achieved__r;
            
            if(listBadgesAchieved != null && listBadgesAchieved.size()>0)
            {
                if(badgeType.equalsIgnoreCase('project'))
                {    
                    BadgeData varBadgeData = new BadgeData();
                    varBadgeData.name = name;
                    varBadgeData.apiName = apiName;
                    varBadgeData.path = path;
                    varBadgeData.imageSRC = imageSRC; 
                    projectBadgesListRaw.add(varBadgeData);
                }
                else if(badgeType.equalsIgnoreCase('superbadge'))
                {
                    BadgeData varBadgeData = new BadgeData();
                    varBadgeData.name = name;
                    varBadgeData.apiName = apiName;
                    varBadgeData.path = path;
                    varBadgeData.imageSRC = imageSRC;
                    superbadgeBadgesListRaw.add(varBadgeData);
                }
                else
                {                   
                    BadgeData varBadgeData = new BadgeData();
                    varBadgeData.name = name;
                    varBadgeData.apiName = apiName;
                    varBadgeData.path = path;
                    varBadgeData.imageSRC = imageSRC;
                    moduleBadgesListRaw.add(varBadgeData);
                }            
            }
            else
            {
                if(badgeType.equalsIgnoreCase('project'))
                {
                    BadgeData varBadgeData = new BadgeData();
                    varBadgeData.name = name;
                    varBadgeData.apiName = apiName;
                    varBadgeData.path = path;
                    varBadgeData.imageSRC = imageSRC;
                    pendingProjectBadgesListRaw.add(varBadgeData);
                }
                else if(badgeType.equalsIgnoreCase('superbadge'))
                {
                    BadgeData varBadgeData = new BadgeData();
                    varBadgeData.name = name;
                    varBadgeData.apiName = apiName;
                    varBadgeData.path = path;
                    varBadgeData.imageSRC = imageSRC;
                    pendingSuperbadgeBadgesListRaw.add(varBadgeData);
                }
                else
                {
                    BadgeData varBadgeData = new BadgeData();
                    varBadgeData.name = name;
                    varBadgeData.apiName = apiName;
                    varBadgeData.path = path;
                    varBadgeData.imageSRC = imageSRC;
                    pendingModuleBadgesListRaw.add(varBadgeData);
                } 
            }
        }
        pendingModulesCountList.add(new PendingModulesCount('Completed', moduleBadgesListRaw.size()));
        pendingModulesCountList.add(new PendingModulesCount('Yet to Complete', pendingModuleBadgesListRaw.size()));
        
        pendingProjectsCountList.add(new PendingProjectsCount('Completed', projectBadgesListRaw.size()));
        pendingProjectsCountList.add(new PendingProjectsCount('Yet to Complete', pendingProjectBadgesListRaw.size()));
        
        pendingSuperbadgesCountList.add(new PendingSuperbadgesCount('Completed', superbadgeBadgesListRaw.size()));
        pendingSuperbadgesCountList.add(new PendingSuperbadgesCount('Yet to Complete', pendingSuperbadgeBadgesListRaw.size()));
        
        moduleBadgesList.addAll(moduleBadgesListRaw);
        projectBadgesList.addAll(projectBadgesListRaw);
        superbadgeBadgesList.addAll(superbadgeBadgesListRaw);
        
        performanceDataList = new List<PerformanceData>();
        for(Date statDate : performanceDataMap.keySet())
        {
            performanceDataList.add(performanceDataMap.get(statDate));
        }
        
    }
    
    public PageReference reRunBatch()
    {
        BatchToUpdateTrailheadStats batchToUpdateTrailheadStats = new BatchToUpdateTrailheadStats(); 
        database.executebatch(batchToUpdateTrailheadStats, 1);
        
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    
    public void performSearch()
    {
        String searchInput = (Apexpages.currentPage().getParameters().get('searchInput')).escapeJava();
        moduleBadgesList = new List<BadgeData>();
        projectBadgesList = new List<BadgeData>();
        superbadgeBadgesList = new List<BadgeData>();
        
        if(searchInput == null || (searchInput.trim()).length() == 0)
        {
            moduleBadgesList.addAll(moduleBadgesListRaw);
            projectBadgesList.addAll(projectBadgesListRaw);
            superbadgeBadgesList.addAll(superbadgeBadgesListRaw);
        }
        else
        {
            for(BadgeData badgeDataModule : moduleBadgesListRaw)
            {
                if(badgeDataModule.Name.containsIgnoreCase(searchInput))
                {
                    moduleBadgesList.add(badgeDataModule);
                }
            }
            for(BadgeData badgeDataProject : projectBadgesListRaw)
            {
                if(badgeDataProject.Name.containsIgnoreCase(searchInput))
                {
                    projectBadgesList.add(badgeDataProject);
                }
            }
            for(BadgeData badgeDataSuperbadge : superbadgeBadgesListRaw)
            {
                if(badgeDataSuperbadge.Name.containsIgnoreCase(searchInput))
                {
                    superbadgeBadgesList.add(badgeDataSuperbadge);
                }
            }
        }
        
    }
    
    
    public void chartFilterChanged()
    {
        toggleAverage = false;
        performanceDataList = new List<PerformanceData>();
        List<Date> statDates = new List<Date>();
        statDates.addAll(performanceDataMap.keySet());
        
        Integer entriesToShow = statDates.size();
        
        if(chartFilter == 'Last5Days')
        {
            entriesToShow = 5;
        }
        else if(chartFilter == 'Last30Days')
        {
            entriesToShow = 30;
        }
        
        if(entriesToShow < statDates.size())
        {
            for(Integer i=(statDates.size()-entriesToShow); i<statDates.size() ;i++)
            {
                performanceDataList.add(performanceDataMap.get(statDates[i]));
            }
        }
        else
        {
            for(Date statDate : statDates)
            {
                performanceDataList.add(performanceDataMap.get(statDate));
            }
        }
        
    }
    
    
    
    // Wrapper class PerformanceData
    public class PerformanceData 
    {
        public String statDate { get; set; }
        public Decimal badges { get; set; }
        public Decimal averageBadges { get; set; }
        public Decimal points { get; set; }
        public Decimal averagePoints { get; set; }
        public Decimal trails { get; set; }
        public Decimal averageTrails { get; set; }
    }   
    
    // Wrapper class BadgeData
    public class BadgeData 
    {
        public String name { get; set; }
        public String apiName {get;set;}
        public String path { get; set; }
        public String imageSRC { get; set; }
    }       
    
    
    public class PendingModulesCount
    {
        public String label{get; set;}
        public Integer count{get;set;}
        public PendingModulesCount(String label, Integer count)
        {
            this.label = label;
            this.count = count;
        } 
    }
    public class PendingProjectsCount
    {
        public String label{get; set;}
        public Integer count{get;set;}
        public PendingProjectsCount(String label, Integer count)
        {
            this.label = label;
            this.count = count;
        } 
    }
    public class PendingSuperbadgesCount
    {
        public String label{get; set;}
        public Integer count{get;set;}
        public PendingSuperbadgesCount(String label, Integer count)
        {
            this.label = label;
            this.count = count;
        } 
    }
    
}