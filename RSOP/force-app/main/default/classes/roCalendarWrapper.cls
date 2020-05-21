public class roCalendarWrapper {
    
    @AuraEnabled public List<connectorObject> connectorObjectList {get; set;}

    public class connectorObject{
        @AuraEnabled public string objectAPIName {get; set;}
        @AuraEnabled public string objectLabel {get; set;}
        @AuraEnabled public List<connectorObjectData> objectData {get; set;} 
        @AuraEnabled public string colorCode {get; set;}
    }

    public class connectorObjectData{
        @AuraEnabled public string recordId {get; set;}
        @AuraEnabled public string recordName {get; set;}
        @AuraEnabled public string description {get; set;}
        @AuraEnabled public string startDateTime {get; set;}
        @AuraEnabled public string endDateTime {get; set;}
        @AuraEnabled public string filterData {get; set;}
    }

    
}