({
    doInit : function(component, helper) {
        var objectName = component.get('v.objectName');
        console.log('objectName'+objectName);
        var FieldName = component.get('v.fieldName');
           
        console.log('----FieldName----'+FieldName);
        
        var outputText = component.find("outputTextId");
            outputText.set("v.value",objectName[FieldName]);
      
        
    }
})