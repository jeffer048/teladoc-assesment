@isTest
public class TDOC_MemberDeviceTriggerHandler_Test {
    @isTest
	static void deviceMemberTriggerHandler_test(){
		User contextUser = TDOC_TestDataFactory.createTestUser(TDOC_StaticConstants.SYS_ADMIN_PROFILE);
		insert contextUser;
		
		Test.startTest();
		System.runAs(contextUser) {
			List < Contact > contacts = TDOC_TestDataFactory.createContacts(1);
			insert contacts;

			List < Device__c > devices = TDOC_TestDataFactory.createDevices(1);
			insert devices;

			List < Member_Device__c > memberDevices = TDOC_TestDataFactory.createDeviceMember(2, contacts.get(0).Id, devices.get(0).Id);
			//test after insert context
			insert memberDevices; 

			//Test after update context
			memberDevices.get(0).Quantity__c = 10;
			update memberDevices.get(0);
			
			//Test after delete context
			delete memberDevices.get(0);
		}
		Test.stopTest();

		Contact c = [SELECT Total_Device_Quantity__c, (SELECT Quantity__c FROM Member_Devices__r WHERE Status__c = :TDOC_StaticConstants.DEVICE_STATUS_ACTIVE) 
						FROM Contact WHERE CreatedById = :contextUser.Id LIMIT 1];
		Integer totalDevice = Integer.valueOf(c.Total_Device_Quantity__c);
		Integer deviceCounter = 0;
		for(Member_Device__c mdvc : c.Member_Devices__r){
			deviceCounter += Integer.valueOf(mdvc.Quantity__c);
		}
		System.assertEquals(totalDevice ,deviceCounter);
		
	}
}