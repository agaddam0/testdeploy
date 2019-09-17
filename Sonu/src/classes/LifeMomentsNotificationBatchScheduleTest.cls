@istest
class LifeMomentsNotificationBatchScheduleTest {
public static testmethod void testschedule(){
		Test.StartTest();
		LifeMomentsNotificationBatchSchedule ntfy = new LifeMomentsNotificationBatchSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('test Email Notification', sch, ntfy);
		Test.stopTest();
	}
}