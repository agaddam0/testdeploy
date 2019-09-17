({
	handleApplicationEvent : function(component, event, helper) {
         
         var nextQuestion1 = event.getParam("nextautonumber");
        console.log('nextQuestion1------->'+nextQuestion1)
        
        
         var nextAnswer1 = event.getParam("nextAnswer");
        var output = nextQuestion1+ '' +nextAnswer1;
        console.log('output'+output)
         
         var action = component.get("c.getNextQuestion");
       action.setParams({"output":output});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state---->'+state);
            var result = response.getReturnValue();
            
            console.log(result);
            if (state === "SUCCESS")
       
        
      component.set('v.Enabled',true);
            component.set('v.nextQuestion2',result[0].nextques);
                
                let temp1 = result[1].nextans;
                console.log('The tempis'+temp1);
                temp1 = temp1.split(';');
                component.set('v.nextAnswer2',temp1);

               
         
        
	});
          $A.enqueueAction(action);
    }
})