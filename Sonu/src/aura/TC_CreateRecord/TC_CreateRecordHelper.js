({
    callApexCtlr : function(component, event, helper, funName, funParams, callbackFun) {
    	var action = component.get("c." + funName);
        action.setParams(funParams);
        action.setCallback(this, callbackFun);
        $A.enqueueAction(action);
    },
	showToast : function(type, mode, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "mode": mode,
            "title": title,
            "message": message
        });
        toastEvent.fire();
	}
})