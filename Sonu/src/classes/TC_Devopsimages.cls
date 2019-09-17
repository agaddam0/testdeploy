public with sharing class TC_Devopsimages {
    
    public class NotificationWrapper{
        @AuraEnabled
        public String src;
        @AuraEnabled
        public String header;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String alt;
        @AuraEnabled
        public String href;
        
        public NotificationWrapper(String src, String header, String description, String alt, String href){
            this.src = src;
            this.header = header;
            this.description = description;
            this.alt = alt;
            this.href = href;
        }
    }
    
    @AuraEnabled
    public static List<NotificationWrapper> getCarouselData() {
      
        String prefix;
        List<NotificationWrapper> lstOfNotificationWrapper = new List<NotificationWrapper>();
        if(String.isNotBlank(Network.getNetworkId())){
            for(Network networkData : [SELECT Id,UrlPathPrefix FROM Network WHERE Id =: Network.getNetworkId()]){
                if(String.isNotBlank(networkData.UrlPathPrefix)){
                    prefix = '..' + Label.Rich_Text_Image_Prefix;
                } else {
                    prefix = '.' + Label.Rich_Text_Image_Prefix;
                }
            }
        } else {
            prefix = Label.Rich_Text_Image_Prefix;
        }
        for(Devops_image__c notification : [SELECT Id, Content__c, Header__c, Header_Description__c, Alternative_Text__c, Href__c FROM Devops_image__c ]){
            if(String.isNotBlank(notification.Content__c)) 
           
            {
                for(String splittedData : notification.Content__c.split(Label.Rich_Text_Image_Prefix)){
                    if(splittedData.startsWith('?')){
                        lstOfNotificationWrapper.add(new NotificationWrapper(prefix + (splittedData.split('"')[0]).unescapeHtml4(), notification.Header__c, notification.Header_Description__c, notification.Alternative_Text__c, notification.Href__c));
                    }            
                }
            }
        }
        return lstOfNotificationWrapper;
    }
}