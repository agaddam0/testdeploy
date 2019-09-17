@IsTest
public class TC_FinancialDetailsTestClass{
    
   @IsTest
 static void testgetFAs(){ 
     Map<String,String> mapFAToType = new Map<String,String>();

    Map<String,List<String>> mapFAToFieldName = new Map<String,List<String>>();
     Id accountRecordType= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     Account acc=new Account();
     acc.FirstName='Test';
     acc.LastName='test1';
     acc.RecordTypeId=accountRecordType;
     insert acc;
     
     Account ac=[select id from Account  where lastName='test1' limit 1];
     
     
     	FinServ__FinancialAccount__c autoloan=new FinServ__FinancialAccount__c();
     	system.debug('hello');
     	Id autoloanRecordType= Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('Auto Loan').getRecordTypeId();
     	system.debug(autoloanRecordType);
     	autoloan.Name='Four Wheeler Loan';
     	autoloan.FinServ__Ownership__c='Individual';
     	autoloan.FinServ__Balance__c=10000;
       	autoloan.FinServ__PaymentDueDate__c=system.today()+25;
        autoloan.FinServ__PrincipalBalance__c=100000;
     	autoloan.RecordTypeId=autoloanRecordType;
     	autoloan.FinServ__PrimaryOwner__c=ac.id;
    	insert autoloan;
     
     	

		FinServ__FinancialAccount__c creditCard=new FinServ__FinancialAccount__c();
     	Id creditCardRecordType= Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();
        creditcard.Name='HDFC Platinum Card';
     	creditcard.FinServ__Ownership__c='Individual';
     	creditCard.FinServ__Balance__c=50000;
    	creditCard.FinServ__MinimumPayment__c=5000;
       	creditCard.FinServ__PaymentDueDate__c=system.today()+25;
        creditCard.FinServ__AvailableCredit__c=100000;
     	creditCard.FinServ__TotalCreditLimit__c=150000;
     	creditCard.RecordTypeId=creditCardRecordType; 
     	creditCard.FinServ__PrimaryOwner__c=ac.id;
     	insert creditCard;
     
     	FinServ__FinancialAccount__c general=new FinServ__FinancialAccount__c();
     	Id generalRecordType= Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('General Account').getRecordTypeId();
     	general.Name='Long Term Savings';
         general.FinServ__Ownership__c='Individual';
     	general.FinServ__CashBalance__c=20000;
     	general.RecordTypeId=generalRecordType;
      	general.FinServ__PrimaryOwner__c=ac.id;
     	insert general;
     
     	
     
     	FinServ__FinancialAccount__c savingsAccount=new FinServ__FinancialAccount__c();
     	Id savingsAccountRecordType= Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('Savings Account').getRecordTypeId();
     	savingsAccount.Name='Fixed Deposit';
     	savingsAccount.FinServ__Ownership__c='Individual';
     	savingsAccount.FinServ__Balance__c=50000;
        savingsAccount.FinServ__MinimumBalance__c=5000;
        savingsAccount.FinServ__AverageBalance__c=25000;
     	savingsAccount.RecordTypeId=savingsAccountRecordType;
     	 savingsAccount.FinServ__PrimaryOwner__c=ac.id;
     	insert savingsAccount;
     
     	
 
    for( TC_Financial_Account_Details__mdt fad : [ SELECT DeveloperName, TC_Field_Containing_Balance__c, TC_IsNegativeInstrument__c FROM TC_Financial_Account_Details__mdt ]) {

        if( fad.TC_IsNegativeInstrument__c ) {
            mapFAToType.put(fad.DeveloperName, 'Negative');
        }

        else {
           mapFAToType.put(fad.DeveloperName, 'Positive'); 
        }
        
        if( !mapFAToFieldName.containsKey(fad.DeveloperName)) {
            mapFAToFieldName.put(fad.DeveloperName, new List<String>());
        }
        
        mapFAToFieldName.get(fad.DeveloperName).addAll(fad.TC_Field_Containing_Balance__c.split(','));
        

    }
     
     	Test.startTest();
           
     		
     		TC_FinancialDetails.getFAs(ac.id);
     		
     		
        Test.stopTest();
     
 }

}