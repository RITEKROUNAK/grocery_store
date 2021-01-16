class Config {
//TODO: change the currency and country prefix as per your need
  String currency = 'Rs.';
  String countryMobileNoPrefix = "+91";
  String currencyCode = 'inr';

  //stripe api keys
  String apiBase = 'https://api.stripe.com';

  //dynamic link url
  String urlPrefix = 'https://grocerydemo.page.link';

  String packageName = 'com.b2x.grocery_store_delivery';
  String mainAppPackage = 'com.b2x.grocery_store';

  String appStoreLink = '';
  String playStoreLink =
      'https://play.google.com/store/apps/details?id=com.b2x.grocery_store';

  //TODO: set your low inventory threshold
  int lowInventoryNo = 20;

  List<String> cancelOrderReason = [
    'Customer is not available',
    'Customer is not responding',
    'Customer is not accepting the order',
    'I can\'t deliver the order',
    'Other',
  ];
}
