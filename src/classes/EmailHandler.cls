public class EmailHandler {

    public static void sendRequestEmail(EmailTemplate emailTemplate, User user, Request__c request) {
        String subject = emailTemplate.Subject;
  		String htmlBody = emailTemplate.HtmlValue;
  		htmlBody = htmlBody.replace('{!User.Name}', user.Name);
  		htmlBody = htmlBody.replace('{!Request__c.Id}', request.Id);
  		htmlBody = htmlBody.replace(']]>', '');
  		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(user.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.saveAsActivity = false;
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
     	emails.add(message);
     	Messaging.sendEmail(emails); 
	}

 	public static void sendApprovedRequestEmail(EmailTemplate emailTemplate, Vacancy__c acceptedVacancy, String[] args) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setHtmlBody(emailTemplate.HtmlValue
            .replace(']]>', '')
            .replace('<![CDATA[', '')
            .replace(args[0], URL.getSalesforceBaseUrl().toExternalForm() + '/' + acceptedVacancy.Id));
        message.setTargetObjectId(acceptedVacancy.HR_Manager__c);
        message.setSubject(args[1]);
        message.saveAsActivity = false;
        List<Messaging.SingleEmailMessage> acceptedEmail = new List<Messaging.SingleEmailMessage>();
        acceptedEmail.add(message);
        Messaging.sendEmail(acceptedEmail);
 	}

    public static void sendRejectedRequestEmail(EmailTemplate emailTemplate, Request__c rejectedRequest) { 
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setHtmlBody(emailTemplate.HtmlValue
            .replace(']]>', '')
            .replace('<![CDATA[', '')
            .replace('{!requestLink}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + rejectedRequest.ID));
        message.setTargetObjectId(rejectedRequest.Owner.Id);
        message.setSubject(Constants.REJECTED_REQUEST_EMAIL_SUBJECT);
        message.saveAsActivity = false;
        List<Messaging.SingleEmailMessage> rejectedEmail = new List<Messaging.SingleEmailMessage>();
        rejectedEmail.add(message);
        Messaging.sendEmail(rejectedEmail);
    }

}