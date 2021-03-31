@RestResource(urlMapping='/v1/accountManagement/*')
global with sharing class AccountManagement {

    @HttpGet
    global static Map<String, List<SObject>> doGetAccount(){
        Map<String, String> paramsMap = RestContext.request.params;
        //String accountId = paramsMap.get('Id');
        String email = paramsMap.get('email');
        Map<String, List<SObject>> mapData = new Map<String, List<SObject>>();
        List<Account> listAccounts = new List<Account>();
       /* List<Account> listAccounts = new List<Account>();
        if (String.isNotBlank(accountId)) {
            listAccounts = [SELECT Id, Name, FirstName, AccountNumber, Credit_Balance__c, RecordTypeId, RecordType.DeveloperName FROM Account WHERE Id=: accountId];
        } else {
            listAccounts = [SELECT Id, Name, AccountNumber, Credit_Balance__c, RecordTypeId, RecordType.DeveloperName FROM Account LIMIT 10];
        }
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, listAccounts);*/
        Account acc = POC_Query.getAllAccountData(email);
        listAccounts.add(acc);
        List<WorkOrder> listWorkOrders = POC_Query.getWorkOrders(acc.Id);
        mapData.put('account',listAccounts);
        mapData.put('listWorkOrders', listWorkOrders);
        List<ServiceAppointment> listServiceAppointment = POC_Query.getListServiceAppointment(acc.Id);
        mapData.put('listWorkTypes', listServiceAppointment);
        return mapData;
    }

    @HttpDelete
    global static String doDeleteAccount(){
        Map<String, String> paramsMap = RestContext.request.params;
        String bookId = paramsMap.get('Id');
        if (bookId == null) {
            return 'Id must be spicified';
        }
        List<Account> listAccounts = new List<Account>();
        listAccounts = [SELECT Id, Name, AccountNumber, Credit_Balance__c, RecordTypeId, RecordType.DeveloperName FROM Account WHERE Id=: bookId];
        System.debug('***************** '+listAccounts);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE, listAccounts);
        if(!listAccounts.isEmpty()){
            delete listAccounts[0];

        }
        return 'Record Deleted !';
    }

    @HttpPost
    global static Account doDeleteAccount(String name, String industry){
        Account acc = new Account(Name = name, Industry	= industry);
        insert acc;
        return acc;
    }
    @HttpPut
    global static Account doUpdateAccount(String name, String industry){
        Map<String, String> paramsMap = RestContext.request.params;
        String accountId = paramsMap.get('Id');
        if (accountId == null) {
            return null;
        }
        Account acc = new Account(Name = name, Industry	= industry, Id=accountId);
        update acc;
        return acc;
    }


}