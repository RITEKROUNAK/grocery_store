part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class GetAllProductsEvent extends ProductsEvent {
  @override
  String toString() => 'GetAllProductsEvent';
}

class GetActiveProductsEvent extends ProductsEvent {
  @override
  String toString() => 'GetActiveProductsEvent';
}

class GetInactiveProductsEvent extends ProductsEvent {
  @override
  String toString() => 'GetInactiveProductsEvent';
}

class GetTrendingProductsEvent extends ProductsEvent {
  @override
  String toString() => 'GetTrendingProductsEvent';
}

class GetFeaturedProductsEvent extends ProductsEvent {
  @override
  String toString() => 'GetFeaturedProductsEvent';
}

class GetProductAnalyticsEvent extends ProductsEvent {
  String toString() => 'GetProductAnalyticsEvent';
}

class UpdateProductAnalyticsEvent extends ProductsEvent {
  final ProductAnalytics productAnalytics;
  UpdateProductAnalyticsEvent({@required this.productAnalytics});

  @override
  String toString() => 'UpdateProductAnalyticsEvent';
}

class AddNewProductEvent extends ProductsEvent {
  final Map<dynamic, dynamic> product;

  AddNewProductEvent(this.product);

  @override
  String toString() => 'AddNewProductEvent';
}

class EditProductEvent extends ProductsEvent {
  final Map<dynamic, dynamic> product;

  EditProductEvent(this.product);

  @override
  String toString() => 'EditProductEvent';
}

class DeleteProductEvent extends ProductsEvent {
  final String id;

  DeleteProductEvent(this.id);

  @override
  String toString() => 'DeleteProductEvent';
}
