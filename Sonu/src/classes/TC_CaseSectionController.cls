public class TC_CaseSectionController {
 @AuraEnabled
    public static wrapperClass getCases(List<string> field){
       String caseList;
         String msg = 'No Cases Are Available';
        wrapperClass wrap  = new wrapperClass();
        List<case> ocases=new list<case>();
        list<case> ccases=new list<case>();
        String allstring = String.join(field,',');   
        caseList = 'SELECT id,' +  allstring  + ',isClosed from Case where CreatedById = \'' + UserInfo.getUserId() + '\'';
       
        system.debug('caseList'+caseList);
        List<case> cases = Database.query(caseList);
        if(cases.size()==0){
          wrap.message = msg;
        }
        else{
        for(Case c : cases){
            system.debug('isclosed'+ c.IsClosed);
            if(c.IsClosed!=true){
                Case opencase=new case();
               opencase=c;
                ocases.add(opencase);
               
                wrap.openCases = ocases;
            }else if(c.IsClosed==true){
                Case closedcase=new case();
                closedcase=c;
                ccases.add(closedcase);
               
                wrap.closedCases = ccases;
               
            }
        }
        }
        system.debug('opencases'+ wrap.opencases);
        system.debug('closed'+ wrap.closedcases);
        return wrap;
    }
   
    public class wrapperClass{
        @AuraEnabled public list<case> openCases{get;set;}
        @AuraEnabled public List<case> closedCases{get;set;}
         @AuraEnabled public String message{get;set;}
    }
}