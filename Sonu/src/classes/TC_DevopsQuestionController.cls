public class TC_DevopsQuestionController
{
    public static List<Response__c> res{get;set;}
    public static List<survey__c> survy{get;set;}
    
    public survey__c surrec{get;set;}
    
    public List<response__c> resdetails{get;set;}
    Public list<response__c> BLlist1 {get;set;}
    Public list<response__c> BLlist2 {get;set;}
    Public list<response__c> BLlist3 {get;set;}
    Public list<response__c> BLlist4 {get;set;}
    Public list<response__c> BLlist5 {get;set;}
    Public list<response__c> BLlist6 {get;set;}
    Public Integer BLlistCount {get;set;}
    Public string contextu {get;set;}
    Public Integer cultureCount {get;set;}
    Public Integer MeasurementCount {get;set;}
    Public Integer TechnicalCount {get;set;}
    Public Integer ProcessCount {get;set;}
    
       
    public TC_DevopsQuestionController(){
    
        id survid = ApexPages.currentPage().getParameters().get('surid');
        system.debug('survid @@@'+survid);
        surrec = [select id, name,Culture__c,Measurement__c,Technical__c,Process__c,Over_all_Maturity_Level__c,Lead_Name__r.name,Lead_Name__r.Email,Lead_Name__r.company,Lead_Name__r.phone,Lead_Name__r.city,Lead_Name__r.createddate   from survey__c where id =: survid];
		system.debug('surrec@@@'+surrec.Lead_Name__r.city);
        //for culture
        if(surrec.Culture__c=='Baseline')
        {
        cultureCount = 0;
        }
        else if(surrec.Culture__c=='Beginning')
        {
        cultureCount = 1;
        }
        else if(surrec.Culture__c=='Intermediate')
        {
        cultureCount = 2;
        }
        else if(surrec.Culture__c=='Mature')
        {
        cultureCount = 3;
        }
        else if(surrec.Culture__c=='Elite')
        {
        cultureCount = 4;
        }
        else
        {
        cultureCount = 5;
        }
        
		//for measurement        
        if(surrec.Measurement__c=='Baseline')
        {
        MeasurementCount = 0;
        }
        else if(surrec.Measurement__c=='Beginning')
        {
        MeasurementCount = 1;
        }
        else if(surrec.Measurement__c=='Intermediate')
        {
        MeasurementCount = 2;
        }
        else if(surrec.Measurement__c=='Mature')
        {
        MeasurementCount = 3;
        }
        else if(surrec.Measurement__c=='Elite')
        {
        MeasurementCount = 4;
        }
        else
        {
        MeasurementCount = 5;
        }
        
        //for technical
        if(surrec.Technical__c=='Baseline')
        {
        TechnicalCount = 0;
        }
        else if(surrec.Technical__c=='Beginning')
        {
        TechnicalCount = 1;
        }
        else if(surrec.Technical__c=='Intermediate')
        {
        TechnicalCount = 2;
        }
        else if(surrec.Technical__c=='Mature')
        {
        TechnicalCount = 3;
        }
        else if(surrec.Technical__c=='Elite')
        {
        TechnicalCount = 4;
        }
        else
        {
        TechnicalCount = 5;
        }
        //for process
        if(surrec.Process__c=='Baseline')
        {
        ProcessCount = 0;
        }
        else if(surrec.Process__c=='Beginning')
        {
        ProcessCount = 1;
        }
        else if(surrec.Process__c=='Intermediate')
        {
        ProcessCount = 2;
        }
        else if(surrec.Process__c=='Mature')
        {
        ProcessCount = 3;
        }
        else if(surrec.Process__c=='Elite')
        {
        ProcessCount = 4;
        }
        else
        {
        ProcessCount = 5;
        }
        
      resdetails = [select id,Name,Maturity_Level__c,ResponseQuestion__c,ResponseAnswer__c from Response__c where Survey__c =: survid]; 
        
        BLlist1 = new list<response__c>();
        BLlist2 = new list<response__c>();
         BLlist3 = new list<response__c>();
         BLlist4 = new list<response__c>();
         BLlist5 = new list<response__c>();
        BLlist6 = new list<response__c>();
        
        for(Response__c reds: resdetails){
        if(reds.Maturity_Level__c=='Baseline')
        {
        BLlist1.add(reds);
        }
        if(reds.Maturity_Level__c=='Beginning')
        {
        BLlist2.add(reds);
        }
        if(reds.Maturity_Level__c=='Contextual')
        {
        BLlist3.add(reds);
        }
        if(reds.Maturity_Level__c=='Elite')
        {
        BLlist4.add(reds);
        }
        if(reds.Maturity_Level__c=='Intermediate')
        {
        BLlist5.add(reds);
        }
        if(reds.Maturity_Level__c=='Mature')
        {
        BLlist6.add(reds);
        }
        
        }
        BLlistCount = BLlist1.size();
       // system.debug('BLlist@@'+BLlist1.size());
      }   
    
    @AuraEnabled
    public static Devops_Question__c getpicklist()
    {
        RETURN[select Name,Question__c,Answer__c from Devops_Question__c where Id = 'a3VP0000000JP1wMAG' ];
        
    }
    @AuraEnabled
    public static Wrapper getNextQuestion(String output,String responseQuestion,String responseAnswer,String responseAutoNum,String recordId){
        system.debug('hi1');
        Wrapper wrap = new Wrapper();
        string quesOut;
        string ansOut;
        string autono;
        string maturityLevel;
        string overallMaturityLevel;
        string vec1;
        string vec2;
        string questionType;
        
        TC_DevopsQuestion__mdt devquestion = [select Response__c,Maturity_Level__c,Vector1__c,Vector2__c,Question_Type__c from TC_DevopsQuestion__mdt 
                                              where Question__c =: output];
        if(devquestion != null){            
            quesOut = devquestion.Response__c;            
            maturityLevel = devquestion.Maturity_Level__c; 
            vec1 = devquestion.Vector1__c;
            vec2 = devquestion.Vector2__c;
            questionType = devquestion.Question_Type__c;
            
        }
        
        res=new List<Response__c>();
        Response__c res1 = new Response__c();        
        res1.Name = responseAutoNum;
        res1.ResponseQuestion__c = responseQuestion;
        res1.ResponseAnswer__c = responseAnswer ;
        res1.Question_Type__c = questionType;
        res1.Survey__c = recordId;
        res1.Maturity_Level__c = maturityLevel;
        res1.Vector1__c = vec1;
        res1.Vector2__c = vec2;
        res.add(res1);  
        
        insert res;
        
        
        
        
        Devops_Question__c ans = [select Name,Answer__c,Question__c,Active__c,isMultiSelect__c,isPickListField__c from Devops_Question__c  where Name =: quesOut];
        wrap.nextques = ans.Question__c;
        system.debug('ans--->'+ans);
        system.debug('ismultiselect'+ans.isMultiSelect__c);
        
        if(ans!=null){
            if(ans.Active__c == true){
                wrap.activeField = true; 
                autono = ans.Name;
                wrap.nextautonumber =autono;
            }else if(ans.isMultiSelect__c == true){
                ansOut = ans.Answer__c; 
                wrap.nextans = ansOut;
                wrap.multiSelectField = true;
                autono = ans.Name;
                wrap.nextautonumber =autono;
            }
            else if(ans.isPickListField__c == true){
                ansOut = ans.Answer__c; 
                wrap.nextans = ansOut;
                autono = ans.Name;
                wrap.nextautonumber =autono; 
                wrap.pickListField = true;
            }  
        }
        if(ans.Question__c == System.Label.TC_FinalQuestion){
            wrap.message = true;
        }
        system.debug('message'+wrap);
        return wrap;
        
    }
    
    @AuraEnabled
    public static wrapper getSubmitQuestion(String output,String responseQuestion,String responseAnswer,String responseAutoNum,String recordId){
        survey__c survy3 = [select Lead_Name__r.Email from survey__c where id =: recordId];
        string quesOut;
        string maturityLevel;
        string vec1;
        string vec2;
        string overallMaturityLevel;
        string quesType;
       
        Wrapper wrap = new Wrapper();
        TC_DevopsQuestion__mdt devquestion2 =new TC_DevopsQuestion__mdt();
        
        
        devquestion2 = [select Maturity_Level__c,Vector1__c,Vector2__c,Question_Type__c from TC_DevopsQuestion__mdt 
                        where Question__c =: output ];
        system.debug('test111'+devquestion2);
        if(devquestion2 != null){            
            
            maturityLevel = devquestion2.Maturity_Level__c;  
            vec1 = devquestion2.Vector1__c;
            vec2 = devquestion2.Vector2__c;
            quesType = devquestion2.Question_Type__c;
        }
        
        res=new List<Response__c>();
        Response__c res1 = new Response__c();        
        res1.Name = responseAutoNum;
        res1.ResponseQuestion__c = responseQuestion;
        res1.ResponseAnswer__c = responseAnswer ;
        res1.Maturity_Level__c = maturityLevel;
        res1.Survey__c = recordId;
        res1.Vector1__c = vec1;
        res1.Vector2__c = vec2;
        res1.Question_Type__c = quesType;
        
        res.add(res1);  
        
        insert res;    
        
        
        if(res[0].Name == 'Q-0053'){
            List<Response__c> response=[select id,Name,Survey__c,Survey__r.Over_all_Maturity_Level__c,ResponseQuestion__c,ResponseAnswer__c from Response__c where Name IN ('Q-0050','Q-0051','Q-0052','Q-0053') and Survey__c =: recordId];
            survey__c survy2 = [select id,Over_all_Maturity_Level__c,Lead_Name__r.Email from survey__c where id =: recordId];
            Decimal qus50ans = 0.0;
            Decimal qus51ans = 0.0;
            Decimal qus52ans = 0.0;
            Decimal qus53ans = 0.0;
            
            system.debug(survy2.Lead_Name__r.Email);
            
            for(Response__c  re:response){
                system.debug('response@@@'+re.Name);    
                //Q-0050
                if(re.Name=='Q-0050'){
                    system.debug('enter50');
                    if(re.ResponseAnswer__c=='Longer than 6 months'){
                        system.debug('enter511');
                        qus50ans = 0.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 1 - 6 months'){
                        qus50ans = 1.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 7 - 30 days'){
                        qus50ans = 2.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 1 - 7 days'){
                        qus50ans = 3.0;    
                    }
                    else{
                        qus50ans = 4.0;    
                    }
                }
                
                //Q-0051
                if(re.Name=='Q-0051'){
                    system.debug('enter51');
                    if(re.ResponseAnswer__c=='Longer than 6 months'){
                        system.debug('enter511');
                        qus51ans = 0.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 1 - 6 months'){
                        qus51ans = 1.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 7 - 30 days'){
                        qus51ans = 2.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 1 - 7 days'){
                        qus51ans = 3.0;    
                    }
                    else{
                        qus51ans = 4.0;    
                    }
                }
                //Q-0052
                if(re.Name=='Q-0052'){
                    system.debug('enter52');
                    if(re.ResponseAnswer__c=='Longer than 6 months'){
                        system.debug('enter522');
                        qus52ans = 0.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 1 - 6 months'){
                        qus52ans = 1.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 7 - 30 days'){
                    qus53ans = 2.0;    
                    }
                    else if( re.ResponseAnswer__c=='From 1 - 7 days'){
                        qus52ans = 3.0;    
                    }
                    else{
                        qus52ans = 4.0;    
                    }
                }
                //Q-0053
                if(re.Name=='Q-0053'){
                    if(re.ResponseAnswer__c=='Greater than 60%'){
                        qus53ans = 0.0;    
                    }
                    else if( re.ResponseAnswer__c=='46 - 60%'){
                        qus53ans = 1.0;    
                    }
                    else if( re.ResponseAnswer__c=='31 - 45%'){
                    qus53ans = 2.0;    
                    }
                    else if( re.ResponseAnswer__c=='16 - 30%'){
                    qus53ans = 3.0;    
                    }
                    else{
                        qus53ans = 4.0;    
                    }
                }             
                system.debug('qus50ans@@@'+qus50ans);
                system.debug('qus51ans@@@'+qus51ans);
                system.debug('qus52ans@@@'+qus52ans);
                system.debug('qus53ans@@@'+qus53ans);
                Decimal initialMaturity = (qus50ans + qus51ans + qus52ans + qus53ans)/4;
                
                
                Decimal finalMaturity = initialMaturity.round(System.roundingMode.CEILING);
                system.debug('finalMaturity@@@'+finalMaturity);
                survy2.Over_all_Maturity_Level__c = 'Level-'+string.valueOf(finalMaturity);
                overallMaturityLevel=survy2.Over_all_Maturity_Level__c;
                wrap.maturity=overallMaturityLevel;
                
            }
            
            
          
            
            update survy2;
            
        }
        
        
        //for maturity analysis
        survey__c sur = [select Technical__c,Culture__c,Process__c,Measurement__c from survey__c where id =: recordId];
        integer s4 = 0;
        integer s3 = 0;
        integer s2 = 0;
        integer s1 = 0;
        integer s5 = 0;
        integer s6 = 0;
        //for 1.Technical  
       
        List<Response__c> maturityList = [select Maturity_Level__c,Vector1__c,Vector2__c from Response__c where Survey__c =:recordId];
        List<Response__c> TmaturityList =  new  List<Response__c>();
        List<Response__c> PmaturityList =  new  List<Response__c>();
        List<Response__c> MmaturityList =  new  List<Response__c>();
        List<Response__c> CmaturityList =  new  List<Response__c>();
 
         for(Response__c r : maturityList){
             if(r.Vector1__c =='Technical' || r.Vector2__c =='Technical'){
              TmaturityList.add(r);   
             }
             if(r.Vector1__c =='Process' || r.Vector2__c =='Process'){
             PmaturityList.add(r);
             }
             if(r.Vector1__c =='Measurement' || r.Vector2__c =='Measurement'){
             MmaturityList.add(r);
             }
             if(r.Vector1__c =='Culture' || r.Vector2__c =='Culture'){
             CmaturityList.add(r);
             }
         }
        
        
        
    /*    List<Response__c> maturityList = [select Maturity_Level__c,Vector1__c,Vector2__c from Response__c where Survey__c =:recordId AND (Vector1__c='Technical' OR Vector2__c='Technical') ];*/
        system.debug('TmaturityList@@'+TmaturityList);
        for(Response__c r : TmaturityList){
            if(r.Maturity_Level__c == 'Contextual'){         
                s6++;
            }
            if(r.Maturity_Level__c == 'Elite'){         
                s5++;
            }
            if(r.Maturity_Level__c == 'Mature'){           
                s4++;
            }
            if(r.Maturity_Level__c == 'Intermediate'){                
                s3++;
            }
            if(r.Maturity_Level__c == 'Beginning'){              
                s2++;
            }
            if(r.Maturity_Level__c == 'Baseline'){              
                s1++;
            }
            
        }
        if(s6 > 0){
            sur.Technical__c = 'Contextual';   
        }else{
        if(s5 > 0){
            sur.Technical__c = 'Elite';   
        }else{
            if(s4 > 0){
                sur.Technical__c = 'Mature';
            }else{
                if(s3 > 0){
                    sur.Technical__c = 'Intermediate';
                }else{
                    if(s2 > 0){
                        sur.Technical__c = 'Beginning';
                    }else{
                        if(s1 > 0){
                            sur.Technical__c = 'Baseline';
                        }
                    }
                }
            }
        }
        }
        
        //for 2.Process
    
        system.debug('PmaturityList@@'+PmaturityList);
        s1 = 0;
        s2 = 0;
        s3 = 0;
        s4 = 0;
        s5 = 0;
        s6 = 0;
        for(Response__c r : PmaturityList){
            if(r.Maturity_Level__c == 'Contextual'){         
                s6++;
            }
            if(r.Maturity_Level__c == 'Elite'){         
                s5++;
            }
            if(r.Maturity_Level__c == 'Mature'){           
                s4++;
            }
            if(r.Maturity_Level__c == 'Intermediate'){                
                s3++;
            }
            if(r.Maturity_Level__c == 'Beginning'){              
                s2++;
            }
            if(r.Maturity_Level__c == 'Baseline'){              
                s1++;
            }
           
        }
        if(s6 > 0){
            sur.Process__c = 'Contextual';   
        }else{
        if(s5 > 0){
            sur.Process__c = 'Elite';   
        }else{
            if(s4 > 0){
                sur.Process__c = 'Mature';
            }else{
                if(s3 > 0){
                    sur.Process__c = 'Intermediate';
                }else{
                    if(s2 > 0){
                        sur.Process__c = 'Beginning';
                    }else{
                        if(s1 > 0){
                            sur.Process__c = 'Baseline';
                        }
                    }
                }
            }
        }
        }
        
        //for Measurement
    
        system.debug('MmaturityList@@'+MmaturityList);
        s1 = 0;
        s2 = 0;
        s3 = 0;
        s4 = 0;
        s5 = 0;
        s6 = 0;
        for(Response__c r : MmaturityList){
            if(r.Maturity_Level__c == 'Contextual'){         
                s6++;
            }
            if(r.Maturity_Level__c == 'Elite'){         
                s5++;
            }
            if(r.Maturity_Level__c == 'Mature'){           
                s4++;
            }
            if(r.Maturity_Level__c == 'Intermediate'){                
                s3++;
            }
            if(r.Maturity_Level__c == 'Beginning'){              
                s2++;
            }
            if(r.Maturity_Level__c == 'Baseline'){              
                s1++;
            }
                   }
        if(s6 > 0){
            sur.Measurement__c = 'Contextual';   
        }else{
        
        if(s5 > 0){
            sur.Measurement__c = 'Elite';   
        }else{
            if(s4 > 0){
                sur.Measurement__c = 'Mature';
            }else{
                if(s3 > 0){
                    sur.Measurement__c = 'Intermediate';
                }else{
                    if(s2 > 0){
                        sur.Measurement__c = 'Beginning';
                    }else{
                        if(s1 > 0){
                            sur.Measurement__c = 'Baseline';
                        }                    }
                }
            }
        }
        }
  
        
        //for culture
      //  List<Response__c> maturityList5 = [select Maturity_Level__c,Vector1__c,Vector2__c from Response__c where Survey__c =:recordId AND (Vector1__c='Culture' OR Vector2__c='Culture')];
        s1 = 0;
        s2 = 0;
        s3 = 0;
        s4 = 0;
        s5 = 0;
        s6 = 0;
        for(Response__c r : CmaturityList){
            if(r.Maturity_Level__c == 'Contextual'){         
                s6++;
            }
            if(r.Maturity_Level__c == 'Elite'){         
                s5++;
            }
            if(r.Maturity_Level__c == 'Mature'){           
                s4++;
            }
            if(r.Maturity_Level__c == 'Intermediate'){                
                s3++;
            }
            if(r.Maturity_Level__c == 'Beginning'){              
                s2++;
            }
            if(r.Maturity_Level__c == 'Baseline'){              
                s1++;
            }
            
        }
        if(s6 > 0){
            sur.Culture__c = 'Contextual';   
        }else{
        if(s5 > 0){
            sur.Culture__c = 'Elite';   
        }else{
            if(s4 > 0){
                sur.Culture__c = 'Mature';
            }else{
                if(s3 > 0){
                    sur.Culture__c = 'Intermediate';
                }else{
                    if(s2 > 0){
                        sur.Culture__c = 'Beginning';
                    }else{
                        if(s1 > 0){
                            sur.Culture__c = 'Baseline';
                        }
                    }
                }
            }
        }
        }
        
        
        //end
        update sur; 
        attachPDFInEmail(recordId, survy3.Lead_Name__r.Email);
        return wrap;   
    }
    
    public class Wrapper{
        @AuraEnabled public String nextautonumber{get;set;}
        @AuraEnabled public String nextques{get;set;}
        @AuraEnabled public String nextans{get;set;}
        @AuraEnabled public Boolean message{get;set;}
        @AuraEnabled public Boolean activeField{get;set;}
        @AuraEnabled public Boolean multiSelectField{get;set;}
        @AuraEnabled public Boolean pickListField{get;set;}
        @AuraEnabled public String maturityText{get;set;}
        @AuraEnabled public String maturity{get;set;}
        @AuraEnabled public Integer questioncount{get;set;}
        
    }
    
 //   @Future(callout=true)
private static void attachPDFInEmail(string surID, string leadEmail){
     
     //PageReference pgr = Page.TC_devopsreport;//mail_pdf is the name of vf page
   //  pgr.getParameters().put('survey__c',recordId);
     
    //pgr.getParameters().put('surid',surID);
    
    PageReference pgr = new PageReference('/apex/TC_devopsreport?surid='+surID);
        
        system.debug('pdf.getParameters().get(surid)'+pgr.getParameters().get('surid'));
     system.debug('mail id'+leadEmail);
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