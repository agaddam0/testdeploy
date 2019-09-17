@isTest
private class CSForce_testingutil {

    static testmethod void testConstructor(){
        Test.startTest();
        CSForce_SearchController sc = new CSForce_SearchController();
        
        // test static describe methods
        sc.getSalesPolicies();
        sc.getSharingPolicies();
        sc.getStoryType();
        Test.stopTest();
        System.assert(sc.productsSelect != null);
        System.assert(sc.competitorsSelect != null);
      }
    
    static testmethod void testSearch(){
    Test.startTest();
    CSForce_SearchController sc = new CSForce_SearchController();
    sc.productSelected = 'All';
    sc.competitorSelected = 'All';
    sc.doSearch();
    Test.stopTest();
    System.assert(sc.csHelperList.size()>0);
    sc.tSearch = 'blah';
    sc.doSearch();  
    System.assert(sc.csHelperList!=null);
    
    sc.productSelected = 'test';
    sc.competitorSelected = 'test';
    sc.csSearch.Products__c = 'test';
    sc.csSearch.Win_Against__c = 'Ralph Wiggum';
    sc.csSearch.Story_Type__c = 'test';
    sc.csSearch.Name = 'test';
    sc.csSearch.Sales_Reference__c = 'blah';
    sc.csSearch.Sharing_Restriction__c = 'blah';    
    sc.tSearch = 'blah';
    sc.doSearch();
    sc.tSearch = '';
    sc.doSearch();
  } 
    
    static testmethod void testSearch_shortSynopsis(){
    CustomerStory__c cs1 = [SELECT Synopsis__c FROM CustomerStory__c LIMIT 1];
    cs1.Synopsis__c = 'We won';
    update cs1;
    Test.startTest();
    CSForce_SearchController sc = new CSForce_SearchController();
    sc.productSelected = 'All';
    sc.competitorSelected = 'All';
    sc.doSearch();
    Test.stopTest();
    System.assert(sc.csHelperList.size()>0);
    sc.tSearch = 'blah';
    sc.doSearch();  
    System.assert(sc.csHelperList!=null);
    
    sc.productSelected = 'test';
    sc.competitorSelected = 'test';
    sc.csSearch.Products__c = 'test';
    sc.csSearch.Win_Against__c = 'Ralph Wiggum';
    sc.csSearch.Story_Type__c = 'test';
    sc.csSearch.Name = 'test';
    sc.csSearch.Sales_Reference__c = 'blah';
    sc.csSearch.Sharing_Restriction__c = 'blah';    
    sc.tSearch = 'blah';
    sc.doSearch();
    sc.tSearch = '';
    sc.doSearch();
  } 
    
    
  @testSetup static void setup(){
  	Account ac = new Account();
  	ac.Name = 'test account';
  	insert ac;
  	
  	CustomerStory__c cs = new CustomerStory__c();
  	cs.Name = 'test';
  	cs.Account__c = ac.id;
  	cs.Business_Focus__c = 'testing';
  	cs.Lessons_Learned__c = 'blah';
  	cs.Products__c = 'test';
  	cs.Sharing_Restriction__c='no';
  	cs.Solutions__c = 'blah';
  	cs.Story_Type__c = 'winner';
  	cs.Synopsis__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce tincidunt, lectus at suscipit nullam.';
  	cs.Team__c ='Lary, Moe, and Curly';
  	cs.Win_Against__c = 'Ralph Wiggum';
  	cs.Status__c = 'Available';
  	insert cs;
  }

}