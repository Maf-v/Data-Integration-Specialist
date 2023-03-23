@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
    // https://dataintegration2-dev-ed.my.salesforce.com/services/apexrest/project
     
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, 
                                 String OpportunityId, Date StartDate, 
                                 Date EndDate, Double Amount, String Status) {
        String respError = 'ERROR';
        String respOK = 'OK';
        SavePoint sp = Database.setSavepoint();
                                     
        try {
            Opportunity oppor = [SELECT Id, Name, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =:OpportunityId ];
            oppor.DeliveryInstallationStatus__c = 'In Progress';
            update oppor;                        
                                                  
            Project__c newProject = new Project__c();
            newProject.ProjectRef__c = ProjectRef;
            newProject.Name = ProjectName;
            newProject.Opportunity__c = OpportunityId;
            newProject.Start_Date__c = StartDate;
            newProject.End_Date__c = EndDate; 
            newProject.Billable_Amount__c = Amount;
            newProject.Status__c = Status;
            System.debug(newProject);              
            upsert newProject;
            return respOK;
        } catch(Exception excep) {
            Database.rollback(sp);
            return respError;
        }                    
    }
}