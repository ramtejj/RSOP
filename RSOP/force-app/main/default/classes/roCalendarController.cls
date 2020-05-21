public class roCalendarController{
    
    @AuraEnabled(Cacheable = true)
    public static roCalendarWrapper getConnectObjectData(List<string> objectAPINames, string startDateTimeString, string endDateTimeString){
        try{
            system.debug('objectAPINames '+objectAPINames);
            system.debug('objectAPINames '+objectAPINames.size());
            system.debug('objectAPINames '+startDateTimeString);
            system.debug('objectAPINames '+endDateTimeString);
            List<Sobject> connectObjectDataCombined = new List<Sobject>();
            Datetime startDateTime;
            Datetime endDateTime;
            Map<string, Resource_Optimizer_Connector__mdt> connectorMetadataMap = new Map<string, Resource_Optimizer_Connector__mdt>();
            List<Resource_Optimizer_Connector__mdt> connectorDataList = [SELECT Id, Connect_object_API_Name__c, 
            Description_field_API_name__c, End_date_time_field_API_name__c, Start_date_time_field_API_name__c,  
            Filter_field_API_names__c, Object_color_code__c FROM Resource_Optimizer_Connector__mdt WHERE Connect_object_API_Name__c IN :objectAPINames];

            if(connectorDataList == null || connectorDataList.size() == 0){
                //throw exception connector data does not exist
            }
            else if(connectorDataList.size() > 0){
                for(Resource_Optimizer_Connector__mdt connectorData :connectorDataList){
                    
                    if(connectorMetadataMap.containsKey(connectorData.Connect_object_API_Name__c)){
                        //throw exception multiple settings found for object connectorData.Connect_object_API_Name__c
                    }
                    else{
                        connectorMetadataMap.put(connectorData.Connect_object_API_Name__c, connectorData);
                    }

                    if(String.isBlank(connectorData.Start_date_time_field_API_name__c) || String.isBlank(connectorData.End_date_time_field_API_name__c)){
                        //throw exception start date time and/or end date time field is not defined
                    }
                    else{
                        String dynamicQuery = 'SELECT Id, Name, '+connectorData.Start_date_time_field_API_name__c+', ';
                        dynamicQuery += connectorData.End_date_time_field_API_name__c;
                        if(!String.isBlank(connectorData.Description_field_API_name__c)){
                            dynamicQuery += ', '+connectorData.Description_field_API_name__c;
                        }
                        if(!String.isBlank(connectorData.Filter_field_API_names__c)){
                            for(string searchField :connectorData.Filter_field_API_names__c.split(';')){
                                dynamicQuery += ', '+searchField;
                            }
                        }
                        dynamicQuery += ' FROM '+connectorData.Connect_object_API_Name__c+' WHERE ';
                        //dynamicQuery += startDateTime+' >= '+connectorData.Start_date_time_field_API_name__c+' AND ';
                        //dynamicQuery += endDateTime+' <= '+connectorData.End_date_time_field_API_name__c;
                        dynamicQuery += 'Id= \'a0b1s000000BE6D\'';
                        
                        List<Sobject> connectObjectData = Database.query(dynamicQuery);
                        connectObjectDataCombined.addAll(connectObjectData);
                    }
                }
            }

            roCalendarWrapper calendarWrap = createWrapperforCalendar(connectorMetadataMap, connectObjectDataCombined);
            system.debug(JSON.serialize(calendarWrap));
            return calendarWrap;
        }
        catch(exception ex){
            //log exception in log object 
            system.debug('ERROR getting data '+ex.getMessage()+' at '+ex.getStackTraceString());
            return null;
        }
    }

    public static roCalendarWrapper createWrapperforCalendar(Map<string, Resource_Optimizer_Connector__mdt> connectorMetadataMap, List<Sobject> connectObjectData){
        try{
            if(connectObjectData.size() == 0){
                //throw exception no data found
                return null;
            }
            else{
                roCalendarWrapper calendarWrap = new roCalendarWrapper();
                Map<string, roCalendarWrapper.connectorObject> connectObjectMap = new Map<string, roCalendarWrapper.connectorObject>();
                for(Sobject rec :connectObjectData){
                    Id recordId = (Id) rec.get('Id');
                    DescribeSObjectResult sobjeResult = recordId.getsobjecttype().getDescribe();
                    string objectAPIName = sobjeResult.getName();
                    string objectLabel = sobjeResult.getLabel();
                    
                    roCalendarWrapper.connectorObject currentConnectorObject = new roCalendarWrapper.connectorObject();
                    //get existing object row
                    if(connectObjectMap.containsKey(objectAPIName)){
                        currentConnectorObject = connectObjectMap.get(objectAPIName);
                    }

                    currentConnectorObject.objectLabel = objectLabel;
                    currentConnectorObject.objectAPIName = objectAPIName;
                    currentConnectorObject.colorCode = (string) connectorMetadataMap.get(objectAPIName).Object_color_code__c;
                    
                    roCalendarWrapper.connectorObjectData currentRecord = new roCalendarWrapper.connectorObjectData();
                    currentRecord.recordId = (string) rec.get('Id');
                    currentRecord.recordName = (string) rec.get('Name');
                    currentRecord.startDateTime = string.valueOf((Datetime) rec.get(connectorMetadataMap.get(objectAPIName).Start_date_time_field_API_name__c));
                    currentRecord.endDateTime = string.valueOf((Datetime) rec.get(connectorMetadataMap.get(objectAPIName).End_date_time_field_API_name__c));

                    if(!String.isBlank(connectorMetadataMap.get(objectAPIName).Description_field_API_name__c)){
                        currentRecord.description = (string) rec.get(connectorMetadataMap.get(objectAPIName).Description_field_API_name__c);
                    }
                    
                    if(!String.isBlank(connectorMetadataMap.get(objectAPIName).Filter_field_API_names__c)){
                        string filterData = '';
                        for(String field :connectorMetadataMap.get(objectAPIName).Filter_field_API_names__c.split(';')){
                            filterData += (string) rec.get(field)+'; ';
                        }
                        currentRecord.filterData = filterData;
                    }
                    
                    List<roCalendarWrapper.connectorObjectData> allRecordList = currentConnectorObject.objectData != null ? currentConnectorObject.objectData : new List<roCalendarWrapper.connectorObjectData>();
                    allRecordList.add(currentRecord);
                    currentConnectorObject.objectData = allRecordList;
                    connectObjectMap.put(objectAPIName, currentConnectorObject);
                }
                calendarWrap.connectorObjectList = connectObjectMap.values();
                return calendarWrap;
            }
        }
        catch(exception ex){
            //log exception in log object 
            system.debug('ERROR creating wrapper '+ex.getMessage()+' at '+ex.getStackTraceString());
            return null;
        }
    }

    @AuraEnabled(Cacheable = true)
    public static List<WrapperDemo> fetchAccAndCons() {
        List<WrapperDemo> lstWrapper = new List<WrapperDemo>();

        for(Account acIterator : [ SELECT Id, Name, (Select Id, Name From Contacts) FROM Account WHERE Id = '0011s00000BJZzgAAH'] ) {
            lstWrapper.add(new WrapperDemo(acIterator, acIterator.Contacts));
        }

        return lstWrapper;
        
    }
 
 // Wrapper Class
 public class WrapperDemo {
        @AuraEnabled public Account objAcc;
        @AuraEnabled public list<Contact> lstCons;

        public WrapperDemo(Account acc, list<Contact> lstCons) {
            this.objAcc = acc;
            this.lstCons = lstCons;
        }
    }
}