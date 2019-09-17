Public class TC_SurveyTrigger_Utility {
   
  @future(callout = true)
private static void attachPDFInEmail(string surID){
     Survey__c sur = [select id,Is_Survey_Completed__c from Survey__c where id =:surID limit 1];
       if(sur.Is_Survey_Completed__c == true){
             
     PageReference pgr = Page.TC_devopsreport;//mail_pdf is the name of vf page
   //  pgr.getParameters().put('survey__c',recordId);
     
    pgr.getParameters().put('surid',sur.id);
    //PageReference pgr = new PageReference('/apex/TC_devopsreport?surid=a3PP00000001BHYMA2');
        
        system.debug('pdf.getParameters().get(surid)'+pgr.getParameters().get('surid'));
        //system.debug('pdf.getParameters().get(id)'+pgr.getParameters().get('id'));
     // goToNextPage('email');
     Blob body;                
     try{
        system.debug('pdf.getContent()@@'+pgr.getContent());
        body = pgr.getContent();
      
     }catch(VisualforceException e){
         system.debug('e@@@@'+e.getMessage()+'%%%%%%%%%%%%%'+e.getStackTraceString());
            body=Blob.valueOf('Some text');
         body=Blob.valueOf('Some text');
         body=Blob.valueOf('Some text');
         system.debug('111111111');
     }            
      Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
      attach.setContentType('application/pdf');
      attach.setFileName('SurveyDetails.pdf');
      attach.setInline(false);
      attach.Body = body;
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setUseSignature(false);
      mail.setToAddresses(new String[] { 'amshaik@teksystems.com' });
      mail.setSubject('PDF Email Demo');
      mail.setHtmlBody('Here is the email you requested! Check the attachment!');
      mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
      // Send the email    
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
   
   }
}