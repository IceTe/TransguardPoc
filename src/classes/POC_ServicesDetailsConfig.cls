@RestResource(urlMapping='/v1/service/detail')
global with sharing class POC_ServicesDetailsConfig {
   public  static Boolean isOk = true;
    @HttpGet
    global static void serviceDetails(){
        final RestRequest req = RestContext.request;
        final RestResponse response = RestContext.response;
      
        try
         {
            Map<String, String> paramsMap = Req.params;
            String resp = execute(paramsMap.get('service'), isOk);
            response.responseBody = Blob.valueOf(resp);
            response.statusCode =(isOk)?200:400;
        } 
        catch (Exception e) {
              
        } 

    }
    public static String  execute(String idService, Boolean isOk){
          String response ;
          if(!String.isEmpty(idService)){
            List<TGConfiguration__c> tgs = ManageService.getDetailsServiceById(idService);
            if(tgs != null && tgs.size() > 0 ){
                List<ManageService.DetailsServiceOk> result = ManageService.formatResponseOk(tgs);
                response = JSON.serialize(result);
                
            }
            else {
                 ManageService.DetailsServiceKO responseKo = new  ManageService.DetailsServiceKO('Invalid_Service', 'Invalide service value');
                 response = JSON.serialize(responseKo);
                 isOk = false;
            }
          }
          return response;
    }
   
}