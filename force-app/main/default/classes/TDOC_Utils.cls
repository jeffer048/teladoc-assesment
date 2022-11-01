/*
 * Classname: TDOC_Utils
 * Author: Jefferson Escobar
 * Date: 10-Oct-2022
 * Description: Utility class
 *
 * Copyright notice
 */
public without sharing class TDOC_Utils {
    public static Id getGroupId (String groupName){
        List<Group> groups = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = :groupName];
        /** Return group Id for a group name else return null*/
        return (!groups.isEmpty() ? groups.get(0).Id : null);
    }
}