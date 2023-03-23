public class ProjectCalloutService {
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> opporId) {
        QueueablePMSCall postCallout = new QueueablePMSCall(opporId);
        System.enqueueJob(postCallout);
    }
    
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts{
        public List<Id> opporId;
        
        public QueueablePMSCall(List<Id> idOppor) {
            this.opporId = idOppor;
        }
        
        public void execute (QueueableContext context) {
            String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
            
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('token', serviceToken);
            request.setHeader('Content-Type', 'application/json');
            
            //body
            Opportunity opporObj = [SELECT Id, Name, CloseDate, Amount, AccountId, StageName FROM Opportunity WHERE Id = :opporId[0]];
            serializePostJson jsonObj = new serializePostJson();
            jsonObj.opportunityId = opporObj.Id;
            jsonObj.opportunityName = opporObj.Name;
            jsonObj.closeDate = opporObj.CloseDate;
            jsonObj.amount = opporObj.Amount;
            Account account = [SELECT Id, Name FROM Account WHERE Id = :opporObj.AccountId LIMIT 1];
            jsonObj.accountName = account.Name;
            
            String jsonBody = JSON.serialize(jsonObj);
            request.setBody(jsonBody);
            
            System.debug(jsonBody);
            System.debug(jsonObj);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                opporObj.StageName = 'Resubmit Project';
            } else {
                opporObj.StageName = 'Submitted Project';
            }
            
            update opporObj;
        }
    }
}