public without sharing class TrailheadTrackerBadgesController {
    
      
    public Boolean batchesProcessing{get;set;}
    public String searchKeyword {get;set;}
    public List<BadgeData> listBadges {get;set;}
    public List<BadgeData> listBadgesRaw {get;set;}
    
    public TrailheadTrackerBadgesController()
    {
        List<AsyncApexJob> asyncApexJobList  = [SELECT Id, Status, ApexClass.Name FROM AsyncApexJob 
                                                where ApexClass.Name = 'BatchToUpdateTrailheadStats' 
                                                AND (Status != 'Aborted' AND Status != 'Completed' AND Status != 'Failed')];       
        
        batchesProcessing = !asyncApexJobList.isEmpty();
        
        listBadges = new List<BadgeData>();
        listBadgesRaw = new List<BadgeData>();
        List<Trailhead_User__c> allTrailheadUsers = [Select Id, Name, Profile_Picture_URL__c from Trailhead_User__c];
        List<Trailhead_Badge__c> allTrailheadBadges = [Select Id, Name, Title__c, URL__c, Icon_URL__c, Badge_Type__c, CreatedDate, (Select Trailhead_User__c from Badges_Achieved__r) from Trailhead_Badge__c];
        
        for(Trailhead_Badge__c trailheadBadge : allTrailheadBadges)
        {
            
            List<UserData> completedBy = new List<UserData>();
            List<UserData> remainingUsers = new List<UserData>();
        
            Set<Id> usersThatCompletedtTrailheadBadge = new Set<Id>();
            for(Badge_Achieved__c badgeAchieved : trailheadBadge.Badges_Achieved__r)
            {
                usersThatCompletedtTrailheadBadge.add(badgeAchieved.Trailhead_User__c);
            }
            
            for(Trailhead_User__c trailheadUser : allTrailheadUsers)
            {
                if(usersThatCompletedtTrailheadBadge.contains(trailheadUser.Id))
                {
                    completedBy.add(new UserData(trailheadUser.Name, trailheadUser.Profile_Picture_URL__c, trailheadUser.Id));
                }
                else
                {
                   remainingUsers.add(new UserData(trailheadUser.Name, trailheadUser.Profile_Picture_URL__c, trailheadUser.Id));
                }
            }
            
            BadgeData varBadgeData = new BadgeData();
            varBadgeData.name = trailheadBadge.Title__c;
            varBadgeData.apiName = trailheadBadge.Name;
            varBadgeData.path = trailheadBadge.URL__c;
            varBadgeData.imageSRC = trailheadBadge.Icon_URL__c;  
            varBadgeData.type = trailheadBadge.Badge_Type__c.capitalize();
            varBadgeData.completedBy = completedBy; 
            varBadgeData.remainingUsers = remainingUsers; 
            varBadgeData.createdDate = (trailheadBadge.CreatedDate).date();
            listBadgesRaw.add(varBadgeData);
        }
        
        listBadges.addAll(listBadgesRaw);
        
        String searchParam = Apexpages.currentPage().getParameters().get('viewBadge');
        if(searchParam == null)
        {
            searchKeyword = '';
        }
        else
        {
            searchKeyword = searchParam.trim();
            performSearch();
        }
    }
    
    public void setSeachKeyword()
    {
        searchKeyword = (Apexpages.currentPage().getParameters().get('searchInput')).trim();
        performSearch();
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
        listBadges = new List<BadgeData>();
        if(searchKeyword == null || searchKeyword.length() == 0)
        {
            listBadges.addAll(listBadgesRaw);        
        }
        else
        {
            for(BadgeData badgeData : listBadgesRaw)
            {
                if(badgeData.Name.containsIgnoreCase(searchKeyword) || badgeData.apiName.equalsIgnoreCase(searchKeyword) )
                {    
                    listBadges.add(badgeData);
                }
            }
            
        }
    }
    
    public void reSortBadges()
    {
        String sortByValue = Apexpages.currentPage().getParameters().get('sortByValue');
        for(Integer i=0; i < listBadges.size(); i++)
        {  
            for(Integer j=1; j < (listBadges.size()-i); j++)
            {  
                if(sortByValue == 'Newest')
                {
                    if((listBadges[j-1]).createdDate < (listBadges[j]).createdDate )
                    {  
                        //swap elements  
                        BadgeData temp = listBadges[j-1];  
                        listBadges[j-1] = listBadges[j];  
                        listBadges[j] = temp;  
                    }  
                }
                else if(sortByValue == 'Name')
                {
                    if((listBadges[j-1]).Name > (listBadges[j]).Name )
                    {  
                        //swap elements  
                        BadgeData temp = listBadges[j-1];  
                        listBadges[j-1] = listBadges[j];  
                        listBadges[j] = temp;  
                    }  
                }
                else if(sortByValue == 'Completed By Count')
                {
                    if((listBadges[j-1]).completedBy.size() < (listBadges[j]).completedBy.size() )
                    {  
                        //swap elements  
                        BadgeData temp = listBadges[j-1];  
                        listBadges[j-1] = listBadges[j];  
                        listBadges[j] = temp;  
                    }  
                }
                else
                {
                    if((listBadges[j-1]).Type < (listBadges[j]).Type )
                    {  
                        //swap elements  
                        BadgeData temp = listBadges[j-1];  
                        listBadges[j-1] = listBadges[j];  
                        listBadges[j] = temp;  
                    }  
                }
                
                
            }  
        }  
    }
    
    // Wrapper class UserData
    public class UserData {
        
        public String name { get; set; }
        public String profilePicture { get; set; }
        public String id { get; set; }
        public String initials {get;set;}
        
        public userData(String name, String profilePicture, String id) {
            this.Name = Name;
            this.ProfilePicture = ProfilePicture;
            this.Id = Id;  
            
            Initials = (String.fromCharArray(new List<integer> { Name.charAt(0) } )+''+String.fromCharArray(new List<integer> { Name.charAt(Name.indexOf(' ')+1) }) ).toUpperCase();
        }
    }   
    
    // Wrapper class BadgeData
    public class BadgeData {
        
        public String name { get; set; }
        public String apiName { get; set; }
        public String path { get; set; }
        public String imageSRC { get; set; }
        public String type { get; set; }
        public List<UserData> completedBy {get;set;}
        public List<UserData> remainingUsers {get;set;}
        public Date createdDate { get; set; }
        
    }   
}