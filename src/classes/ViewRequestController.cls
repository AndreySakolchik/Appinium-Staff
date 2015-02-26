public with sharing class ViewRequestController {

    public Request__c gottenRequest {get; set;}
    public Vacancy__c madeVacancy {get; set;}
    public List<Skill__c> neededSkills {get; set;}    

    public void init() {
         gottenRequest = [SELECT Subject__c, CreatedById, Budget_Type__c
                        FROM Request__c
                        WHERE ID =: ApexPages.currentPage().getParameters().get('Id')
                        LIMIT 1];
        if(gottenRequest.Budget_Type__c.equals('Vacancy')) {
            madeVacancy = new Vacancy__c();
            neededSkills = [SELECT Name
                            FROM Skill__c
                            WHERE ID IN (SELECT Skill__c FROM RequestSkill__c WHERE Request__c =: gottenRequest.ID)
                            LIMIT 1000];
        }
    }

    public ViewRequestController() {

    }   

    public PageReference accept() {
        if(gottenRequest == null) {
            init();
        }
        try {
            if(gottenRequest.Budget_Type__c.equals('Vacancy')) {
                gottenRequest.Request_Status__c = 'Accepted';
                update gottenRequest;
                madeVacancy.Active__c = true;
                madeVacancy.Job_Title__c = gottenRequest.Subject__c;
                insert madeVacancy;
                EmailTemplate emailTemplate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = 'Accepted Vacancy Request'];        
                EmailHandler.sendApprovedRequestEmail(emailTemplate, gottenRequest, madeVacancy.ID, new String[] {
                    '{!vacancyLink}', 
                    'New Vacancy'
                    });
                return new PageReference('http://ap2.salesforce.com/' + madeVacancy.ID);
            }
        }
        catch(System.EmailException exc) {
                return null;
        }
        return null;
    }

    public PageReference reject() {
        if(gottenRequest == null) {
            init();
        }
        try {
            gottenRequest.Request_Status__c = 'Rejected';
            EmailTemplate emailTemplate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = 'Rejected Request'];        
            EmailHandler.sendRejectedRequestEmail(emailTemplate, gottenRequest);
            update gottenRequest;
            return new PageReference('http://ap2.salesforce.com/' + gottenRequest.ID);
        }
        catch(System.EmailException exc) {
            return null;
        }
    }
}