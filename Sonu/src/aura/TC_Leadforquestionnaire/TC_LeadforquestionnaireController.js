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
    validation : function(component, event, helper) {
      
		
        
        
    var validItem = component.find('inputfield').reduce(function (validSoFar, inputCmp) {
          var testf = event.getSource().get('v.fieldName');
        console.log('testf'+testf)
        if(testf === 'Email'){
          var msg = event.getSource().get('v.value');
          console.log('msg'+msg)
          
        var action = component.get("c.validateEmail");
        action.setParams({"message":msg});
         action.setCallback(this, function(response) {
         
             var state = response.getState();
             
               var result = response.getReturnValue();
              
             console.log('resultvalid----'+result[1]);
             if (state === "SUCCESS") { 
                 if(result != null && result != ''){
                     
                     //survey
         var action = component.get("c.createSurvey");
        action.setParams({"leadId":result[1]});
         action.setCallback(this, function(response) {
         console.log('hi')
             var state = response.getState();
             
               var result = response.getReturnValue();
             
             if (state === "SUCCESS") { 
                 //alert('sucrss');
                   component.set('v.surveyId',result);
                             }
             
             
         });
        $A.enqueueAction(action);
         //surveyend
                     
                   
                     
                     component.set('v.validate',false);
                     component.set('v.displayMessage',true); 
                 
                     component.set("v.navigate",false);
                 }
             }
             
             
         });
         $A.enqueueAction(action);
         // component.set('v.emailValue',msg);
        }
            return validSoFar && inputCmp.get('v.value'); 
       
        }, true);
                            console.log('validItem'+validItem);
                             if(validItem){
            
            component.set("v.isDisabled",false);
        }
        
        var val = event.getSource().get('v.fieldName');
         var letterNumber = /^(?![0-9]*$)[a-zA-Z0-9]+$/;
        if(val === 'PostalCode'){
        var msg11 = event.getSource().get('v.value');
        var inputCmp = component.find("inputfield");
        console.log('msg111'+msg11) 
        
            if(msg11 == null || msg11 == ''){
            component.set("v.isDisabled",true);   
            }
            else if(msg11.match(letterNumber)){
				console.log("hhhh");
                component.set("v.setVal",true);
                component.set("v.isDisabled",true);
            }
            else{
             component.set("v.setVal",false);
             component.get("v.isDisabled",false);
            }
        }
        
        
         
     },
    cancelClicked : function(component, event, helper) {
        component.set("v.showCmp",false);
        component.set("v.showCmp",true);
        component.set("v.error","");
    },
    onSubmitHandler : function(component, event, helper) {
         component.set("v.navigate",true);
          component.set("v.showSpinner",true);
   
    },
    onSuccessHandler : function(component, event, helper) {
       var params = event.getParams(); //get event params
        var recordId = params.response.id; //get record id
        component.set('v.recValue',recordId);
     
              var action = component.get("c.createSurvey");
        action.setParams({"leadId":recordId});
         action.setCallback(this, function(response) {
         
             var state = response.getState();
             
               var result = response.getReturnValue();
             console.log('surveyId'+result);
             if (state === "SUCCESS") { 
                 component.set('v.surveyId',result);
                 
             }else{
                 
             }
             
             
         });
        $A.enqueueAction(action);
        //surveyend
        component.set("v.showSpinner",false);
        component.set("v.showCmp",false);
        component.set("v.showCmp",true);
    
    },
    onErrorHandler : function(component, event, helper) {
         component.set("v.showSpinner",false);
         //component.set("v.isModalOpen", false);
        
    },
     openModel: function(component, event, helper) {
         
         
      component.set("v.isModalOpen", true);
   },
    closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);

   },
    goProceed : function(component, event, helper) {
         component.set("v.navigate",true);
        component.set("v.displayMessage",false);
     //   component.set("v.navigate",true);
    }

})