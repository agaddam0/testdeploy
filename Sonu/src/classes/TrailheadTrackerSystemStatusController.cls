public without sharing class TrailheadTrackerSystemStatusController {

    public List<AsyncApexJob> batchJobsList{get;set;}
    
    public TrailheadTrackerSystemStatusController()
    {   
        //batchJobsList = new List<AsyncApexJob>();
        batchJobsList = [SELECT CreatedDate, Status, ExtendedStatus, TotalJobItems, NumberOfErrors FROM AsyncApexJob where ApexClass.Name = 'BatchToUpdateTrailheadStats' ORDER BY CreatedDate DESC limit 800];
    	
    }
}