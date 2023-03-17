({
  
    handleChange : function(component, event, helper) {
        //var pageReference = component.get("v.pageReference");
        console.log('In pageReference HANDLER ');
        $A.get('e.force:refreshView').fire();
       
    },
 
})