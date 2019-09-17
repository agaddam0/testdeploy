public class CMSCasesController {
    
     private ApexPages.StandardSetController standardController;
     
    public CMSCasesController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        
    }
    public String getIDS() {
        List<String> accid=new List<String>();
        String custom;
        List<Case> selectedCases = (List<Case>) standardController.getSelected();
         for(Case selectedCase : selectedCases)
        {
          accid.add(selectedCase.Id);
        } 
    custom= JSON.serialize(accid);
        return custom;
    }


}