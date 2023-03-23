@isTest
private class ProjectRESTServiceTest {
    @testSetup 
    static void testSetup() {
        Opportunity newOppor = new Opportunity();
        newOppor.Name = 'Test Oppor Project';
        newOppor.DeliveryInstallationStatus__c = 'In progress';
        newOppor.StageName = 'Closed Won';
        newOppor.CloseDate = Date.today()+5;
        insert newOppor;
    }
    
    @isTest static void testPostProject() {
        Opportunity oppor = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Oppor Project'];
        
		String ProjectRef = 'Ref Test';
        String ProjectName = 'Name Test';
        String OpportunityId = oppor.Id;
        Date StartDate = Date.today();
        Date EndDate = Date.today()+5;
        Double Amount = 10000;
        String Status = 'Running';
        
        String resultMessage = ProjectRESTService.postProjectData(ProjectRef, ProjectName,
                                  OpportunityId, StartDate, EndDate, Amount, Status);
        System.assertEquals('OK', resultMessage);
    }
    
    @isTest static void testPostProjectFailure() {
		String ProjectRef = 'Ref Test';
        String ProjectName = 'Name Test';
        String OpportunityId = '006Dn021654541DXWIA2';
        Date StartDate = Date.today();
        Date EndDate = Date.today()+5;
        Double Amount = 10000;
        String Status = 'Running';
        
        String resultMessage = ProjectRESTService.postProjectData(ProjectRef, ProjectName,
                                  OpportunityId, StartDate, EndDate, Amount, Status);
        System.assertEquals('ERROR', resultMessage);
    }
}