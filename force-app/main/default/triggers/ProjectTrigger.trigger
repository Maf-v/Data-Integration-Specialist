trigger ProjectTrigger on Project__c (after update) {
    for(Project__c project : Trigger.new) {
        if (project.Status__c  == 'Billable') {
            String projectRef = project.ProjectRef__c;
            Decimal amount = project.Billable_Amount__c;
            BillingCalloutService.callBillingService(projectRef, amount);
        }
    }
}