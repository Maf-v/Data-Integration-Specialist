@isTest
public class BillingCalloutServiceTest {
    @testSetup static void testSetup() {
        Project__c newProject = new Project__c();
        newProject.Name = 'Test Project';
        newProject.Opportunity__c = '006Dn0000041DXWIA2';
        newProject.Billable_Amount__c = 10000;
        insert newProject;
        
        ServiceCredentials__c servCred = new ServiceCredentials__c();
        servCred.Name = 'BillingServiceCredential';
        servCred.Username__c = 'usr1';
        servCred.Password__c = 'pwd1';
        insert servCred;
    }
    
    @isTest
    public static void testCalloutService() {
    	Test.setMock(WebServiceMock.class , new BillingCalloutServiceMock());
        
        Project__c project = [SELECT Id, Name, ProjectRef__c, Billable_Amount__c FROM Project__c WHERE Name = 'Test Project' LIMIT 1];
        
        Test.startTest();
        BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
        Test.stopTest();

        Project__c projectResult = [SELECT Id, Status__c FROM Project__c WHERE ProjectRef__c =:project.ProjectRef__c];
        System.assertEquals('Billed', projectResult.Status__c);
    }
    
    @isTest
    public static void testCalloutServiceFailure() {
    	Test.setMock(WebServiceMock.class , new BillingCalloutServiceMockFailure());
        
        Project__c project = [SELECT Id, Name, ProjectRef__c, Billable_Amount__c FROM Project__c WHERE Name = 'Test Project' LIMIT 1];
        
        Test.startTest();
        BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
        Test.stopTest();

        Project__c projectResult = [SELECT Id, Status__c FROM Project__c WHERE ProjectRef__c =:project.ProjectRef__c];
        System.assertNotEquals('Billed', projectResult.Status__c);
    }
    
}