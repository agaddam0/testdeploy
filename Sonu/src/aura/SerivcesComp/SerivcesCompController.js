({
toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute

          var items = component.get("v.Acc");
   
            
        var index =event.currentTarget.dataset.rowIndex

            items[index].expanded = !items[index].expanded;
        component.set("v.items", items)
       
        component.set("v.Acc", items);
    },
    doInit : function(component, event, helper) {
         var action = component.get("c.getacc");
         action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                var x=response.getReturnValue();
              for(var i=0;i<x.length;i++)
              {
                  console.log(x[i].Name);
                  x[i].expanded=false;
              }
        
                component.set("v.Acc",x)
             var x=component.get("v.Acc");
                console.log(x[0].expanded);
                console.log("bye")
            }
             

            else if (state === "INCOMPLETE") {

                // do something
      }

            else if (state === "ERROR") {
                var errors = response.getError();

                if (errors) {

                    if (errors[0] && errors[0].message) {

                        console.log("Error message: " +

                                 errors[0].message);

                    }
            } else {

                    console.log("Unknown error");

                }

            }

        });

 $A.enqueueAction(action);
    },
    onCheck : function(component, event, helper) {
        
    }
})