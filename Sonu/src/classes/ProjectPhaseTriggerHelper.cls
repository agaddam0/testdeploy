/*
 * Trigger Written By: Saira
 * Date: 02/25/2019
 * Description: Helper class for the trigger to update the Project Phase Start Date based on the project phase End Date
 * Revision Date: 
 * Revised By: 
 */
public class ProjectPhaseTriggerHelper {
    public static Set<Project_Phase__c> projPhaseSet = new Set<Project_Phase__c>();
    public static List<Project_Phase__c> projPhaseList = new List<Project_Phase__c>();
    public static Map<Id,Map<String,Project_Phase__c>> phaseProjMap = new Map<Id,Map<String,Project_Phase__c>>();
    public static List<Projects__c> projectList = new List<Projects__c>();
    public static Boolean isExecuted = false;
    
    public static void updateStartDate(List<Project_Phase__c> projList,Map<id,Project_Phase__c> oldProjMap){
        try{
        List<Id> projIdList = new List<Id>();
        for(Project_Phase__c proj: projList){
            projIdList.add(proj.Project_Name__c);
        }
        
        
        projectList = [select id,Project_Start_Date__c,(select id,Project_Name__c,Phase_Start_Date__c,Phase_End_Date__c,Project_Phase__c  from Project_Phases__r) from Projects__c where id in : projIdList];
        for(Projects__c project: projectList){
            for(Project_Phase__c projPhase:project.Project_Phases__r){
                if(!phaseProjMap.containsKey(project.Id)){
                   phaseProjMap.put(project.id,new Map<String,Project_Phase__c>());
                    phaseProjMap.get(project.id).put(projPhase.Project_Phase__c,projPhase);
                }
                   else{
                       phaseProjMap.get(project.id).put(projPhase.Project_Phase__c,projPhase);
                   }
            }
            }
        
        for(Projects__c project: projectList){
            for(Project_Phase__c pPhase:project.Project_Phases__r){
                Project_Phase__c projPhase = new Project_Phase__c(id = pPhase.id,Project_Phase__c= pPhase.Project_Phase__c);
                if(projPhase.Project_Phase__c == 'Phase 1'){projPhase.Phase_Start_Date__c = project.Project_Start_Date__c;
                }
                if(projPhase.Project_Phase__c == 'Phase 2' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 2' && phaseProjMap.get(project.Id).get('Phase 1').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 1') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 1').Phase_End_Date__c + 1;
                }
                 if(projPhase.Project_Phase__c == 'Phase 3' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 3' && phaseProjMap.get(project.Id).get('Phase 2').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 2') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 2').Phase_End_Date__c+ 1;
                }
                 else if(projPhase.Project_Phase__c == 'Phase 4' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 4' && phaseProjMap.get(project.Id).get('Phase 3').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 3') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 3').Phase_End_Date__c+ 1;
                }
                 else if(projPhase.Project_Phase__c == 'Phase 5' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 5' && phaseProjMap.get(project.Id).get('Phase 4').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 4') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 4').Phase_End_Date__c+ 1;
				}
				 else if(projPhase.Project_Phase__c == 'Phase 6' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 6' && phaseProjMap.get(project.Id).get('Phase 5').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 5') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 5').Phase_End_Date__c+ 1;
                }
 				 else if(projPhase.Project_Phase__c == 'Phase 7' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 7' && phaseProjMap.get(project.Id).get('Phase 6').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 6') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 6').Phase_End_Date__c+ 1;
                }
 				 else if(projPhase.Project_Phase__c == 'Phase 8' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 8' && phaseProjMap.get(project.Id).get('Phase 7').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 7') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 7').Phase_End_Date__c+ 1;
                }
 				 else if(projPhase.Project_Phase__c == 'Phase 9' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 9' && phaseProjMap.get(project.Id).get('Phase 8').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 8') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 8').Phase_End_Date__c+ 1;
                }
 				 else if(projPhase.Project_Phase__c == 'Phase 10' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 10' && phaseProjMap.get(project.Id).get('Phase 9').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 9') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 9').Phase_End_Date__c+ 1;
                }
 				 else if(projPhase.Project_Phase__c == 'Phase 11' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 11' && phaseProjMap.get(project.Id).get('Phase 10').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 10') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 10').Phase_End_Date__c+ 1;
				}
                 else{
                    if(projPhase.Project_Phase__c == 'Phase 12' && oldProjMap.get(projPhase.Id) != null && oldProjMap.get(projPhase.Id).Project_Phase__c != 'Phase 12' && phaseProjMap.get(project.Id).get('Phase 11').Phase_End_Date__c != null && phaseProjMap.get(project.Id).get('Phase 11') != null){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 11').Phase_End_Date__c+ 1;
                }
                }
                if(!projPhaseSet.contains(projPhase))
                projPhaseSet.add(projPhase);
            }
        }
        projPhaseList.addAll(projPhaseSet);
        if(!isExecuted){
            isExecuted = true;
             List<Database.SaveResult> res = Database.update(projPhaseList,false);
        }
    }
    catch(Exception e){
    }
    }
    
    public static void updateStartDateAfterInsert(List<Project_Phase__c> projList){
        try{
        List<Id> projIdList = new List<Id>();
        Set<Id> proPhaseSet = new Set<Id>();
        for(Project_Phase__c proj: projList){
            projIdList.add(proj.Project_Name__c);
            proPhaseSet.add(proj.id);
        }
        
        
        projectList = [select id,Project_Start_Date__c,(select id,Project_Name__c,Phase_Start_Date__c,Phase_End_Date__c,Project_Phase__c  from Project_Phases__r) from Projects__c where id in : projIdList];
        for(Projects__c project: projectList){
            for(Project_Phase__c projPhase:project.Project_Phases__r){
                if(!phaseProjMap.containsKey(project.Id)){
                   phaseProjMap.put(project.id,new Map<String,Project_Phase__c>());
                    phaseProjMap.get(project.id).put(projPhase.Project_Phase__c,projPhase);
                }
                   else{
                       phaseProjMap.get(project.id).put(projPhase.Project_Phase__c,projPhase);
                   }
                   
            }
            
        }
        
        for(Projects__c project: projectList){
            for(Project_Phase__c pPhase:project.Project_Phases__r){
                Project_Phase__c projPhase = new Project_Phase__c(id = pPhase.id,Project_Phase__c= pPhase.Project_Phase__c);
                if(projPhase.Project_Phase__c == 'Phase 1' && proPhaseSet.contains(projPhase.Id)){
                    
                    projPhase.Phase_Start_Date__c = project.Project_Start_Date__c;
                }
                if(projPhase.Project_Phase__c == 'Phase 2' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 1').Phase_End_Date__c + 1;
                }
                 if(projPhase.Project_Phase__c == 'Phase 3' && proPhaseSet.contains(projPhase.Id)){
                     
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 2').Phase_End_Date__c+ 1;
                }
                 else if(projPhase.Project_Phase__c == 'Phase 4' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 3').Phase_End_Date__c+ 1;
                }
                else if(projPhase.Project_Phase__c == 'Phase 5' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 4').Phase_End_Date__c+ 1;
				}
				else if(projPhase.Project_Phase__c == 'Phase 6' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 5').Phase_End_Date__c+ 1;
				}
				else if(projPhase.Project_Phase__c == 'Phase 7' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 6').Phase_End_Date__c+ 1;
				}
				else if(projPhase.Project_Phase__c == 'Phase 8' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 7').Phase_End_Date__c+ 1;
				}
				else if(projPhase.Project_Phase__c == 'Phase 9' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 8').Phase_End_Date__c+ 1;
				}
				else if(projPhase.Project_Phase__c == 'Phase 10' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 9').Phase_End_Date__c+ 1;
				}
				else if(projPhase.Project_Phase__c == 'Phase 11' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 10').Phase_End_Date__c+ 1;
				}
                else{
                    if(projPhase.Project_Phase__c == 'Phase 12' && proPhaseSet.contains(projPhase.Id)){
                    projPhase.Phase_Start_Date__c = phaseProjMap.get(project.Id).get('Phase 11').Phase_End_Date__c+ 1;
                }
                }
                if(!projPhaseSet.contains(projPhase))
                projPhaseSet.add(projPhase);
                
            }
        }
        projPhaseList.addAll(projPhaseSet);
        if(!isExecuted){
            isExecuted = true;
             List<Database.SaveResult> res = Database.update(projPhaseList,false);
        }
        
    }
    catch(Exception e){
    }
    }
}