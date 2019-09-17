({
	showNotifications : function(component, event, helper) {
        var profUrl = $A.get('$Resource.newlabel');
        
		var action=component.get("c.displayNotifications");
        
        action.setCallback(this,function(res){
            var state=res.getState();
           var myMap = new Map();
            var myHeaderMap = new Map();
            if(state==='SUCCESS'){
                var result=res.getReturnValue();
                console.log(result);
                var headerContent = "";
                var notification="";
                var notifications=[];
                var not='';
                var notlist=[];
                var notlist1=[];
              for(var i=0;i<result.length;i++){
               notification=result[i].notifications.Content__c;
                  headerContent = result[i].notifications.Header_Description__c;
                 notifications.push(result[i]) ;
                  not=notification.slice(3,(notification.length)-4);
                  
                  
                  
                    notlist.push(not); 
                notlist1.push(result[i].notifications.Id); 
                 myMap.set(result[i].notifications.Id,result[i].notifications.Content__c);
                 myHeaderMap.set(result[i].notifications.Id,result[i].notifications.Header_Description__c);
                }
                component.set("v.mapt",myMap);
                component.set("v.headMap",myHeaderMap);
                component.set("v.notifications",notlist);
                component.set("v.notifications1",notlist1);
                component.set("v.not",notifications);
                
            }
            
        })
        $A.enqueueAction(action);
	},
    
    
    
    
    doSomething : function(component, event, helper) {
        
       component.set("v.isOpen",true);
       
        var target1=event.target;
        
        //var target = event.target.value;
        //component.set("v.notification",target);
		var index= target1.getAttribute("data-selected-Index");
        component.set("v.index",index);
        var notification=component.get("v.notifications1");
        var myMap1 = new Map();
        var myHeadMap = new Map();
        myHeadMap = component.get("v.headMap");
        myMap1=component.get("v.mapt");
        var notificationstring=myMap1.get(notification[index]);      
         var notificationstring1=notificationstring.slice(3,(notificationstring.length)-4);
        component.set("v.notification",notificationstring1);
        component.set("v.header",myHeadMap.get(notification[index]));
 },
    
    
     markAsRead: function(component, event, helper) {
         var x=component.get("v.notifications1");         
         var y=component.get("v.index");
         var act=component.get("c.change");        
        act.setParams({'recid':x[y]});
        act.setCallback(this,function(res){
            var state=res.getState();
            if(state==='SUCCESS'){
               
                var result=res.getReturnValue();
                
            }
        })
        $A.enqueueAction(act);
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
    
    
    closeModel: function(component, event, helper) {
    component.set("v.isOpen", false);
    },
    doInit : function(component, event, helper) {
        var url = $A.get('$Resource.Tc_Notificationcomp1');
        component.set('v.backgroundImageURL', url);
    }

})