/*
 * Classname: TDOC_ProgramDetailMemberController
 * Author: Jefferson Escobar
 * Date: 29-Oct-2022
 * @Description: Controller class to retrieve programs under contact member
 *
 * Copyright notice
 */

public with sharing class TDOC_ProgramDetailMemberController {
	@AuraEnabled(cacheable = true)

	public static List < Program__c > getPrograms(String contactId) {
		return [SELECT Id, Name, Status__c FROM Program__c WHERE Contact__c =: contactId WITH SECURITY_ENFORCED];
	}

	/**
	 * 
	 *
	 * @param  programs 	List of programs to update status
	 * @return			error or success message
	 */
	@AuraEnabled

	public static String updatePrograms(List < Map<String, String>> programs) {
		String message;
		if (!programs.isEmpty() && Schema.sObjectType.Program__c.isUpdateable()) {
			//Check if the list has records and user context has permission to update
			List < Program__c > programs2Update = new List < Program__c >();

			for (Map<String, String> program: programs) {
				programs2Update.add(new Program__c(Id = program.get('Id'), Name = program.get('Name'), Status__c = program.get('Status__c')));
			}
			update programs2Update;
			message = TDOC_StaticConstants.MSG_SUCCESS;
		}
		return message;
	}
}