@isTest
private class WheatherCalloutsTest {
  @isTest
  static void getCurrentWheatherTest() {
    List<WheatherCallouts.WheatherConditions> current = new List<WheatherCallouts.WheatherConditions>();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new WheatherCalloutHttpMocks());
    current = WheatherCallouts.getWheather('current', 'Hawaii');
    Test.stopTest();

    System.Assert.areEqual('Hawaii', current[0].destination);
    System.Assert.areEqual('28', current[0].temperature);
    System.Assert.areEqual('Sunny', current[0].description);
    System.Assert.areEqual('65%', current[0].humidity);
  }
  @isTest
  static void getWheatherForecast() {
    List<WheatherCallouts.WheatherConditions> forecast = new List<WheatherCallouts.WheatherConditions>();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new WheatherCalloutHttpMocks());
    forecast = WheatherCallouts.getWheather('forecast', 'Hawaii');
    Test.stopTest();
    System.Assert.areEqual(5, forecast.size());
    System.Assert.areEqual('Monday', forecast[0].day);
  }
  @isTest
  static void getWheatherCurrentErrorTest() {
    Test.startTest();
    try {
      Test.setMock(HttpCalloutMock.class, new WheatherCalloutHttpMocks());
      WheatherCallouts.getWheather('current', 'errorTest');
    } catch (AuraHandledException ex) {
      System.Assert.areEqual('Script-thrown exception', ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  static void getWheatherForecastErrorTest() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new WheatherCalloutHttpMocks());

    try {
      WheatherCallouts.getWheather('forecast', 'errorTest');
    } catch (AuraHandledException ex) {
      System.Assert.areEqual('Script-thrown exception', ex.getMessage());
    }
    Test.stopTest();
  }
}
