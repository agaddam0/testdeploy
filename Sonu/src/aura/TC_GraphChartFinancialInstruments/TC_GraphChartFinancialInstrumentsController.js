({	
	ctr : function(cmp, event, helper) {
        var temp = [];
        var recordId = cmp.get("v.recordId");
        var action = cmp.get("c.getChartMap");
            action.setParams({
                "accountId": "001P000001Nd1HLIAZ"
                });
        action.setCallback(this, function(response){
            
            //alert(response.getReturnValue());
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp = response.getReturnValue();
                helper.createGraph(cmp, temp);
            }
        });      
       $A.enqueueAction(action);	
	}
})