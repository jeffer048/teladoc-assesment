/*
 * Classname: TDOC_StaticConstants
 * Author: Jefferson Escobar
 * Date: 29-Oct-2022
 * Description: Salesforce class to manage open cases mass processing
 *
 * Copyright notice
 */
public with sharing class TDOC_StaticConstants {
    /**Case status values */
    public static final String CASE_STATUS_OPEN = 'Open';
    public static final String CASE_STATUS_CALL_BACK = 'Call Back';
    public static final String CASE_STATUS_CLOSED = 'Closed';
    /**Task__c status values */
    public static final String TASK_STATUS_CALL_BACK = 'Call Back';
    /**Profiles */
    public static final String DEVICE_STATUS_ACTIVE = 'Active';
    public static final String DEVICE_STATUS_INACTIVE = 'Inactive';
    
    /** Groups and queue names*/
    public static final String MEMBER_SUPPORT_QUEUE = 'Member_Support_Queue';
    /**Profiles */
    public static final String SUPPORT_PROFILE = 'Support Profile';
    public static final String SYS_ADMIN_PROFILE = 'System Administrator';

    /** Messages */
    public static final String MSG_SUCCESS = 'SUCCESS';

    


}
