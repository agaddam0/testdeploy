/*
* Trailhead Tracker Application
* Shashwat Nandan
* 28/1/2019
*/
public without sharing class TrailheadTrackerHelper {
    
    public static String getTrailheadUserNameAndProfilePic(String trailheadId)
    {
        String name = 'No Name';
        String trailheadDisplayPic = 'No Profile Pic';
        Trailhead_Tracker__c tt = Trailhead_Tracker__c.getInstance();
        
        try{
            //callout to trailhead to retrieve webpage
            String body = getTrailheadProfileBody(trailheadId);
            //extract user's name and return it
            name = body.substringBetween(tt.Trailhead_User_Name_Begin__c, tt.Trailhead_User_Name_End__c).trim();
            trailheadDisplayPic = (body.substringBetween(tt.Trailhead_Display_Picture_Start__c, tt.Trailhead_Display_Picture_End__c).trim()).substringBetween('src="','"').trim();
            
            return name + ' @#$ ' + trailheadDisplayPic;
        }
        catch(Exception r){
            system.debug('Exception getTrailheadUserNameAndProfilePic:' + r);
            return name + ' @#$ ' + trailheadDisplayPic;
        }
        
    }
    
    public static Map<String, String> getTrailheadStats(String body)
    {
        Map<String, String> trailheadStats = new Map<String, String>();
        String badges = '0';
        String points = '0';
        String trailsCompleted = '0';
        
        Trailhead_Tracker__c tt = Trailhead_Tracker__c.getInstance();
        
        try
        {
            //extract user's stats - badges, points, trails
            badges = body.substringBetween(tt.Trailhead_Badges_Begin__c, tt.Trailhead_Badges_End__c).trim();
            points = body.substringBetween(tt.Trailhead_Points_Begin__c, tt.Trailhead_Points_End__c).trim().remove(',');
            trailsCompleted = body.substringBetween(tt.Trailhead_Trails_Begin__c, tt.Trailhead_Trails_End__c).trim();
            
            //return stats
            trailheadStats.put('Badges', badges);
            trailheadStats.put('Points', points);
            trailheadStats.put('TrailsCompleted', trailsCompleted);
            trailheadStats.put('Superbadges', getSuperbadgeCount(body));
            return trailheadStats;
        }
        catch(Exception e)
        {
            system.debug(''+e);
            return trailheadStats;            
        }
    }
    
    public static String getSuperbadgeCount(String trailheadProfileBody)
    {
        Integer superbadgeCount = 0;
        String jsonString = ((trailheadProfileBody.replace('&quot;', '"')).substringBetween('"BadgesPanel" data-react-props="', '">')).trim();
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        List<Object> badgesRawList = (List<Object>)jsonMap.get('badges'); 
        for(Integer i=0; i<badgesRawList.size(); i++)
        {
            Map<String, Object> badgesRawListVar = (Map<String, Object>)badgesRawList[i];
            String badgeType = String.valueOf(badgesRawListVar.get('badge_type'));
            
            if(badgeType.equalsIgnoreCase('superbadge'))
            {    
                superbadgeCount++;
            }
        }
        return String.valueOf(superbadgeCount);
    }
    
    public static String getTrailheadProfileBody(String trailheadId)
    {
        Trailhead_Tracker__c tt = Trailhead_Tracker__c.getInstance();
        
        //callout to trailhead to retrieve webpage        
        String url = tt.Trailhead_URL__c+trailheadId;
        //Instantiate a new http object
        Http http = new Http();
        //Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setTimeout(tt.Http_Request_Timeout__c.intValue());
        req.setMethod('GET');
        //Send the request, and return a response
        HttpResponse res = http.send(req);
        
        // redirection checking
        boolean redirect = false;
        if(res.getStatusCode() >=300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
            do {
                redirect = false; // reset the value each time
                String loc = res.getHeader('Location'); // get location of the redirect
                if(loc == null || loc.trim().length() == 0) {
                    redirect = false;
                    continue;
                }
                req = new HttpRequest();
                req.setEndpoint(loc);
                req.setMethod('GET');
                req.setTimeout(tt.Http_Request_Timeout__c.intValue());
                res = http.send(req);
                if(res.getStatusCode() != 500) { // 500 = fail
                    if(res.getStatusCode() >=300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
                        redirect= true;
                    }
                    
                }
            } while (redirect && Limits.getCallouts() != Limits.getLimitCallouts());
        }
        String body = res.getBody();
        
        return body;
    }
    
    public static Map<String, TrailheadBadge> getBadgesAchieved(String trailheadProfileBody)
    {
        Map<String, TrailheadBadge> returnMap = new Map<String, TrailheadBadge>(); 
        String jsonString = ((trailheadProfileBody.replace('&quot;', '"')).substringBetween('"BadgesPanel" data-react-props="', '">')).trim();
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        List<Object> badgesRawList = (List<Object>)jsonMap.get('badges');
        for(Integer i=0; i<badgesRawList.size(); i++)
        {
            Map<String, Object> badgesRawListVar = (Map<String, Object>)badgesRawList[i];
            String name = String.valueOf(badgesRawListVar.get('api_name'));
            String title = String.valueOf(badgesRawListVar.get('title'));
            String uRL = String.valueOf(badgesRawListVar.get('path'));
            String iconURL = String.valueOf(badgesRawListVar.get('icon_url'));
            String badgeType = String.valueOf(badgesRawListVar.get('badge_type'));
            
            if(Name == null)
            {    
                name = title;
                }
            
            if(URL == null)
            {
                uRL = 'https://trailhead.salesforce.com';
            }
            //else
            //    URL = 'https://trailhead.salesforce.com' + URL;
            
            
            TrailheadBadge trailheadBadge = new TrailheadBadge();
            trailheadBadge.name = name;
            trailheadBadge.title = title;
            trailheadBadge.uRL = uRL;
            trailheadBadge.iconURL = iconURL;
            trailheadBadge.badgeType = badgeType;

            returnMap.put(name, trailheadBadge);
        }
        return returnMap;
    }
    
    public static void saveTrailheadStats(List<String> trailheadUserIds, List<String> trailheadUserTrailheadIds)
    {
        Map<String, Id> trailheadBadgesMap = new Map<String,Id>();
        Map<Id, List<Id>> existingBadgesAchievedListMap = new Map<Id, List<Id>>();
        Map<Id, Map<String, TrailheadBadge>> badgesAchievedUserMap =  new Map<Id, Map<String, TrailheadBadge>>();
        List<Trailhead_Badge__c> trailheaBadgesList = new List<Trailhead_Badge__c>();
        List<Badge_Achieved__c> existingBadgesAchievedList = new List<Badge_Achieved__c>();
        if(Schema.SObjectType.Trailhead_Badge__c.isAccessible() && Schema.sObjectType.Trailhead_Badge__c.fields.Id.isAccessible() && Schema.sObjectType.Trailhead_Badge__c.fields.Name.isAccessible())
        {
            trailheaBadgesList = [Select Id, Name from Trailhead_Badge__c];
        }
        if(Schema.SObjectType.Badge_Achieved__c.isAccessible() && 
           Schema.sObjectType.Badge_Achieved__c.fields.Id.isAccessible() && Schema.sObjectType.Badge_Achieved__c.fields.Trailhead_User__c.isAccessible() && Schema.sObjectType.Badge_Achieved__c.fields.Trailhead_Badge__c.isAccessible() )
        {
            existingBadgesAchievedList = [Select Id, Trailhead_User__c, Trailhead_Badge__c from Badge_Achieved__c];
        }
        
        
        for(Trailhead_Badge__c trailheadBadge : trailheaBadgesList)
        {    
            trailheadBadgesMap.put(trailheadBadge.Name, trailheadBadge.Id);
        }
        
        for(Badge_Achieved__c existingBadgesAchieved : existingBadgesAchievedList)
        {
            if(existingBadgesAchievedListMap.containsKey(existingBadgesAchieved.Trailhead_User__c))
            {
                (existingBadgesAchievedListMap.get(existingBadgesAchieved.Trailhead_User__c)).add(existingBadgesAchieved.Trailhead_Badge__c);
            }
            else
            {
                existingBadgesAchievedListMap.put(existingBadgesAchieved.Trailhead_User__c, new List<Id> {existingBadgesAchieved.Trailhead_Badge__c});
            }
        }
        
        List<Daily_Stats__c> dailyStatsList = new List<Daily_Stats__c>();
        Date dateToday = date.today();
        for(Integer i=0; i<trailheadUserIds.size(); i++)
        {
            //callout to trailhead to retrieve webpage
            String body = getTrailheadProfileBody(trailheadUserTrailheadIds.get(i));
            badgesAchievedUserMap.put(trailheadUserIds.get(i), TrailheadTrackerHelper.getBadgesAchieved(body));
            
            Map<String, String> trailheadStats = TrailheadTrackerHelper.getTrailheadStats(body);
            if(!trailheadStats.isEmpty())
            {
                Daily_Stats__c dailyStatsRecord = new Daily_Stats__c();
                dailyStatsRecord.Trailhead_User__c = trailheadUserIds.get(i);
                dailyStatsRecord.Date__c = dateToday;
                dailyStatsRecord.Badges__c = Integer.valueOf(trailheadStats.get('Badges'));
                dailyStatsRecord.Points__c = Integer.valueOf(trailheadStats.get('Points'));
                dailyStatsRecord.Trails_Completed__c = Integer.valueOf(trailheadStats.get('TrailsCompleted'));
                dailyStatsRecord.Superbadges__c = Integer.valueOf(trailheadStats.get('Superbadges'));
                dailyStatsList.add(dailyStatsRecord);
            }
            
        }
        Database.SaveResult[] srList = Database.insert(dailyStatsList, false);
        List<String> errors = new List<String>();
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    errors.add(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        if(!errors.isEmpty())
        {    
            TrailheadTrackerHelper.sendErrorsEmail(errors);
        }
        
        List<Trailhead_Badge__c> newTrailheadBadgesList = new List<Trailhead_Badge__c>();
        List<Badge_Achieved__c> badgesAchievedList = new List<Badge_Achieved__c>();
        Map<String, TrailheadBadge> newBadgesMap = new Map<String, TrailheadBadge>();
        
        for(Id userId : badgesAchievedUserMap.keySet())
        {
            for(String badgeName : (badgesAchievedUserMap.get(userId)).keySet())
            {
                newBadgesMap.put(badgeName, (badgesAchievedUserMap.get(userId)).get(badgeName));
            }
        }
        
        
        for(String badgeName : newBadgesMap.keySet())
        {
            if(!trailheadBadgesMap.containsKey(badgeName))
            {
                TrailheadBadge trailheadBadge = newBadgesMap.get(badgeName);
                Trailhead_Badge__c newBadge = new Trailhead_Badge__c();
                newBadge.Name = trailheadBadge.Name;
                newBadge.Title__c = trailheadBadge.Title;
                newBadge.URL__c = trailheadBadge.URL;
                newBadge.Icon_URL__c = trailheadBadge.IconURL;
                newBadge.Badge_Type__c = trailheadBadge.BadgeType;
                newTrailheadBadgesList.add(newBadge);
            }
        }
        if(!newTrailheadBadgesList.isEmpty())
        {
            Database.SaveResult[] srList2 = Database.insert(newTrailheadBadgesList, false);
            for(Trailhead_Badge__c newbadge : newTrailheadBadgesList)
            {                
                trailheadBadgesMap.put(newbadge.Name, newbadge.Id);
            }        
        }
        
        for(Id userId : badgesAchievedUserMap.keySet())
        {
            for(String badgeName : (badgesAchievedUserMap.get(userId)).keySet())
            {
                Id badgeId = trailheadBadgesMap.get(badgeName);
                boolean flag = false;
                if(existingBadgesAchievedListMap.containsKey(userId))
                {
                    List<Id> tempList = existingBadgesAchievedListMap.get(userId);
                    for(Id existingBadgesAchieved : tempList)
                    {
                        if(existingBadgesAchieved == badgeId)
                        {
                            flag = true;
                            break;
                        }
                    }
                }
                if(!flag)
                {
                    Badge_Achieved__c badgeAchieved = new Badge_Achieved__c();
                    badgeAchieved.Trailhead_User__c = userId;
                    badgeAchieved.Trailhead_Badge__c = badgeId;
                    badgesAchievedList.add(badgeAchieved);                        
                }
            }
        }
        
        if(!badgesAchievedList.isEmpty())
        {   
            Database.SaveResult[] srList3 = Database.insert(badgesAchievedList, false);
        }
        
        
    }
    
    public static void sendErrorsEmail(List<String> errors)
    {
        try
        {
            Trailhead_Tracker__c tt = Trailhead_Tracker__c.getInstance();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { tt.Admin_Email__c};
                message.subject = 'Trailhead Tracker Errors';
            message.plainTextBody = ''+errors;
            Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> {message};
                if(!Test.isRunningTest()) { Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); }
        }
        catch(Exception e)
        {
            system.debug('Send Email Failed');
        }
    }
    
    // Wrapper class TrailheadBadge
    public class TrailheadBadge {
        
        
        public String name { get; set; }
        public String title { get; set; }
        public String uRL { get; set; }
        public String iconURL { get; set; }
        public String badgeType { get; set; }
        
    }  
}