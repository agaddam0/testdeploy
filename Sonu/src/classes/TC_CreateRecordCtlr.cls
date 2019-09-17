public with sharing class TC_CreateRecordCtlr {
    
    @AuraEnabled
    public static String getRecordTypeId (String objectName, String recordTypeDeveloperName) {
        String recordTypeId;
        if(String.isNotBlank(objectName) && String.isNotBlank(recordTypeDeveloperName)){
            try{
                recordTypeId = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName).getRecordTypeId();
            }
            catch(Exception e){
                recordTypeId = '';                    
            }     
        }
        return recordTypeId;
    }
    
}