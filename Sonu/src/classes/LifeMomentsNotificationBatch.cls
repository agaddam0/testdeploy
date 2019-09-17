/*
*@Description:LifeMomentsNotificationBatch - Sending the Email notification of Birthday and Work Anniversary to all the resources. (W-000091: Capture important life moments)
*@Author: Nithi Natarajan
*@Date: 08/17/2018
*/
global class LifeMomentsNotificationBatch Implements Database.Batchable <sObject> {
    global Database.queryLocator start(Database.BatchableContext bc) {
        Date tody = system.today();
        String SOQL = 'SELECT Id, Name,FirstName,LastName, Email,Birthdate,Joining_Date__c FROM Contact WHERE ( Birthdate != null AND DAY_IN_MONTH(Birthdate) = ' + tody.day() +  ' AND CALENDAR_MONTH(Birthdate) = ' + tody.month() +') OR (Joining_Date__c != null AND DAY_IN_MONTH(Joining_Date__c) = ' + tody.day() +  ' AND CALENDAR_MONTH(Joining_Date__c) = ' + tody.month() +')';
        system.debug('----qry'+SOQL);
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> listEmployee) {
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<OrgWideEmailAddress> listowa = [select id, Address, DisplayName from OrgWideEmailAddress where Address = 'amhegde@teksystems.com'];
        if((listowa !=null && listowa.size()>0))
        {
            OrgWideEmailAddress owa = listowa.get(0);
            for(Contact m : listEmployee) {
                Date tody = system.today();
                List<String> toAddresses = new List<String>{m.Email};           
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                
                String messageSubject = '';
                String messageBody = '';
                //system.debug(m.Birthdate.day()+'----1---'+tody.day());
                //system.debug(m.Birthdate.month()+'----2---'+tody.month());
                if(m.Birthdate != null){
                    if(m.Birthdate.day() == tody.day() && m.Birthdate.month() == tody.month()){
                        messageSubject = 'Happy Birthday '+m.FirstName;
                        messageBody = '<html><body>Hi ' + m.FirstName + ',<br/><br/>On behalf of all at TEKsystems Global Services, we wish you a very Happy Birthday!  We are glad to have you as part of the team.';
                        messageBody= messageBody + '<br/><br/>Have a wonderful day.<br/><br/>Best Wishes,<br><br/>TGS - Salesforce Practice Team</body></html>';
                    }
                }
                
                if(m.Joining_Date__c != null){
                    if(m.Joining_Date__c.day() == tody.day() && m.Joining_Date__c.month() == tody.month()){
                        messageSubject = 'Happy Work Anniversary '+m.FirstName;
                        messageBody = '<html><body>Hi ' + m.FirstName + ',<br/><br/>Congratulations on your  work anniversary! We are so happy that you are a part of our team. Here is wishing you more success in the years ahead.';
                        messageBody= messageBody + '<br/><br/>Have a great day.<br/><br/>Regards,<br><br/>TGS - Salesforce Practice Team</body></html>';
                    }
                }
                mail.setSubject(messageSubject);
                mail.setOrgWideEmailAddressId(owa.id);
                
                mail.setHtmlBody(messageBody); 
                mailList.add(mail);          
            } 
            Messaging.sendEmail(mailList); 
        }
    }
    
    global void finish(Database.BatchableContext bc) {
    }
}