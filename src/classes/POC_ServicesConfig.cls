/**
 * Created by Abdoulaye DIOP on 06/03/2021.
 */
@RestResource(urlMapping='/v1/services/*')
global with sharing class POC_ServicesConfig {
    @HttpGet
    global static Map<String, List<TGConfiguration__c>> doGetServices(){
        Map<String, List<SObject>> mapData = new Map<String, List<SObject>>();
        List<TGConfiguration__c > tgConfigs = [SELECT Id, Name, IsActive__c, Is_Booking__c, TGConfiguration__c, Title__c FROM TGConfiguration__c 
           WHERE IsActive__c = true AND TGConfiguration__c = null AND RecordType.DeveloperName ='ServicesHeaderConfig'];
        mapData.put('tgconfigs', tgconfigs);
        return mapData;
    }

    
    
    
    
}