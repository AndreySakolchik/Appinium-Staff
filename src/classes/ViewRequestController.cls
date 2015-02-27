public with sharing class ViewRequestController {

    public Request__c gottenRequest {get; set;}
    public Vacancy__c madeVacancy {get; set;}
    public List<Skill__c> neededSkills {get; set;}   
    public String errorMsg {get; set;} 

    public void init() {
        gottenRequest = [
            SELECT Subject__c, CreatedById, Budget_Type__c
            FROM Request__c
            WHERE ID =: ApexPages.currentPage().getParameters().get('Id')
            LIMIT 1];
        if(gottenRequest.Budget_Type__c.equals(Constants.VACANCY_BUDGET_TYPE)) {
            madeVacancy = new Vacancy__c();
            neededSkills = [
                SELECT Name
                FROM Skill__c
                WHERE ID IN (
                    SELECT Skill__c 
                    FROM RequestSkill__c 
                    WHERE Request__c =: gottenRequest.ID)
                LIMIT 1000];
        }
    }

    public ViewRequestController() {
        init();
    }   

    public PageReference doAccept() {
        try {
            if(gottenRequest.Budget_Type__c.equals(Constants.VACANCY_BUDGET_TYPE)) {
                if(madeVacancy.HR_Manager__c == null) {     
                    errorMsg = 'You have to choose HRM';
                    return null;
                }
                gottenRequest.Request_Status__c = Constants.ACCEPTED_STATUS;
                update gottenRequest;
                madeVacancy.Active__c = true;
                madeVacancy.Job_Title__c = gottenRequest.Subject__c;
                insert madeVacancy;
                EmailTemplate emailTemplate = [
                    SELECT Id, HtmlValue 
                    FROM EmailTemplate 
                    WHERE DeveloperName =: Constants.ACCEPTED_VACANCY_ETEMPLATE_DEVNAME];        
                EmailHandler.sendApprovedRequestEmail(emailTemplate, madeVacancy, new String[] {
                    '{!vacancyLink}', 
                    Constants.ACCEPTED_VACANCY_EMAIL_SUBJECT
                    });
                return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + madeVacancy.ID);
            }
        }
        catch(System.EmailException exc) {
                return null;
        }
        return null;
    }

    public PageReference doReject() {
        try {
            gottenRequest.Request_Status__c = Constants.REJECTED_STATUS;
            EmailTemplate emailTemplate = [
                SELECT Id, HtmlValue 
                FROM EmailTemplate 
                WHERE DeveloperName =: Constants.REJECTED_REQUEST_ETEMPLATE_DEVNAME];        
            EmailHandler.sendRejectedRequestEmail(emailTemplate, gottenRequest);
            update gottenRequest;
            return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + gottenRequest.ID);
        }
        catch(System.EmailException exc) {
            return null;
        }
    }
}