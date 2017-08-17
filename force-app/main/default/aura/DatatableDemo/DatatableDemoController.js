({
    init: function (cmp, event, helper) {
    cmp.set('v.mycolumns', [
                {label: 'Opportunity name', fieldName: 'opportunityName', type: 'text'},
                {label: 'Confidence', fieldName: 'confidence', type: 'percent'},
                {label: 'Amount', fieldName: 'amount', type: 'currency', cellAttributes: { currencyCode: 'EUR'}},
                {label: 'Contact Email', fieldName: 'contact', type: 'email'},
                {label: 'Contact Phone', fieldName: 'phone', type: 'phone'}
            ]);
        cmp.set('v.mydata', [{
                id: 'a',
                opportunityName: 'Cloudhub',
                confidence: 0.2,
                amount: 25000,
                contact: 'jrogers@cloudhub.com',
                phone: '2352235235'
            },
            {
                id: 'b',
                opportunityName: 'Quip',
                confidence: 0.78,
                amount: 740000,
                contact: 'quipy@quip.com',
                phone: '2352235235'
            }]);
    },
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            alert("You selected: " + selectedRows[i].opportunityName);
        }
    }
})