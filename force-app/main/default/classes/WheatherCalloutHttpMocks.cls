@isTest
public class WheatherCalloutHttpMocks implements HttpCalloutMock {
  private static final String URL = 'https://oktana-e0-dev-ed.develop.my.site.com/tech/services/apexrest/WeatherService/';
  public HTTPResponse respond(HTTPRequest req) {
    HttpResponse response = new HttpResponse();
    if (req.getEndpoint().contains('current')) {
      response.setStatusCode(200);
      response.setStatus('Success');
      response.setBody(
        '{"destination": "Hawaii", "temperature": "28", "description": "Sunny", "humidity": "65%"}'
      );
    } else if (req.getEndpoint().contains('forecast')) {
      response.setStatusCode(200);
      response.setStatus('Success');
      response.setBody(
        '[{"day": "Monday","temperature": "28", "description": "Sunny"}, {"day": "Tuesday","temperature": "27", "description": "Partly Cloudy"},{"day": "Wednesday","temperature": "26","description": "Rainy" },{"day": "Thursday","temperature": "25","description": "Thunderstorms"},{"day": "Friday","temperature": "28","description": "Sunny"}]'
      );
    } else if (req.getEndpoint().contains('errorTest')) {
      response.setStatusCode(500);
      response.setStatus('error');
      response.setBody(
        '{"error": "An error occurred while processing your request."}'
      );
    }
    return response;
  }
}
