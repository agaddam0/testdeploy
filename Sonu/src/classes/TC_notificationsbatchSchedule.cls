global class TC_notificationsbatchSchedule implements Schedulable{
    
global void execute(SchedulableContext SC) {
      TC_notificationsbatch notificationDelete = new TC_notificationsbatch();
    	Id job=database.executeBatch(notificationDelete);
    	
   }
}