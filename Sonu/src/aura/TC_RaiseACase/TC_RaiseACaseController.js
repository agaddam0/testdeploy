({
    
	handleQueries: function(component, event, helper) {
        
        var flag=component.get("v.flag");
        
        if(flag){
        component.set("v.flag",false);
        }else{
            component.set("v.flag",true);
        }
        
        component.set("v.flag",true);
   
 } 
})