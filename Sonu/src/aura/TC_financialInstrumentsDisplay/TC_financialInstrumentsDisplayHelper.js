({
	getDetails : function(component,event,helper) {
       var positiveAccountDetails=[];
        var negativeAccountDetails=[];
        
		var act=component.get("c.getFAs");
     act.setParams({'accountId':'001P000001Nd1HLIAZ'});
        
        act.setCallback(this,function(res){
            var state=res.getState();
          	var mapForRecordIdandRecordType = new Map();
            if(state==='SUCCESS'){
                var result=res.getReturnValue();
                if(result!=null && result!=''){
                    
                    for(var i=0;i<result.length;i++){
                        
                        if(result[i].isPositive){
                            positiveAccountDetails.push(result[i].requiredFA);
                            component.set("v.isPositiveInstrument",true);
                            mapForRecordIdandRecordType.set(result[i].requiredFA.Id,result[i].requiredFA.RecordTypeId);
                          
                        }else{
                            negativeAccountDetails.push(result[i].requiredFA);
                            
                            component.set("v.isNegativeInstrument",true);
                            mapForRecordIdandRecordType.set(result[i].requiredFA.Id,result[i].requiredFA.RecordTypeId);
                            
                        }
                    }
                    
                }
                
                
                component.set("v.positiveAccountDetails",positiveAccountDetails);
                component.set("v.negativeAccountDetails",negativeAccountDetails);
                component.set("v.mapForRecordIdandRecordType",mapForRecordIdandRecordType);
                console.log(result);
                
                
            }
            
            else if (state === "ERROR") {
                
                var errors = res.getError();
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
         $A.enqueueAction(act);
 }

})