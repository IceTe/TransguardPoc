@RestResource(urlMapping='/v1/worktype/detail')
global with sharing class WorkTypeDomaine {
    /**
     * @description 
     * @param name
     */


    @HttpGet
    global static Map<String, List<SObject>> getConfigDataByServiceId(){
        Map<String, String> paramsMap = RestContext.request.params;
        String name = paramsMap.get('nameWorkType');
        String accountId = paramsMap.get('accountId');
        List<String> listAddress = new List<String>();
        Map<String, List<SObject>> mapData = new Map<String, List<SObject>>();
        List<PricebookEntry> listPricebookEntries = new List<PricebookEntry>();
        List<Worktype> listWorkTypes = [SELECT
            Id, Name, AutoscheduleServiceappointment__c, ShouldAutoCreateSvcAppt,
            BusinessUnit__c, Workorder_RecordtypeID__c, DurationType, EstimatedDuration,
            Description, (SELECT Id , Name  FROM Services__r)
        FROM WorkType
        WHERE Name =: name ];
        if(listWorkTypes.size()>0){
            listPricebookEntries = getPricebookEntries(listWorkTypes[0].Name);
        }
        List<OperatingHours> listHours = getSlotHours();
        string addressOfAccount = TG_SelectAddressCntlr.getAllAddresses(accountId);
        listAddress.add(addressOfAccount);
        List<AssociatedAddress__c> listAssociatedAddresses = getAsssociAssociatedAddressesByAccountId(accountId) ;

        mapData.put('slotHours', listHours);
        mapData.put('address', listAssociatedAddresses);
        mapData.put('worktypes', listWorkTypes);
        mapData.put('pricebookEntries', listPricebookEntries);

        return mapData;
    }

    public static List<PricebookEntry> getPricebookEntries(String serviceType){

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(PricebookEntry obj: [SELECT ID,UnitPrice,Product2.Name,Product2.ServiceType__c
        FROM PricebookEntry
        WHERE Product2.ServiceType__c =:serviceType ORDER BY Product2.Name ASC]){
            pricebookEntries.add(obj);
        }
        return pricebookEntries;
    }

    public static List<OperatingHours> getSlotHours(){
        return [
            SELECT Name, Id,TimeZone,
            (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots)
            FROM OperatingHours limit 1
        ];
    }
    public static List<AssociatedAddress__c> getAsssociAssociatedAddressesByAccountId(String accountId){
        return [SELECT Id, Address__c, Account__c, Primary_Address__c, AddressFormula__c
                FROM AssociatedAddress__c
                WHERE Address__c!= null AND Account__c =: accountId];
    }

}