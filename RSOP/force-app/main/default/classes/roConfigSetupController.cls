public class roConfigSetupController {

    @AuraEnabled
    public static Resource_Optimizer_Config__mdt getMetadataRecord(){
        List<Resource_Optimizer_Config__mdt> configMetadata = [SELECT Id, MasterLabel, DeveloperName, 
            Are_your_Users_are_Resources__c, Do_you_allow_Overlay__c, Do_you_allow_skill_based__c, 
            Do_you_need_Resource_Grouping__c, Organisation_business_hours_end_time__c, 
            Organisation_business_hours_start_time__c, Select_Profiles_to_create_Resources__c 
            FROM Resource_Optimizer_Config__mdt WHERE DeveloperName = 'Resource_Optimizer_Config' LIMIT 1];
        
        if(configMetadata != null && configMetadata.size() > 0){
            return configMetadata[0];
        }
        else{
            return new Resource_Optimizer_Config__mdt();
        }
        
    }
}