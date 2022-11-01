/*
 * Classname: TDOC_MemberDeviceTriggerHandler
 * Author: Jefferson Escobar
 * Date: 29-Oct-2022
 * @Description: Member device handler class to control logic based on trigger contexts
 *
 * Copyright notice
 */
public class TDOC_MemberDeviceTriggerHandler extends TriggerHandler {

	public override void afterInsert() {
		calcuateDeviceQuantity((List <Member_Device__c >) Trigger.new);
	}

	public override void afterUpdate() {
		calcuateDeviceQuantity((List <Member_Device__c >) Trigger.new);
	}

	public override void afterDelete() {
		calcuateDeviceQuantity((List <Member_Device__c >) Trigger.old);
	}
	
	/**
	* Rollup summary by device quantity on contacts
	*
	* @param  memberDevices 	list of devices to recalcualte quantity
	* @return
	*/
	public void calcuateDeviceQuantity( List <Member_Device__c > memberDevices) {
		Set<Id> contactIDs = new Set<Id>();
		List<Contact> contacts2Update = new List<Contact>();
		//Get all devices under contact member
		for (Member_Device__c mdvc: memberDevices) {
			contactIDs.add(mdvc.Contact__c);
		}
		//Sum up number of active devices under contact
		for (Contact  c :  [SELECT Id, (SELECT Id, Quantity__c, Status__c FROM Member_Devices__r WHERE Status__c = :TDOC_StaticConstants.DEVICE_STATUS_ACTIVE)
								FROM Contact WHERE Id IN: contactIDs] ) {
			c.Total_Device_Quantity__c = 0;
			for(Member_Device__c mdvc : c.Member_Devices__r){
				if (mdvc.Quantity__c != null) {
					c.Total_Device_Quantity__c += mdvc.Quantity__c;
				}
			}
			contacts2Update.add(c);
		}
		
		if (!contacts2Update.isEmpty()) {
			update contacts2Update;
		}
	}
}