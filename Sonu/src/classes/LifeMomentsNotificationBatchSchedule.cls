/*
*@Description:LifeMomentsNotificationBatchSchedule Scheduler Class (W-000091: Capture important life moments)
*@Referrence: LifeMomentsNotificationBatch
*@Author: Nithi Natarajan
*@Date: 08/17/2018
*/
global class LifeMomentsNotificationBatchSchedule implements schedulable {
    global void execute(SchedulableContext sc){
           LifeMomentsNotificationBatch emailntfy = new LifeMomentsNotificationBatch();
        database.executebatch(emailntfy, 200);
    }  
}