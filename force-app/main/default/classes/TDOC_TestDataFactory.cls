/*
 * Classname: TDOC_TestDataFactory
 * Author: Jefferson Escobar
 * Date: 29-Oct-2022
 * Description: Factory class to create sample data for apex test classes
 *
 * Copyright notice
 */
public class TDOC_TestDataFactory {
	
	/**
	* Method for creating test users under a specific profile
	*
	* @param  profileName 	profile name under user to create
	* @return			 	a test user
	*/
	public static User createTestUser(String profileName) {
		Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
		return new User(LastName= '_LastName',
						FirstName= '_FirstName',
						profileId = p.Id,
						Alias='tdocUser',
						Email='_testUser@teladoc.com.invalid',
						username = '_testUser@teladoc.com.invalid',
						EmailEncodingKey = 'UTF-8',
						LanguageLocaleKey = 'en_US',
                        LocaleSidKey = 'en_US',
                        TimeZoneSidKey = 'America/Los_Angeles');
	}

	/**
	* Returns a set of  case records. 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of case records
	*/
	public static List<Case> createCases(Integer howMany){
		List<Case> cases = new List<Case>();
		for(Integer i = 0; i<howMany; i++){
			cases.add(new Case(Status = 'Open'));
		}
		return cases;
	}
	
	/**
	* Returns a set of tasks records 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of tasks records
	*/
	public static List<Task__c> createTasks(Integer howMany){
		List<Task__c> tasks = new List<Task__c>();
		for(Integer i = 0; i<howMany; i++){
			tasks.add(new Task__c(Status__c = 'Not Started	'));
		}

		return tasks;
	}
	
	/**
	* Returns a set of participant records. 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of participants records
	*/
	public static List<Participant__c> createParticipants(Integer howMany){
		List<Participant__c> participants = new List<Participant__c>();
		for(Integer i = 0; i<howMany; i++){
			participants.add(new Participant__c(Name = i + ' - Test Participant - ' + System.now()));
		}
		return participants;
	}

	/**
	* Returns a set of contact records. 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of contacts records
	*/
	public static List<Contact> createContacts(Integer howMany){
		List<Contact> contacts = new List<Contact>();
		for(Integer i = 0; i<howMany; i++){
			contacts.add(new Contact(FirstName ='_Test_Contact', LastName = '_Test_LastName'));
		}
		return contacts;
	}

	/**
	* Returns a set of device records. 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of device records
	*/
	public static List<Device__c> createDevices(Integer howMany){
		List<Device__c> devices = new List<Device__c>();
		for(Integer i = 0; i<howMany; i++){
			devices.add(new Device__c(Name = '_Test_Device'));
		}
		return devices;
	}

	/**
	* Returns a set of member device records. 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of member device records
	*/
	public static List<Member_Device__c> createDeviceMember(Integer howMany, Id contactId, Id deviceId){
		List<Member_Device__c> memberDevices = new List<Member_Device__c>();
		for(Integer i = 0; i<howMany; i++){
			memberDevices.add(new Member_Device__c(Contact__c = contactId, Device__c = deviceId, Quantity__c = i, Status__c = TDOC_StaticConstants.DEVICE_STATUS_ACTIVE));
		}
		return memberDevices;
	}

	/**
	* Returns a set of program records. 
	*
	* @param  howMany 	quantity of records to create
	* @return			List of program records
	*/
	public static List<Program__c> createPrograms(Integer howMany){
		List<Program__c> programs = new List<Program__c>();
		for(Integer i = 0; i<howMany; i++){
			programs.add(new Program__c(Name = '_Test_Program_' + i , Status__c = 'Active'));
		}
		return programs;
	}
}
