({
	handleToggleChanged : function(component, event, helper) {
        var toggleValue = component.find("checkbox").get("v.value");
        console.log(toggleValue);
        var recordId = component.get('v.recordId');
        console.log(recordId);
        if(toggleValue == true){
            var action=component.get('c.chargeRecordCreation');
            action.setParams({ recordId :recordId });
            $A.enqueueAction(action)
        }
        
        if(toggleValue == false){
            var action=component.get('c.updateEndTimeOnRelatedContact');
            action.setParams({ recordId :recordId });
            $A.enqueueAction(action)
        }        
	},
})