@isTest
private class ViewRequestControllerTest {

    @isTest static void testAcceptReject() {        
        ViewRequestController viewRequestController = new ViewRequestController();
        viewRequestController.gottenRequest = new Request__c(Name = '111', Subject__c = '222', Budget_Type__c = 'Vacancy');
        insert viewRequestController.gottenRequest;
        viewRequestController.madeVacancy = new Vacancy__c();       
        System.assertEquals(viewRequestController.accept(), null);
    }
    
    @isTest static void testReject() {
        ViewRequestController viewRequestController = new ViewRequestController();
        viewRequestController.gottenRequest = new Request__c(Name = '111', Subject__c = '222', Budget_Type__c = 'Vacancy');
        insert viewRequestController.gottenRequest; 
        System.assertNotEquals(viewRequestController.reject(), new PageReference('http://ap2.salesforce.com/' + viewRequestController.gottenRequest.ID));
    }

    @isTest static void testInit() {
        ViewRequestController viewRequestController = new ViewRequestController();
        try {
            viewRequestController.init();
        }
        catch(System.QueryException exc) {

        }
        System.assertEquals(viewRequestController.gottenRequest, null);
    }
    
}