({
    callApexCtlr : function(component, event, helper, funName, funParams, callbackFun) {
    	var action = component.get("c." + funName);
        action.setParams(funParams);
        action.setCallback(this, callbackFun);
        $A.enqueueAction(action);
    },
	
})