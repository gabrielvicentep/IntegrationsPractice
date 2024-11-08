public with sharing class WheatherCallouts {
  private static final String URL = 'https://oktana-e0-dev-ed.develop.my.site.com/tech/services/apexrest/WeatherService/';
  private static final String FORECAST = 'forecast';
  private static final String CURRENT = 'current';

  @auraEnabled(cacheable=true)
  public static List<WheatherConditions> getWheather(
    String type,
    String destination
  ) {
    WheatherConditions wCond = new WheatherConditions();
    List<WheatherConditions> wCondList = new List<WheatherConditions>();
    String errorMessage = '';
    try {
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setMethod('GET');
      request.setTimeout(120000);
      if (Test.isRunningTest() && destination == 'errorTest') {
        request.setEndpoint(URL + '/' + 'errorTest');
      } else {
        request.setEndpoint(URL + '/' + type + '/' + destination);
      }
      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 200) {
        if (type == CURRENT) {
          wCond = (WheatherConditions) JSON.deserialize(
            response.getBody(),
            WheatherConditions.class
          );
          wCondList.add(wCond);
        } else if (type == FORECAST) {
          wCondList = (List<WheatherConditions>) JSON.deserialize(
            response.getBody(),
            List<WheatherConditions>.class
          );
        }
      } else if (response.getStatusCode() == 500) {
        errorMessage = response.getBody();
        throw new AuraHandledException(
          'Internal Server Error: ' + errorMessage
        );
      }
    } catch (Exception e) {
      System.debug('Error: ' + errorMessage);
      throw new AuraHandledException('Internal Server Error: ' + errorMessage);
    }
    return wCondList;
  }

  public class WheatherConditions {
    @auraEnabled
    public String day { get; set; }
    @auraEnabled
    public String destination { get; set; }
    @auraEnabled
    public String temperature { get; set; }
    @auraEnabled
    public String description { get; set; }
    @auraEnabled
    public String humidity { get; set; }
  }
}
