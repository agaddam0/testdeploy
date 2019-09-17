({
	doInit: function(component, event, helper) {
        
     
     helper.getDetails(component,event,helper);
 } ,
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
     	component.set("v.isOpen", true);
      // var recordId=event.target.getAttribute("data-selected-Index");
 		let recordId = event.target.getAttribute("data-value");
        
        component.set("v.recId",recordId);
        var mapForRecordIdandRecordType = new Map();
        
        mapForRecordIdandRecordType=component.get("v.mapForRecordIdandRecordType");
        
        
        component.set("v.recTypeId",mapForRecordIdandRecordType.get(recordId));
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   }
    
})