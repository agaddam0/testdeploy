({
	doInit : function(component, event, helper) {
        helper.callApexCtlr(
            component, event, helper,
            'getCarouselData',
            {},
            function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    component.set("v.carouselDataList",response.getReturnValue());   
                } else {
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message) {
                            component.set("v.error",errors[0].message);          
                        }
                    }
                }
            }
        );
	}
})