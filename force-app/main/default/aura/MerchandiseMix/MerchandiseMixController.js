({
    doInit : function(component, event, helper) {
        var mixId = component.get("v.recordId");
        helper.loadMixItems(component, mixId);
        
        var columns = [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Category', fieldName: 'Category__c', type: 'text'},
            {label: 'Price', fieldName: 'Price__c', type: 'currency'},
            {label: 'Qty', fieldName: 'Qty__c', type: 'number'},
        ];
        component.set("v.columns", columns);
        
    },

    dropHandler : function(component, event, helper) {
        event.preventDefault();
        var cmpTarget= component.find("dropZone");
        $A.util.removeClass(cmpTarget, 'active');
        var mixItems = component.get("v.mixItems");
        var merchandise = JSON.parse(event.dataTransfer.getData("merchandise"));
        var mixItem = {
            Merchandising_Mix__c: component.get("v.recordId"),
            Merchandise__c: merchandise.Id,
            Qty__c: 10,
            Merchandise__r: {
                Id: merchandise.Id,
                Name: merchandise.Name,
                Price__c: merchandise.Price__c,
                Category__c: merchandise.Category__c,
                Picture_URL__c: merchandise.Picture_URL__c
            }
        };
        mixItems.push(mixItem);
        helper.addItem(component, mixItem);
        component.set("v.mixItems", mixItems);

        var tableItems = component.get("v.tableItems");
        var tableItem = {
            Name: merchandise.Name,
            Price__c: merchandise.Price__c,
            Category__c: merchandise.Category__c,
            Picture_URL__c: merchandise.Picture_URL__c,
            Qty__c: 10
        };
        tableItems.push(tableItem);
        component.set("v.tableItems", tableItems);
    },

    dragOverHandler : function(component, event) {
        event.preventDefault();
        var cmpTarget= component.find("dropZone");
        $A.util.addClass(cmpTarget, 'active');
    },

    dragLeaveHandler : function(component, event){
        event.preventDefault();
        var cmpTarget= component.find("dropZone");
        $A.util.removeClass(cmpTarget, 'active');
    },

    mixItemDeleteHandler : function(component, event, helper) {
        var mixItem = event.getParam("mixItem");
        helper.removeItem(component, mixItem);
    },

    mixItemChangeHandler : function(component, event, helper) {
        var mixItem = event.getParam("mixItem");
        helper.updateItem(component, mixItem);
    },

    getSelectedName: function (cmp, event) {
        /*
        var selectedRows = event.getParam('selectedRows');
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            console.log(selectedRows[i]);
        }
        */
    },

    toggleListMode: function (component, event, helper) {       
        var iconName = event.getSource().get("v.iconName");
        component.set('v.isTile', iconName === 'utility:apps');
    }

})