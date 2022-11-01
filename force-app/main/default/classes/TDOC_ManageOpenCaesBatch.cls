/*
 * Classname: TDOC_ManageOpenCaesBatch
 * Author: Jefferson Escobar
 * Date: 29-Oct-2022
 * @Description: Salesforce class to manage open cases mass processing
 *
 * Copyright notice
 */
public with sharing class TDOC_ManageOpenCaesBatch implements Database.Batchable<sObject> {
	/**Reference status values cases and tasks */
    private static final  String CASE_STATUS_OPEN = TDOC_StaticConstants.CASE_STATUS_OPEN;
    private static final  String CASE_STATUS_CALL_BACK = TDOC_StaticConstants.CASE_STATUS_CALL_BACK;
    private static final  String CASE_STATUS_CLOSED = TDOC_StaticConstants.CASE_STATUS_CLOSED;
    private static final String TASK_STATUS_CALL_BACK = TDOC_StaticConstants.TASK_STATUS_CALL_BACK;
    /**Get Member Support Queue Id */
	private static Id supportQueueId = TDOC_Utils.getGroupId(TDOC_StaticConstants.MEMBER_SUPPORT_QUEUE);

		
	/**
	* Scope of the query batch
	*
	* @param  BC 	batchable context
	* @return		list of open case
	*/
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, Status, Participant__c, Participant__r.Task__r.Status__c, Participant__r.Task__r.Followup_Date__c FROM Case WHERE Status = :CASE_STATUS_OPEN ]);
	}

	public void execute(Database.BatchableContext BC, List<Case> cases) {
		//Iterate over the open cases gather in the scope
		for (Case c: cases) {
			//Case has at least one participant
			if (c.Participant__c == null) {//Case does not have any participant then set to closed status
				c.Status = CASE_STATUS_CLOSED;
			} else{
				if (c.Participant__r.Task__c == null) {
					//Case has participants but not task then set owner to the member support queue
					c.OwnerId = supportQueueId;
				}else if (c.Participant__r.Task__r.Status__c == TASK_STATUS_CALL_BACK) {
					//Case has a participant and its task is set to Call back then set status case to call back
					c.Status = CASE_STATUS_CALL_BACK;
				} else if (c.Participant__r.Task__r.Followup_Date__c == System.today()) {
					//Case has a participant but its task is not set to Call back and followup date is today then assign case to member support queue
					c.OwnerId = supportQueueId;
				}
			}
		}
		update cases;
	}

	public void finish(Database.BatchableContext BC) {
	}
}