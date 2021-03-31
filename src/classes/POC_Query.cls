/**
 * Created by BADJI on 26/02/2021.
 */

public with sharing class POC_Query {

    public static Account getAllAccountData(String params){
        Account acc = [ SELECT
            Id, FirstName, LastName, Payment_Terms__c, PersonEmail, AccountNumber, Credit_Balance__c, RecordTypeId, RecordType.DeveloperName,
            Name, PhotoUrl, SBQQ__RenewalModel__c
             FROM Account
            WHERE Id=: params OR PersonEmail =: params];
        System.debug('get data values ***** '+acc);
        return acc;

    }

    public static List<WorkOrder> getWorkOrders(String idAccount){
        List<WorkOrder> listWorkOrders = [ SELECT Id,
            WorkType.Name,
            Frequency__c, Workflow_Trigger_Delay__c,Prefered_Date__c,Prefered_Date_Time__c, QuotationRequestedDate__c,
            BusinessUnit__c,Services__c, ServicesRequestFor__c, Status, FM_Priority__c,FM_Problem__c,QuoteExpiryDate__c,
            TotalPrice, Subtotal, TotalPriceVAT__c, LineItemCount,CreatedDate, EndDate,SuggestedMaintenanceDate,StartDate,QuoteSubmittedDate__c,
            MaintenancePlan.FrequencyType,CalloutsFor__c, CaseId, Hourly_Cleaning_Package_Enddate__c,
        (SELECT Id,IsCompleted__c,CheckListId__c,ChecklistItem__c,Status__c,Comments__c FROM WorkOrderChecklists__r)
        FROM WorkOrder
        WHERE AccountId =: idAccount];
        return listWorkOrders;
    }

    public static List<Case> getListCases(String idAccount){
        return null;
    }

    public static List<ServiceAppointment> getListServiceAppointment(String idAccount){
        return [
            SELECT Id, ActualDuration, ActualEndTime, ActualStartTime, Address,FSL__Appointment_Grade__c, AppointmentNumber, ArrivalWindowEndTime,
                ArrivalWindowStartTime, Asset__c, Technician__c, BusinessUnit__c, ContactId, CustomerRating__c, Customer_Rating_Symbol__c,
                FM_Delayed_by__c, Description, DueDate, Duration, FSL__Duration_In_Minutes__c, DurationType, EarliestStartTime, FSL__GanttColor__c,
                FSL__Gantt_Display_Date__c, FSL__GanttIcon__c, FSL__InternalSLRGeolocation__c, FSL__MDS_Calculated_length__c, FSL__MDT_Operational_Time__c,
                Old_Job_Ref__c, ParentRecordStatusCategory, ParentRecordType, PaymentStatus__c, FSL__Related_Service__c, Resource_Count__c, FSL__Schedule_Mode__c,
                SchedEndTime, SchedStartTime, FSL__Scheduling_Policy_Used__c, ServiceNote, ServiceTerritoryId,ServiceTerritoryFormula__c, SLA__c
            FROM ServiceAppointment
            WHERE AccountId =:idAccount
        ];

    }
    public static  Map<String,String> getRecordType(String objectAPIName){
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        Map<String,String> mapofWorkOrderRecordTypeNameandId = new Map<String,String>();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            mapofWorkOrderRecordTypeNameandId.put(info.getName(),info.getRecordTypeId());
        }
        return mapofWorkOrderRecordTypeNameandId;
    }
}