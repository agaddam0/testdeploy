public class TC_notificationsDisplay {
    
    
  @Auraenabled
    public static List<NotWrapper> displayNotifications(){
        
        List<NotWrapper> notwl=new List<NotWrapper>();
        
       for( TC_Notifications__C noti : [select Content__c ,Publish_Date__c,Header_Description__c from TC_Notifications__C where Dedicated_To__c=:userinfo.getUserId()]) 
       
       {
           
           TC_Notifications__C notifications=new TC_Notifications__C();
           
           notifications=noti;
           
           				dateTime Publishdate=noti.Publish_Date__c;
           			Date pdate = date.newinstance(Publishdate.year(), Publishdate.month(),Publishdate.day());
           		date today=System.today();
           		integer diff=pdate.daysBetween(today);
           system.debug(diff);
        if( diff < 95) {
           NotWrapper notw= new NotWrapper( 'New', notifications );
                notwl.add(notw);
        }

        else {
           NotWrapper notw= new NotWrapper( '', notifications );
                notwl.add(notw);
        }
        
        
    }
        return notwl;
    }
    
    
        @Auraenabled
    public static void change(Id recid){
      List<TC_Notifications__C> notifications1=[select Read__c from TC_Notifications__C where Read__c=false and Dedicated_To__c=:userinfo.getUserId() and id=:recid];
        for(TC_Notifications__c t:notifications1){
            t.Read__c=true;
            update t;
        }
       
    }
    
   public class NotWrapper{
    @auraEnabled public string newLabel ;

    @auraEnabled public TC_Notifications__C notifications;
    public NotWrapper( string newLabel,  TC_Notifications__C notifications) {

        this.newLabel = newLabel;

        this.notifications = notifications;

        

    }

}
}