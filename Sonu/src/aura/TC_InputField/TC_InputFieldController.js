({
	valueChanged : function(component, event, helper) {       
       console.log(event.getSource().get("v.value"))     
            let inputfield = component.find("inputfield").get("v.value");          
            if(inputfield) {
                console.log('sriram');
                  component.find("inputfield").set("v.class","");
                component.set("v.showRequiredMessage",false);                                            
            } else {
                console.log('Ameen');
              component.find("inputfield").set("v.class","requiredClass");
                component.set("v.showRequiredMessage",true);
           
            }
       
        }
	
})