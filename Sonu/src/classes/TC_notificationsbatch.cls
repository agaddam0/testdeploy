global class TC_notificationsbatch implements Database.Batchable<sObject> {
    global string query;

  global Database.QueryLocator start(Database.BatchableContext BC) {
	query = 'select Name,Content__c,Valid_till__c,Read__c from TC_Notifications__c order by createddate desc';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<TC_Notifications__c> scope) {
		List<TC_Notifications__c> notifications=new List<TC_Notifications__c>();
		for(TC_Notifications__c t:scope){
			if(t.Read__c == true && t.Valid_till__c<system.TODAY()){
				notifications.add(t);

			}
			
		} 
                delete notifications;        
         }

 
    global void finish(Database.BatchableContext BC) {
    }
}