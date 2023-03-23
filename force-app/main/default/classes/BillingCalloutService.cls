public class BillingCalloutService {
    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal amount) {
        
        BillingServiceProxy.project servProject = new BillingServiceProxy.project();
        ServiceCredentials__c serviceCredentials = ServiceCredentials__c.getValues('BillingServiceCredential');
        servProject.username = serviceCredentials.Username__c;
        servProject.password = serviceCredentials.Password__c;
        servProject.billAmount  = amount;
        servProject.projectid = projectRef;
        
        BillingServiceProxy.InvoicesPortSoap11 invoicePortSoap = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invoicePortSoap.billProject(servProject);
        if(response == 'Is Correct') {
            Project__c project = [SELECT Id, Status__c FROM Project__c WHERE ProjectRef__c =:projectRef];
        	project.Status__c = 'Billed';
        	update project;
        }

    }
}