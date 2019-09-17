/*
 * Trigger Written By: Saira
 * Date: 02/28/2019
 * Description: Test class for ProjectPhaseTriggerHelper Class
 * Revision Date: 
 * Revised By: 
 */

@isTest
public class ProjectPhaseTriggerHelperTest {
    
    public static testmethod void testProjectPhase(){
        
        Projects__c proj = new Projects__c();
        proj.Name = 'Intelligrated Demo';
        proj.Project_Start_Date__c = Date.today();
        insert proj;
        
        Test.startTest();
        Project_Phase__c projPhase = new Project_Phase__c();
        projPhase.Project_Name__c = proj.id;
        projPhase.Project_Phase__c = 'Phase 1';
        insert projPhase;
        
        
        Project_Phase__c projPhase1 = new Project_Phase__c();
        projPhase1.Project_Name__c = proj.id;
        projPhase1.Project_Phase__c = 'Phase 2';
        insert projPhase1;
        
        Project_Phase__c projPhase2 = new Project_Phase__c();
        projPhase2.Project_Name__c = proj.id;
        projPhase2.Project_Phase__c = 'Phase 3';
        insert projPhase2;
        
        Project_Phase__c projPhase3 = new Project_Phase__c();
        projPhase3.Project_Name__c = proj.id;
        projPhase3.Project_Phase__c = 'Phase 4';
        insert projPhase3;
        
        Project_Phase__c projPhase4 = new Project_Phase__c();
        projPhase4.Project_Name__c = proj.id;
        projPhase4.Project_Phase__c = 'Phase 5';
        insert projPhase4;
        
        Project_Phase__c projPhase5 = new Project_Phase__c();
        projPhase5.Project_Name__c = proj.id;
        projPhase5.Project_Phase__c = 'Phase 6';
        insert projPhase5;
        
        Project_Phase__c projPhase6 = new Project_Phase__c();
        projPhase6.Project_Name__c = proj.id;
        projPhase6.Project_Phase__c = 'Phase 7';
        insert projPhase6;
        
        Project_Phase__c projPhase7 = new Project_Phase__c();
        projPhase7.Project_Name__c = proj.id;
        projPhase7.Project_Phase__c = 'Phase 8';
        insert projPhase7;
        
        Project_Phase__c projPhase8 = new Project_Phase__c();
        projPhase8.Project_Name__c = proj.id;
        projPhase8.Project_Phase__c = 'Phase 9';
        insert projPhase8;
        
        Project_Phase__c projPhase9 = new Project_Phase__c();
        projPhase9.Project_Name__c = proj.id;
        projPhase9.Project_Phase__c = 'Phase 10';
        insert projPhase9;
        
        Project_Phase__c projPhase10 = new Project_Phase__c();
        projPhase10.Project_Name__c = proj.id;
        projPhase10.Project_Phase__c = 'Phase 11';
        insert projPhase10;
        
        Project_Phase__c projPhase11 = new Project_Phase__c();
        projPhase11.Project_Name__c = proj.id;
        projPhase11.Project_Phase__c = 'Phase 12';
        insert projPhase11;
        
        Test.stopTest();
    }
}