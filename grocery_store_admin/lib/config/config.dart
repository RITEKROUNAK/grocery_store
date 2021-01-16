class Config {
//TODO: change the currency and country prefix as per your need
  String currency = 'Rs.';
  String countryMobileNoPrefix = "+91";

  //stripe api keys
  String apiBase = 'https://api.stripe.com';

  String currencyCode = 'inr';

  //dynamic link url //TODO: change this to yours
  String urlPrefix = 'https://grocerydemo.page.link';

//TODO:change this package name to yours
  String packageName = 'com.b2x.grocery_store_admin';

  //TODO: set your low inventory threshold
  int lowInventoryNo = 20;

  //TODO: change the url to yours
  //to see your url go to Firebase console -> Functions and check url for "updateAnsweredMessageAnalytics"
  String updateMessagesUrl =
      'YOUR_URL_HERE'; //it should look something like : https://us-********-**********.cloudfunctions.net/updateAnsweredMessageAnalytics

  List<String> cancelOrderReasons = [
    'Product is not available',
    'Product is out of stock',
    'Product is in high demand',
    'Don\'t want to specify',
    'Other',
  ];
}
