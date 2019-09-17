({
    doInit : function(component, event, helper) {
     
        component.set( 'v.showFeedBack',false);
        component.set( 'v.showQuestion',true);
        component.set( 'v.Footer',true);
        var action = component.get("c.getpicklist");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();            
            
            if (state === "SUCCESS") {             
                let temp = result;               
                temp.Answer__c = temp.Answer__c.split(';');
                var values = [];
                
                for(var j=0; j<temp.Answer__c.length; j++){
                    var value = {"label":temp.Answer__c[j],"value":temp.Answer__c[j]};
                    values.push(value);
                }
                
                component.set("v.pickListText",true);
                component.set("v.nextQuestion",temp.Question__c); 
                component.set("v.nextAnswer",values);  
                component.set("v.autoValue",temp.Name);
                                
            }      
            
        });
        $A.enqueueAction(action);		
    },
    
    validation: function(component, event, helper) {
        component.set( 'v.showQuestion',true);
        component.set( 'v.showFeedBack',false);
        component.set( 'v.Footer',true);
        var input = component.get('v.inputValue');
        var ans = component.get('v.radioValue'); 
      
        var multi = component.get('v.multiValue');
        if(input!=null && input!= ''){        
            
            component.set("v.isDisabled",false);
            
        }
        else if(multi!=null&& multi!= ''){
            
            component.set("v.isDisabled",false);
            
        }
            else if(ans!=null && ans!=''){
                component.set("v.isDisabled",false);
                
            }
        
    },    
    
    nextQuestion : function(component, event, helper) {
      
        component.set( 'v.showFeedBack',false);
        component.set( 'v.showQuestion',true);
        component.set("v.showSpinner",true);
        component.set( 'v.Footer',true);
        var ques = component.find('question').get('v.value'); 
        var auto = component.find('autonumber').get('v.value'); 
        var input = component.get('v.inputValue');
        var ans = component.get('v.radioValue'); 
        var multi = component.get('v.multiValue');
        var surId = component.get('v.surveyId');	
       
        var finalAnswer = '';
        if(input!=null && input!= ''){  
            component.set("v.isDisabled",false);
            var output = auto+''+"Any";
            component.set('v.inputValue','');
            component.set( 'v.activeText',false); 
            component.set("v.isDisabled",false);
            finalAnswer = input;
        }
        else if(multi!=null&& multi!= ''){
            component.set("v.isDisabled",false);
            var output = auto+''+"Any";
            component.set('v.multiValue','');
            component.set( 'v.multiSelectText',false);
            var result = '';
            for(var i=0; i< multi.length; i++){
                result += multi[i] + ' ; ';
            }
            finalAnswer = result;
        }
            else if(ans!=null && ans!=''){
                component.set("v.isDisabled",false);
                var output = auto+''+ans;
                component.set( 'v.pickListText',false);
                finalAnswer = ans;
            }
        //alert(finalAnswer);

        component.set("v.activeText",false);
        component.set("v.pickListText",false);
        component.set("v.multiSelectText",false);
        component.set("v.radioValue","");
        var action = component.get("c.getNextQuestion");
        action.setParams({"output":output,"responseQuestion":ques,"responseAnswer":finalAnswer,"responseAutoNum":auto,"recordId":surId});
        action.setCallback(this, function(response) {
            var state = response.getState();         
            var result = response.getReturnValue();           
            
            if (state === "SUCCESS") {                   
                component.set('v.nextQuestion',result.nextques);
                component.set('v.autoValue',result.nextautonumber);
                component.set('v.submitQuestion',result.message);
                if(result.activeField == true)  {
                    component.set('v.activeText',result.activeField); 
                } else if(result.multiSelectField == true){                    
                    let temp1 = result.nextans;                    
                    temp1 = temp1.split(';');                    
                    var values = [];
                    
                    for(var j=0; j<temp1.length; j++){
                        var value = {"label":temp1[j],"value":temp1[j]};
                        values.push(value);
                    }
                    component.set('v.nextAnswer',values);             
                    component.set('v.multiSelectText',result.multiSelectField);
                    
                }
                    else if(result.pickListField == true){   
                        component.set('v.pickListText',result.pickListField);                        
                        let temp1 = result.nextans;
                        temp1 = temp1.split(';');                        
                        var values = [];                        
                        for(var j=0; j<temp1.length; j++){
                            var value = {"label":temp1[j],"value":temp1[j]};
                            values.push(value);
                        }
                        component.set('v.nextAnswer',values); 
                        
                        
                    }   }
       
            component.set("v.isDisabled",true);
            component.set("v.showSpinner",false);
            console.log("v.showSpinner@@@"+v.showSpinner);
        
        });
        $A.enqueueAction(action);   
        
    },
    
    closeFeedback : function(component, event, helper) { 
     console.log('closefeedback');
        var ques= component.get("v.nextQuestion");       
       var auto = component.get("v.autoValue");
        var input = component.get('v.inputValue');
        var ans = component.get('v.radioValue'); 
        var multi = component.get('v.multiValue');
        var surId = component.get('v.surveyId');	
       
        var finalAnswer = '';
        if(input!=null && input!= ''){  
            component.set("v.isDisabled",false);
            var output = auto+''+"Any";
            component.set('v.inputValue','');
            component.set( 'v.activeText',false); 
            component.set("v.isDisabled",false);
            finalAnswer = input;
        }
        else if(multi!=null&& multi!= ''){
            component.set("v.isDisabled",false);
            var output = auto+''+"Any";
            component.set('v.multiValue','');
            component.set( 'v.multiSelectText',false);
            var result = '';
            for(var i=0; i< multi.length; i++){
                result += multi[i] + ' ; ';
            }
            finalAnswer = result;
        }
            else if(ans!=null && ans!=''){
                component.set("v.isDisabled",false);
                var output = auto+''+ans;
                console.log('submitoutput'+output);
                component.set( 'v.pickListText',false);
                finalAnswer = ans;
            }
        console.log('auto--->'+auto);
        console.log('success111');
          var surId = component.get('v.surveyId');     
         var action = component.get("c.getSubmitQuestion");
        console.log('success111'+output);
        console.log('success111'+ques);
        console.log('success111'+ans);
        console.log('success111'+auto);
        console.log('success111'+surId);
        action.setParams({"output":output,"responseQuestion":ques,"responseAnswer":ans,"responseAutoNum":auto,"recordId":surId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();                       
            if (state === "SUCCESS") {  
                component.set('v.maturityLevel',result.maturity);
           //   alert(result.maturity);
               console.log('success345');   
                console.log('1144557'); 
            }else if(state=="ERROR"){
                console.log(response.getError()); 
                console.log(error11);
                component.set("v.showErrors",true);
                component.set("v.errorMessage",errors[0].message);
        }
        });
        $A.enqueueAction(action); 
        component.set( 'v.showFeedBack',true);
        component.set( 'v.showQuestion',false);
        component.set( 'v.submitQuestion',false);
        component.set( 'v.Footer',false);
        
    }
})