@isTest
public class TDOC_ManageOpenCaesBatch_Test {
	@TestSetup
	static void makeData() {

		User contextUser = TDOC_TestDataFactory.createTestUser(TDOC_StaticConstants.SYS_ADMIN_PROFILE);
		insert contextUser;

		System.runAs(contextUser) {
			List < Task__c > tasks = TDOC_TestDataFactory.createTasks(2);
			tasks.get(0).Status__c = TDOC_StaticConstants.TASK_STATUS_CALL_BACK;
			tasks.get(1).Followup_Date__c = System.today();
			insert tasks;

			List < Participant__c > participants = TDOC_TestDataFactory.createParticipants(3);
			//Set 1st participant with task
			participants.get(0).Task__c = tasks.get(0).Id;
			participants.get(1).Task__c = tasks.get(1).Id;
			insert participants;

			List<Case> cases = TDOC_TestDataFactory.createCases(4);
			//Set case with Participant
			cases.get(0).Participant__c = participants.get(0).Id;
			cases.get(1).Participant__c = participants.get(1).Id;
			cases.get(2).Participant__c = participants.get(2).Id;
			insert cases;
		}
	}

	@IsTest
	static void manageOpenCases_test() {
		//Start testing context
		Test.startTest();
		//Execute manage open cases batch
		Id batchId = Database.executeBatch(new TDOC_ManageOpenCaesBatch());
		//Finish testing context
		Test.stopTest();

		AsyncApexJob batchJob = [SELECT Id, Status, ApexClassID FROM AsyncApexJob WHERE ApexClass.Name = 'TDOC_ManageOpenCaesBatch'	LIMIT 1];
		User testUser = [SELECT Id FROM User WHERE UserName = '_testUser@teladoc.com.invalid'];

		if (batchJob.Status == 'Completed') {
			List <Case> cases = [SELECT Id, CaseNumber, Status, Participant__c, Participant__r.Task__r.Status__c, Participant__r.Task__r.Followup_Date__c, Owner.Name
									FROM Case WHERE CreatedById =: testUser.Id];

			for (Case c: cases) {
				if (c.Participant__c == null) {
					System.assertEquals(TDOC_StaticConstants.CASE_STATUS_CLOSED, c.Status);
				} else {
					if (c.Participant__r.Task__c == null) {
						System.assertEquals(TDOC_Utils.getGroupId(TDOC_StaticConstants.MEMBER_SUPPORT_QUEUE), c.OwnerId);
					} else if (c.Participant__r.Task__r.Status__c == TDOC_StaticConstants.TASK_STATUS_CALL_BACK) {
						System.assertEquals(TDOC_StaticConstants.CASE_STATUS_CALL_BACK, c.Status);
					} else if (c.Participant__r.Task__r.Followup_Date__c == System.today()) {
						System.assertEquals(TDOC_Utils.getGroupId(TDOC_StaticConstants.MEMBER_SUPPORT_QUEUE), c.OwnerId);
					}
				}
			}
		}

	}
}