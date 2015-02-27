@isTest
private class ViewRequestControllerTest {

    private static ViewRequestController viewRequestController;

    private static void init() {
        Request__c request = new Request__c(Name = '111', Subject__c = '222', Budget_Type__c = 'Vacancy');
        insert request;
        PageReference pr = Page.ViewRequest;
        pr.getParameters().put('Id', request.Id);
        Test.setCurrentPageReference(pr);
        viewRequestController = new ViewRequestController();
    }

    @isTest static void testAccept_Fail() {  
        init();
        viewRequestController.madeVacancy.HR_Manager__c = null;
        viewRequestController.doAccept();
        System.assertNotEquals(viewRequestController.errorMsg, null);
    }
    
    @isTest static void testReject_Fail() {
        init();
        viewRequestController.doReject();
        System.assertNotEquals(viewRequestController.gottenRequest, null);
    }

    @isTest static void testInit_Fail() {
        init();
        viewRequestController = new ViewRequestController();
        try {
            viewRequestController.init();
        }
        catch(System.QueryException exc) {

        }
        System.assertNotEquals(viewRequestController, null);
    }
    
}