@isTest
public with sharing class TDOC_ProgramDetailMemberController_Test {
	@TestSetup
	static void makeData(){
		User contextUser = TDOC_TestDataFactory.createTestUser(TDOC_StaticConstants.SYS_ADMIN_PROFILE);
		insert contextUser;
		
		Test.startTest();
		System.runAs(contextUser) {
			List < Contact > contacts = TDOC_TestDataFactory.createContacts(1);
			insert contacts;

			List < Program__c > programs = TDOC_TestDataFactory.createPrograms(1);
			programs.get(0).Contact__c = contacts.get(0).Id;
			insert programs;
			
		}
		Test.stopTest();
	}

	@IsTest
	static void getPrograms_test(){
		User contextUser = [SELECT Id FROM User WHERE UserName = '_testUser@teladoc.com.invalid'];

		Test.startTest();
		System.runAs(contextUser){
			Contact contact = [SELECT Id FROM Contact WHERE CreatedById = :contextUser.Id LIMIT 1];
			List<Program__c> programs = TDOC_ProgramDetailMemberController.getPrograms(contact.Id);
			System.assertEquals(1, programs.size());//Must return 1 program by this contact record

			Program__c program = programs.get(0);
			program.Status__c = 'Inactive';
			Map<String, String> mapProgram = new Map<String, String>{'Id' => program.Id, 'Status__c' => program.Status__c };
			TDOC_ProgramDetailMemberController.updatePrograms(new List<Map<String, String>>{mapProgram});
		}
		Test.stopTest();
		List<Program__c> programs = [SELECT Id, Status__c FROM Program__c WHERE CreatedById = :contextUser.Id];
		System.assertEquals('Inactive', programs.get(0).Status__c);
	}
}
