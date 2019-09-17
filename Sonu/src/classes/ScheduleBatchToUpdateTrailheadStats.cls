/*
* Trailhead Tracker Application
* Shashwat Nandan
* 28/1/2019
*/
global without sharing class ScheduleBatchToUpdateTrailheadStats implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchToUpdateTrailheadStats batchToUpdateTrailheadStats= new BatchToUpdateTrailheadStats(); 
        database.executebatch(batchToUpdateTrailheadStats, 1);
    }
}