public class RequestEmailHandler {

	public static void sendEmail() {

		EmailTemplate et = [SELECT ID, Subject, HtmlValue, Body 
		                    FROM EmailTemplate 
		                    WHERE Name =:'Employee request'];

		Profile pr = [ SELECT ID 
		           	   FROM Profile
		           	   WHERE Name = 'General Manager (GM)' 
		           	   LIMIT 1];

		User gm = [SELECT ID, Name
		           FROM User 
		           WHERE ProfileId =: pr.Id
		           LIMIT 1];

		Request__c rst = [SELECT ID, Job_Title__c FROM Request__c LIMIT 1];

        String subject = et.Subject;
		String htmlBody = et.HtmlValue;
		htmlBody = htmlBody.replace('{!User.Name}', gm.Name);
		htmlBody = htmlBody.replace('{!Vacancy__c.Id}', rst.Id);
		htmlBody = htmlBody.replace('{!Post}', rst.Job_Title__c + ' ');
		htmlBody = htmlBody.replace(']]>', '');

		Messaging.SingleEmailMessage message = 
		              new Messaging.SingleEmailMessage();

        message.setTargetObjectId(gm.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.saveAsActivity = false;

        List<Messaging.SingleEmailMessage> emails = 
	            new List<Messaging.SingleEmailMessage>();

	    emails.add(message);

	    Messaging.sendEmail(emails); 

	}

}