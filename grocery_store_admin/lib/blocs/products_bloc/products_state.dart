part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitialState extends ProductsState {
  @override
  String toString() => 'ProductsInitialState';
}

class AllProductsInitialState extends ProductsState {
  @override
  String toString() => 'AllProductsInitialState';
}

class ActiveProductsInitialState extends ProductsState {
  @override
  String toString() => 'ActiveProductsInitialState';
}

class InactiveProductsInitialState extends ProductsState {
  @override
  String toString() => 'InactiveProductsInitialState';
}

class TrendingProductsInitialState extends ProductsState {
  @override
  String toString() => 'TrendingProductsInitialState';
}

class FeaturedProductsInitialState extends ProductsState {
  @override
  String toString() => 'FeaturedProductsInitialState';
}

class AddNewProductInitialState extends ProductsState {
  @override
  String toString() => 'AddNewProductInitialState';
}

class EditProductInitialState extends ProductsState {
  @override
  String toString() => 'EditProductInitialState';
}

class GetAllProductsInProgressState extends ProductsState {
  @override
  String toString() => 'GetAllProductsInProgressState';
}

class GetAllProductsFailedState extends ProductsState {
  @override
  String toString() => 'GetAllProductsFailedState';
}

class GetAllProductsCompletedState extends ProductsState {
  final List<Product> products;

  GetAllProductsCompletedState({
    @required this.products,
  });

  @override
  String toString() => 'GetAllProductsCompletedState';
}

class GetProductAnalyticsCompletedState extends ProductsState {
  final ProductAnalytics productAnalytics;

  GetProductAnalyticsCompletedState({
    @required this.productAnalytics,
  });

  String toString() => 'GetProductAnalyticsCompletedState';
}

class GetProductAnalyticsFailedState extends ProductsState {
  String toString() => 'GetProductAnalyticsFailedState';
}

class GetProductAnalyticsInProgressState extends ProductsState {
  String toString() => 'GetProductAnalyticsInProgressState';
}

class GetActiveProductsInProgressState extends ProductsState {
  @override
  String toString() => 'GetActiveProductsInProgressState';
}

class GetActiveProductsFailedState extends ProductsState {
  @override
  String toString() => 'GetActiveProductsFailedState';
}

class GetActiveProductsCompletedState extends ProductsState {
  final List<Product> products;

  GetActiveProductsCompletedState({
    @required this.products,
  });

  @override
  String toString() => 'GetActiveProductsCompletedState';
}

class GetInactiveProductsInProgressState extends ProductsState {
  @override
  String toString() => 'GetInactiveProductsInProgressState';
}

class GetInactiveProductsFailedState extends ProductsState {
  @override
  String toString() => 'GetInactiveProductsFailedState';
}

class GetInactiveProductsCompletedState extends ProductsState {
  final List<Product> products;

  GetInactiveProductsCompletedState({
    @required this.products,
  });

  @override
  String toString() => 'GetInactiveProductsCompletedState';
}

class GetTrendingProductsInProgressState extends ProductsState {
  @override
  String toString() => 'GetTrendingProductsInProgressState';
}

class GetTrendingProductsFailedState extends ProductsState {
  @override
  String toString() => 'GetTrendingProductsFailedState';
}

class GetTrendingProductsCompletedState extends ProductsState {
  final List<Product> products;

  GetTrendingProductsCompletedState({
    @required this.products,
  });

  @override
  String toString() => 'GetTrendingProductsCompletedState';
}

class GetFeaturedProductsInProgressState extends ProductsState {
  @override
  String toString() => 'GetFeaturedProductsInProgressState';
}

class GetFeaturedProductsFailedState extends ProductsState {
  @override
  String toString() => 'GetFeaturedProductsFailedState';
}

class GetFeaturedProductsCompletedState extends ProductsState {
  final List<Product> products;

  GetFeaturedProductsCompletedState({
    @required this.products,
  });

  @override
  String toString() => 'GetFeaturedProductsCompletedState';
}

class AddNewProductInProgressState extends ProductsState {
  @override
  String toString() => 'AddNewProductInProgressState';
}

class AddNewProductFailedState extends ProductsState {
  @override
  String toString() => 'AddNewProductFailedState';
}

class AddNewProductCompletedState extends ProductsState {
  @override
  String toString() => 'AddNewProductCompletedState';
}

class EditProductInProgressState extends ProductsState {
  @override
  String toString() => 'EditProductInProgressState';
}

class EditProductFailedState extends ProductsState {
  @override
  String toString() => 'EditProductFailedState';
}

class EditProductCompletedState extends ProductsState {
  @override
  String toString() => 'EditProductCompletedState';
}

class DeleteProductInProgressState extends ProductsState {
  @override
  String toString() => 'DeleteProductInProgressState';
}

class DeleteProductFailedState extends ProductsState {
  @override
  String toString() => 'DeleteProductFailedState';
}

class DeleteProductCompletedState extends ProductsState {
  @override
  String toString() => 'DeleteProductCompletedState';
}
