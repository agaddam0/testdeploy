({
	doInit : function(component, event, helper) {
         var field = component.get('v.fieldNames');
          console.log(field.split(';'));
         console.log('---field--',field);
        if(field){
            component.set("v.fieldData",field.split(','));
        }
		var action = component.get('c.getCases');
      action.setParams({"field":field});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state---->'+state);
           var result = response.getReturnValue();
            
             console.log('result---->'+result);
            if (state === "SUCCESS") {
                component.set("v.message",result.message);
                 component.set("v.displayTable",true);
                 
               component.set("v.openCase",result.openCases);
               component.set("v.closedCase",result.closedCases);
            }
           
        });
        $A.enqueueAction(action);
	}
})