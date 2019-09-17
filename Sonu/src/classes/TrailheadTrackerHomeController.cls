public without sharing class TrailheadTrackerHomeController {
    
    public Boolean batchesProcessing{get;set;}
    public List<TrailheadUser> trailheadUsers{get;set;}
    public List<TrailheadUser> trailheadUsersAllTime{get;set;}
    public List<TrailheadUser> trailheadUsersLast30Days{get;set;}
    public List<TrailheadUser> trailheadUsersLast5Days{get;set;}
    public boolean error{get;set;}
    public String errorMessage{get;set;}
    public boolean stranger{get;set;}
    public String welcomeMessage{get;set;}
    public Decimal averageTeamBadges{get;set;}
    public Decimal averageTeamPoints{get;set;}
    public Decimal averageTeamSuperbadges{get;set;}
    public Decimal averageTeamTrails{get;set;}
    public List<Trailhead_Badge__c> mostRecentBadgesList{get;set;}
    public List<Trailhead_Badge__c> mostCommonBadgesList{get;set;}
    public String leaderboardFilter{get;set;}
    public String chartFilter{get;set;}
    Map<String, PerformanceData> performanceDataMap{get;set;} 
    public List<PerformanceData> performanceDataList{get;set;}
    public Long totalTeamBadges{get; set;}
    public Long totalTeamPoints{get; set;}
    public List<TeamMemberRankCount> teamMemberRankCountList{get; set;}
    public List<BadgeTypeCount> badgeTypeCountList{get; set;}
    
    
    
    public TrailheadTrackerHomeController()
    {
    	String leaderboardFilterParam = null;
        if(Apexpages.currentPage().getParameters().get('leaderboardFilter') != null)
        {
        	leaderboardFilterParam = (Apexpages.currentPage().getParameters().get('leaderboardFilter')).escapeJava();
	    }
        if(leaderboardFilterParam == null)
        {
            leaderboardFilter = 'AllTime';
        }
        else
        {
            leaderboardFilter = leaderboardFilterParam;
        }
        
        chartFilter = 'AllTime';
        
        totalTeamBadges = 0;
        totalTeamPoints = 0;
        teamMemberRankCountList = new List<TeamMemberRankCount>();
        badgeTypeCountList = new List<BadgeTypeCount>();
        
        stranger = true;
        
        resetAlert();
        
        List<AsyncApexJob> asyncApexJobList  = [SELECT Id, Status, ApexClass.Name FROM AsyncApexJob 
                                                where ApexClass.Name = 'BatchToUpdateTrailheadStats' 
                                                AND (Status != 'Aborted' AND Status != 'Completed' AND Status != 'Failed')];       
        
        batchesProcessing = !asyncApexJobList.isEmpty();
        
        trailheadUsersAllTime = new List<TrailheadUser>();
        trailheadUsersLast30Days = new List<TrailheadUser>();
        trailheadUsersLAst5Days = new List<TrailheadUser>();
        
        Integer totalRangers = 0; 
        Integer totalExpeditioners = 0; 
        Integer totalMountaineers = 0; 
        Integer totalAdventurers = 0; 
        Integer totalExplorers = 0;
        Integer totalHikers = 0; 
        Integer totalScouts = 0;
        List<Trailhead_User__c> trailheadUsersRaw = [Select Id, Name, Trailhead_Id__c, Total_Badges__c, Total_Points__c, Total_Superbadges__c, Rank__c, (Select Id, Badges__c, Points__c, Trails_Completed__c, Superbadges__c from Daily_Stats__r ORDER BY Date__C DESC LIMIT 30) from Trailhead_User__c where Total_Badges__c != null order by Total_Badges__c DESC];
        for(Trailhead_User__c trailheadUserRaw : trailheadUsersRaw)
        {
            Daily_Stats__c dailyStats5DaysAgo;
            Daily_Stats__c dailyStats30DaysAgo;
            Decimal totalBadges = 0; 
            Decimal totalPoints = 0; 
            Decimal totalSuperBadges = 0; 
            Decimal totalTrails = 0;
            
            if(trailheadUserRaw.Daily_Stats__r.size()>0)
            {
                totalBadges = trailheadUserRaw.Daily_Stats__r[0].Badges__c;
                totalPoints = trailheadUserRaw.Daily_Stats__r[0].Points__c;
                totalSuperBadges = trailheadUserRaw.Daily_Stats__r[0].Superbadges__c;
                totalTrails = trailheadUserRaw.Daily_Stats__r[0].Trails_Completed__c;
            }
            
            
            totalTeamBadges = totalTeamBadges + Integer.valueOf(totalBadges);
            totalTeamPoints = totalTeamPoints + Integer.valueOf(totalPoints);
            
            if(getRank(totalBadges, totalPoints) == 'Ranger')
            { 
                totalRangers++;
            }
            if(getRank(totalBadges, totalPoints) == 'Expeditioner')
            {
                totalExpeditioners++;
            }
            if(getRank(totalBadges, totalPoints) == 'Mountaineer')
            {
                totalMountaineers++;
            }
            if(getRank(totalBadges, totalPoints) == 'Adventurer')
            {
                totalAdventurers++;
            }
            if(getRank(totalBadges, totalPoints) == 'Explorer')
            {
                totalExplorers++;
                }
            if(getRank(totalBadges, totalPoints) == 'Hiker')
            {
                totalHikers++;
            }
            if(getRank(totalBadges, totalPoints) == 'Scout')
            {
                totalScouts++;
            }
            
            
            if(trailheadUserRaw.Daily_Stats__r.size()>=5)
            {
                dailyStats5DaysAgo = trailheadUserRaw.Daily_Stats__r[4];
            }
            else
            {
                dailyStats5DaysAgo = trailheadUserRaw.Daily_Stats__r[trailheadUserRaw.Daily_Stats__r.size()-1];
            }
            
            if(trailheadUserRaw.Daily_Stats__r.size()>=30)
            {
                dailyStats30DaysAgo = trailheadUserRaw.Daily_Stats__r[29];
                
            }
            else
            {
                dailyStats30DaysAgo = trailheadUserRaw.Daily_Stats__r[trailheadUserRaw.Daily_Stats__r.size()-1];
            } 
            
            TrailheadUser varTrailheadUserAllTime = new TrailheadUser();
            varTrailheadUserAllTime.id = trailheadUserRaw.Id;
            varTrailheadUserAllTime.name = trailheadUserRaw.Name;
            varTrailheadUserAllTime.trailheadId = trailheadUserRaw.Trailhead_Id__c;   
            varTrailheadUserAllTime.totalBadges = totalBadges;
            varTrailheadUserAllTime.totalPoints = totalPoints;
            varTrailheadUserAllTime.totalTrails = totalTrails;  
            varTrailheadUserAllTime.totalSuperbadges = totalSuperBadges;
            varTrailheadUserAllTime.rank = trailheadUserRaw.Rank__c;

            trailheadUsersAllTime.add(varTrailheadUserAllTime);
            
            TrailheadUser varTrailheadUserLast5Days = new TrailheadUser();
            varTrailheadUserLast5Days.id = trailheadUserRaw.Id;
            varTrailheadUserLast5Days.name = trailheadUserRaw.Name;
            varTrailheadUserLast5Days.trailheadId = trailheadUserRaw.Trailhead_Id__c;   
            varTrailheadUserLast5Days.totalBadges = totalBadges - dailyStats5DaysAgo.Badges__c;
            varTrailheadUserLast5Days.totalPoints = totalPoints - dailyStats5DaysAgo.Points__c;
            varTrailheadUserLast5Days.totalTrails = totalTrails - dailyStats5DaysAgo.Trails_Completed__c;  
            varTrailheadUserLast5Days.totalSuperbadges = totalSuperBadges - dailyStats5DaysAgo.Superbadges__c;
            varTrailheadUserLast5Days.rank = trailheadUserRaw.Rank__c;
            trailheadUsersLast5Days.add(varTrailheadUserLast5Days);
            
            TrailheadUser varTrailheadUserLast30Days = new TrailheadUser();
            varTrailheadUserLast30Days.id = trailheadUserRaw.Id;
            varTrailheadUserLast30Days.name = trailheadUserRaw.Name;
            varTrailheadUserLast30Days.trailheadId = trailheadUserRaw.Trailhead_Id__c;   
            varTrailheadUserLast30Days.totalBadges = totalBadges - dailyStats30DaysAgo.Badges__c;
            varTrailheadUserLast30Days.totalPoints = totalPoints - dailyStats30DaysAgo.Points__c;
            varTrailheadUserLast30Days.totalTrails = totalTrails - dailyStats30DaysAgo.Trails_Completed__c;  
            varTrailheadUserLast30Days.totalSuperbadges = totalSuperBadges - dailyStats30DaysAgo.Superbadges__c;
            varTrailheadUserLast30Days.rank = trailheadUserRaw.Rank__c;
            trailheadUsersLast30Days.add(varTrailheadUserLast30Days);
            
        }
        
        teamMemberRankCountList.add(new TeamMemberRankCount('Ranger', totalRangers));
        teamMemberRankCountList.add(new TeamMemberRankCount('Expeditioner', totalExpeditioners));
        teamMemberRankCountList.add(new TeamMemberRankCount('Mountaineer', totalMountaineers));
        teamMemberRankCountList.add(new TeamMemberRankCount('Adventurer', totalAdventurers));
        teamMemberRankCountList.add(new TeamMemberRankCount('Explorer', totalExplorers));
        teamMemberRankCountList.add(new TeamMemberRankCount('Hiker', totalHikers));
        teamMemberRankCountList.add(new TeamMemberRankCount('Scout', totalScouts));
        
        
        leaderboardFilterChanged();
        
        performanceDataMap = new  Map<String, PerformanceData>();
        
        List<AggregateResult> dailyStatsAveragesList  = [select date__c, avg(Badges__c) avgbadges, avg(Points__c) avgpoints, avg(Trails_Completed__c) avgtrails from Daily_Stats__c group by date__c order by Date__c ASC];
        for(AggregateResult dailyStatsAverageVar : dailyStatsAveragesList)
        {
            PerformanceData varPerformanceData = new PerformanceData();                
            varPerformanceData.statDate = Date.valueOf(dailyStatsAverageVar.get('date__c')).format();
            varPerformanceData.averageBadges = (Decimal.valueOf(String.valueOf(dailyStatsAverageVar.get('avgbadges')))).setScale(2);
            varPerformanceData.averagePoints = (Decimal.valueOf(String.valueOf(dailyStatsAverageVar.get('avgpoints')))).setScale(2);
            varPerformanceData.averageTrails = (Decimal.valueOf(String.valueOf(dailyStatsAverageVar.get('avgtrails')))).setScale(2);
            
            performanceDataMap.put(Date.valueOf(dailyStatsAverageVar.get('date__c')).format(), varPerformanceData);
        }
        
        chartFilterChanged();
        
        Integer totalModules = 0; 
        Integer totalProjects = 0; 
        Integer totalSuperbadges = 0; 
        Integer totalEvents = 0;
        for(AggregateResult aggregateResultVar : [Select Count(Id) total, Badge_Type__c from Trailhead_Badge__c GROUP BY Badge_Type__c])
        {
            if(aggregateResultVar.get('Badge_Type__c') == 'module')
            {
                totalModules = totalModules + Integer.valueOf(aggregateResultVar.get('total'));
            }
            if(aggregateResultVar.get('Badge_Type__c') == 'project')
            {
                totalProjects = totalProjects + Integer.valueOf(aggregateResultVar.get('total'));
            }
            if(aggregateResultVar.get('Badge_Type__c') == 'superbadge')
            {
                totalSuperbadges = totalSuperbadges + Integer.valueOf(aggregateResultVar.get('total'));
            }
            if(aggregateResultVar.get('Badge_Type__c') == 'event')
            {
                totalEvents = totalEvents + Integer.valueOf(aggregateResultVar.get('total'));
            }
        }
        
        badgeTypeCountList.add(new BadgeTypeCount('Module', totalModules));
        badgeTypeCountList.add(new BadgeTypeCount('Project', totalProjects));
        badgeTypeCountList.add(new BadgeTypeCount('Superbadge', totalSuperbadges));
        badgeTypeCountList.add(new BadgeTypeCount('Event/Community', totalEvents));
        
        Integer totalUniqueBadges = totalModules + totalProjects + totalSuperbadges + totalEvents;
        Map<Id, Decimal> mapTrackerScore = new Map<Id, Decimal>();
        for(TrailheadUser varTrailheadUser : trailheadUsersAllTime)
        {
            if(totalUniqueBadges != 0)
            {
                mapTrackerScore.put(varTrailheadUser.Id,(varTrailheadUser.totalBadges*100/totalUniqueBadges).setScale(0));
            }
            else
            {
                mapTrackerScore.put(varTrailheadUser.Id, 0);
            }
 
        }
        
        for(TrailheadUser varTrailheadUser : trailheadUsersAllTime)
        {
            varTrailheadUser.trackerScore = mapTrackerScore.get(varTrailheadUser.Id);
        }
        for(TrailheadUser varTrailheadUser : trailheadUsersLast5Days)
        {
            varTrailheadUser.trackerScore = mapTrackerScore.get(varTrailheadUser.Id);     
        }
        for(TrailheadUser varTrailheadUser : trailheadUsersLast30Days)
        {
            varTrailheadUser.trackerScore = mapTrackerScore.get(varTrailheadUser.Id);     
        }
        
        mostRecentBadgesList = [Select Id, Name, Title__c, URL__c, Icon_Url__c, Badge_Type__c from Trailhead_Badge__c ORDER BY CreatedDate DESC LIMIT 9];
        mostCommonBadgesList = [Select Id, Name, Title__c, URL__c, Icon_Url__c, Badge_Type__c from Trailhead_Badge__c ORDER BY Total_Achievers__c DESC LIMIT 9];
        
    }
    
    
    public void leaderboardFilterChanged()
    {
        trailheadUsers = new List<TrailheadUser>();
        
        if(leaderboardFilter == 'Last5Days')
        {
            trailheadUsers.addAll(trailheadUsersLast5Days);
        }
        else if(leaderboardFilter == 'Last30Days')
        {
            trailheadUsers.addAll(trailheadUsersLast30Days);
        }
        else
        {
            trailheadUsers.addAll(trailheadUsersAllTime);
        }
        
        for(Integer i=0; i < trailheadUsers.size(); i++)
        {  
            for(Integer j=1; j < (trailheadUsers.size()-i); j++)
            {  
                if((trailheadUsers[j-1]).totalBadges < (trailheadUsers[j]).totalBadges )
                {  
                    //swap elements  
                    TrailheadUser temp = trailheadUsers[j-1];  
                    trailheadUsers[j-1] = trailheadUsers[j];  
                    trailheadUsers[j] = temp;  
                }  
                
            }  
        }  
        
        Decimal totalTeamBadges = 0; 
        Decimal totalTeamPoints = 0; 
        Decimal totalTeamSuperbadges = 0; 
        Decimal totalTeamTrails = 0;
        for(TrailheadUser trailheadUser : trailheadUsers)
        {
            totalTeamBadges = totalTeamBadges + trailheadUser.totalBadges;
            totalTeamPoints = totalTeamPoints + trailheadUser.totalPoints;
            totalTeamTrails = totalTeamTrails + trailheadUser.totalTrails;
            totalTeamSuperbadges = totalTeamSuperbadges + trailheadUser.totalSuperbadges;
        }
        
        if(!trailheadUsers.isEmpty())
        {
            averageTeamBadges = (totalTeamBadges/(trailheadUsers.size())).setScale(2);
            averageTeamPoints = (totalTeamPoints/(trailheadUsers.size())).setScale(2);
            averageTeamTrails = (totalTeamTrails/(trailheadUsers.size())).setScale(2);
            averageTeamSuperbadges = (totalTeamSuperbadges/(trailheadUsers.size())).setScale(2);
        }
        else
        {
            averageTeamBadges = 0;
            averageTeamPoints = 0;
            averageTeamTrails = 0;
            averageTeamSuperbadges = 0;
        }
        
    }
    
    public void chartFilterChanged()
    {
        performanceDataList = new List<PerformanceData>();
        List<String> statDates = new List<String>();
        statDates.addAll(performanceDataMap.keySet());
        
        Integer entriesToShow = statDates.size();
        system.debug('entriesToShow'+entriesToShow);
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
            for(String statDate : statDates)
            {
                performanceDataList.add(performanceDataMap.get(statDate));
            }
        }
        system.debug(performanceDataList);
    }
    
    public PageReference reRunBatch()
    {
        BatchToUpdateTrailheadStats batchToUpdateTrailheadStats = new BatchToUpdateTrailheadStats(); 
        database.executebatch(batchToUpdateTrailheadStats, 1);
        
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    
    
    
    public String getRank(Decimal badges, Decimal points)
    {
        Integer badgesCount = Integer.valueOf(badges);
        Integer pointsCount = Integer.valueOf(points);
        
        if(badgesCount >= 100 && pointsCount >= 50000)
        {
            return 'Ranger'; 
        }
        else if(badgesCount >= 50 && pointsCount >= 35000)
        {
            return 'Expeditioner';
        }
        else if(badgesCount >= 25 && pointsCount >= 18000)
        {
            return 'Mountaineer';
        }
        else if(badgesCount >= 10 && pointsCount >= 9000)
        {
            return 'Adventurer';
        }
        else if(badgesCount >= 5 && pointsCount >= 3000)
        {
            return 'Explorer';
        }
        else if(badgesCount >= 1 && pointsCount >= 200)
        {
            return 'Hiker';
        }
        else 
        {
            return 'Scout';
        }
    }
    
    public void resetAlert()
    {
        error = false;
        errorMessage = '';
    }
    public void showError(String message)
    {
        error = true;
        errorMessage = message;
    }
    
    public void saveTrailheadUser()
    {
        resetAlert();
        String trailheadId = (Apexpages.currentPage().getParameters().get('trailheadId')).escapeJava();
        if(trailheadId.trim().length() == 0)
        {
            showError('Trailhead Id is required');
        }
        else
        {
            Trailhead_User__c trailheadUser = new Trailhead_User__c();
            trailheadUser.Trailhead_Id__c = trailheadId;
            String nameAndProfilePic = TrailheadTrackerHelper.getTrailheadUserNameAndProfilePic(trailheadId);
            system.debug('nameAndProfilePic'+nameAndProfilePic);
            String name = nameAndProfilePic.substringBefore('@#$').trim();
            String trailheadDisplayPic = nameAndProfilePic.substringAfter('@#$').trim();
            if(name == 'No Name')
            {
                showError('Trailhead Id seems incorrect. Try another one. Make sure that the profile is \'Public\'.');
            }
            else
            {
                trailheadUser.Name = name;
                trailheadUser.Profile_Picture_URL__c = trailheadDisplayPic;
                Database.SaveResult sr = Database.insert(trailheadUser, false);
                if(sr.isSuccess())
                {
                    stranger = false;
                    welcomeMessage ='Welcome, '+name+'. You have been successfully added to the TEK Systems Trailhead Tracker. Refresh the page (maybe more than one time) to see yourself on the leaderboard.';
                }
                else
                {
                    String errors ='';
                    for(Database.Error err : sr.getErrors()) {
                        errors = errors + ' ' + err.getMessage();
                    }
                    showError(errors);
                }
            }
        }
    }
    
    
    // Wrapper class TrailheadUser
    public class TrailheadUser 
    {
        public String id { get; set; }
        public String name { get; set; }
        public String trailheadId { get; set; }
        public Decimal totalBadges { get; set; }
        public Decimal totalPoints { get; set; }
        public Decimal totalTrails { get; set; }
        public Decimal totalSuperbadges { get; set; }
        public String rank { get; set; }
        public Decimal trackerScore { get; set; }
    }   
    
    // Wrapper class PerformanceData
    public class PerformanceData
    {
        public String statDate { get; set; }
        public Decimal averageBadges { get; set; }
        public Decimal averagePoints { get; set; }
        public Decimal averageTrails { get; set; }
    }   
    
    public class BadgeTypeCount
    {
        public String badgeType{get; set;}
        public Integer count{get;set;}
        public BadgeTypeCount(String badgeType, Integer count)
        {
            this.badgeType = badgeType;
            this.count = count;
        } 
    }
    
    public class TeamMemberRankCount
    {
        public String rank{get; set;}
        public Integer memberCount{get;set;}
        public TeamMemberRankCount(String rank, Integer memberCount)
        {
            this.rank = rank;
            this.memberCount = memberCount;
        }
    }
    
}