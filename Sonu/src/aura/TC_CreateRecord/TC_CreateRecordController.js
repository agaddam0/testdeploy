({
	doInit : function(component, event, helper) {
		let objectName = component.get("v.objectName");
        let fields = component.get("v.fields");
        let recordTypeDeveloperName = component.get("v.recordTypeDeveloperName");
        if (fields) {
            component.set("v.fieldData",fields.split(","));
        }
        if (objectName && fields) {
            if (recordTypeDeveloperName) {
                helper.callApexCtlr(
                    component, event, helper,
                    'getRecordTypeId',
                    {
                        objectName : objectName,
                        recordTypeDeveloperName : recordTypeDeveloperName
                    },
                    function (response) {
                        let state = response.getState();
                      
                        if (state === "SUCCESS") {
                            let returnData = response.getReturnValue();
                            if (returnData) {
                                component.set("v.recordTypeId",returnData);
                            }
                            component.set("v.showCmp",true);
                        } else {
                            let errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    component.set("v.error",errors[0].message);
                                }
                            }
                        }
                    }
                );
            } else {
                component.set("v.showCmp",true);
            }
        }
	},
    cancelClicked : function(component, event, helper) {
        component.set("v.showCmp",false);
        component.set("v.showCmp",true);
        component.set("v.error","");
    },
    onSubmitHandler : function(component, event, helper) {
        component.set("v.showSpinner",true);
    },
    onSuccessHandler : function(component, event, helper) {
        component.set("v.showSpinner",false);
        component.set("v.showCmp",false);
        component.set("v.showCmp",true);
        helper.showToast('Success','dismissible','Success',$A.get("$Label.c.Operation_Successful"));
    },
    onErrorHandler : function(component, event, helper) {
        component.set("v.showSpinner",false);
    }
})