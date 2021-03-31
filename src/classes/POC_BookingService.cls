/**
 * Created by BADJI on 06/03/2021.
 */
@RestResource(urlMapping='/v1/bookingService/*')
global with sharing class POC_BookingService {

    @HttpPost
    global static Map<String, String> getRecortype(){
        Map<String,String> mapRecordTypeName = POC_Query.getRecordType('WorkOrder');
        system.debug('*** *'+mapRecordTypeName);
        return mapRecordTypeName;
    }

    /*@HttpPost
    global static Map*/
}