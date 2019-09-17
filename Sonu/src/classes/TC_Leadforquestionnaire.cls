public with sharing class TC_Leadforquestionnaire {
    
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
    
    @AuraEnabled
    public static List<String> validateEmail(String message){
        List<String> value = new List<String>();
     List<Lead> leadEmail = [select Id,Email,FirstName from Lead where Email =: message];
        for(Lead l :leadEmail){
            if(l.Email == message){
                value.add('Email Value is Already in exist');
                 value.add(l.Id);
                value.add(l.FirstName);
            }
          
        }
      return value;
    }


    @AuraEnabled
    public static String createSurvey(String leadId){
   
        system.debug('leadId'+leadId);
        Survey__c surveyObj = new Survey__c();
        surveyObj.Name = 'Record1';
        surveyObj.Lead_Name__c = leadId;      
         insert surveyObj;
        //Survey__c sur = [Select Id from Survey__c where Lead_Name__c=:leadId];
        return surveyObj.Id;
        
    }
   
        
}