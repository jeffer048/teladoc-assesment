trigger TDOC_MemberDeviceTrigger on Member_Device__c (after insert, after update, after delete) {
    new TDOC_MemberDeviceTriggerHandler().run();
}