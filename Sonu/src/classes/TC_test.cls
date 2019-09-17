public class TC_test {
    
    public static List<Response__c> res{get;set;}
    public static List<survey__c> survy{get;set;}
    
    public survey__c surrec{get;set;}
    public static survey__c surrec1 {get;set;}
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
    
       
    public TC_test(){
    
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

}