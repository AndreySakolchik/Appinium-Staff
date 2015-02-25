trigger EmailRequestTrigger on Request__c (after insert) {

	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			RequestEmailHandler.sendEmail();
		}
	}

}