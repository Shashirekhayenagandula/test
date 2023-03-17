({
	handleChange : function(component, event, helper) {
		 console.log('In pageReference HANDLER ');
        $A.get('e.force:refreshView').fire();
	}
})