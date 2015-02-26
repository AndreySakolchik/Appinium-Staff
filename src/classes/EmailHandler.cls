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

 	public static void sendApprovedRequestEmail(EmailTemplate emailTemplate, Request__c acceptedRequest, Id link, String[] args) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setHtmlBody(emailTemplate.HtmlValue
                .replace(']]>', '')
                .replace('<![CDATA[', '')
                .replace(args[0], 'http://ap2.salesforce.com/' + link));
            message.setTargetObjectId(acceptedRequest.CreatedById);
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
            .replace('{!requestLink}', 'http://ap2.salesforce.com/' + rejectedRequest.ID));
        message.setTargetObjectId(rejectedRequest.CreatedById);
        message.setSubject('Request was rejected');
        message.saveAsActivity = false;
        List<Messaging.SingleEmailMessage> rejectedEmail = new List<Messaging.SingleEmailMessage>();
        rejectedEmail.add(message);
        Messaging.sendEmail(rejectedEmail);
    }

}