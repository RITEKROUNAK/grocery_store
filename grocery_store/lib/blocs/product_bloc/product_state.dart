part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {
  @override
  String toString() => 'ProductInitialState';
}

class InitialSimilarProductState extends ProductState {
  @override
  String toString() => 'InitialSimilarProductState';
}

class InitialReportProductState extends ProductState {
  @override
  String toString() => 'InitialReportProductState';
}

class InitialTrendingProductState extends ProductState {
  @override
  String toString() => 'InitialTrendingProductState';
}

class InitialFeaturedProductState extends ProductState {
  @override
  String toString() => 'InitialFeaturedProductState';
}

class InitialWishlistProductState extends ProductState {
  @override
  String toString() => 'InitialWishlistProductState';
}

class InitialWishlistCheckState extends ProductState {
  @override
  String toString() => 'InitialWishlistCheckState';
}

class InitialPostQuestionState extends ProductState {
  @override
  String toString() => 'InitialPostQuestionState';
}

class InitialRateProductState extends ProductState {
  @override
  String toString() => 'InitialRateProductState';
}

class InitialIncrementViewState extends ProductState {
  @override
  String toString() => 'InitialIncrementViewState';
}

class LoadProductFailedState extends ProductState {
  @override
  String toString() => 'LoadProductFailedState';
}

class LoadProductInProgressState extends ProductState {
  @override
  String toString() => 'LoadProductInProgressState';
}

class LoadProductCompletedState extends ProductState {
  final Product product;

  LoadProductCompletedState(this.product);
  @override
  String toString() => 'LoadProductCompletedState';
}

class LoadTrendingProductsFailedState extends ProductState {
  @override
  String toString() => 'LoadTrendingProductsFailedState';
}

class LoadTrendingProductsInProgressState extends ProductState {
  @override
  String toString() => 'LoadTrendingProductsInProgressState';
}

class LoadTrendingProductsCompletedState extends ProductState {
  final List<Product> productList;

  LoadTrendingProductsCompletedState(this.productList);
  @override
  String toString() => 'LoadTrendingProductsCompletedState';
}

class LoadFeaturedProductsFailedState extends ProductState {
  @override
  String toString() => 'LoadFeaturedProductsFailedState';
}

class LoadFeaturedProductsInProgressState extends ProductState {
  @override
  String toString() => 'LoadFeaturedProductsInProgressState';
}

class LoadFeaturedProductsCompletedState extends ProductState {
  final List<Product> productList;

  LoadFeaturedProductsCompletedState(this.productList);
  @override
  String toString() => 'LoadFeaturedProductsCompletedState';
}

class LoadSimilarProductsFailedState extends ProductState {
  @override
  String toString() => 'LoadSimilarProductsFailedState';
}

class LoadSimilarProductsInProgressState extends ProductState {
  @override
  String toString() => 'LoadSimilarProductsInProgressState';
}

class LoadSimilarProductsCompletedState extends ProductState {
  final List<Product> productList;

  LoadSimilarProductsCompletedState(this.productList);
  @override
  String toString() => 'LoadSimilarProductsCompletedState';
}

//category states
class InitialCategoryProductsState extends ProductState {
  @override
  String toString() => 'InitialCategoryProductsState';
}

class LoadCategoryProductsInProgressState extends ProductState {
  @override
  String toString() => 'LoadCategoryProductsInProgressState';
}

class LoadCategoryProductsFailedState extends ProductState {
  @override
  String toString() => 'LoadCategoryProductsFailedState';
}

class LoadCategoryProductsCompletedState extends ProductState {
  final List<Product> productList;

  LoadCategoryProductsCompletedState(this.productList);

  @override
  String toString() => 'LoadCategoryProductsCompletedState';
}

class LoadWishlistProductFailedState extends ProductState {
  @override
  String toString() => 'LoadWishlistProductFailedState';
}

class LoadWishlistProductInProgressState extends ProductState {
  @override
  String toString() => 'LoadWishlistProductInProgressState';
}

class LoadWishlistProductCompletedState extends ProductState {
  final List<Product> productList;

  LoadWishlistProductCompletedState(this.productList);
  @override
  String toString() => 'LoadWishlistProductCompletedState';
}

class AddToWishlistInProgressState extends ProductState {
  @override
  String toString() => 'AddToWishlistInProgressState';
}

class AddToWishlistFailedState extends ProductState {
  @override
  String toString() => 'AddToWishlistFailedState';
}

class AddToWishlistCompletedState extends ProductState {
  @override
  String toString() => 'AddToWishlistCompletedState';
}

class RemoveFromWishlistInProgressState extends ProductState {
  @override
  String toString() => 'RemoveFromWishlistInProgressState';
}

class RemoveFromWishlistFailedState extends ProductState {
  @override
  String toString() => 'RemoveFromWishlistFailedState';
}

class RemoveFromWishlistCompletedState extends ProductState {
  @override
  String toString() => 'RemoveFromWishlistCompletedState';
}

class GetWishlistProductsState extends ProductState {
  @override
  String toString() => 'GetWishlistProductsState';
}

class GetWishlistProductsCompletedState extends ProductState {
  final List wishlistProducts;
  GetWishlistProductsCompletedState(this.wishlistProducts);

  @override
  String toString() => 'GetWishlistProductsCompletedState';
}

class GetWishlistProductsFailedState extends ProductState {
  @override
  String toString() => 'GetWishlistProductsFailedState';
}

class GetWishlistProductsinProgressState extends ProductState {
  @override
  String toString() => 'GetWishlistProductsinProgressState';
}

class PostQuestionCompletedState extends ProductState {
  @override
  String toString() => 'PostQuestionCompletedState';
}

class PostQuestionFailedState extends ProductState {
  @override
  String toString() => 'PostQuestionFailedState';
}

class PostQuestionInProgressState extends ProductState {
  @override
  String toString() => 'PostQuestioninProgressState';
}

class RateProductCompletedState extends ProductState {
  @override
  String toString() => 'RateProductCompletedState';
}

class RateProductFailedState extends ProductState {
  @override
  String toString() => 'RateProductFailedState';
}

class RateProductInProgressState extends ProductState {
  @override
  String toString() => 'RateProductinProgressState';
}

class CheckRateProductCompletedState extends ProductState {
  final Review review;
  final String result;

  CheckRateProductCompletedState(this.review, this.result);
  @override
  String toString() => 'CheckRateProductCompletedState';
}

class CheckRateProductFailedState extends ProductState {
  @override
  String toString() => 'CheckRateProductFailedState';
}

class CheckRateProductInProgressState extends ProductState {
  @override
  String toString() => 'CheckRateProductinProgressState';
}

class IncrementViewCompletedState extends ProductState {
  @override
  String toString() => 'IncrementViewCompletedState';
}

class IncrementViewFailedState extends ProductState {
  @override
  String toString() => 'IncrementViewFailedState';
}

class IncrementViewInProgressState extends ProductState {
  @override
  String toString() => 'IncrementViewinProgressState';
}

class ReportProductCompletedState extends ProductState {
  @override
  String toString() => 'ReportProductCompletedState';
}

class ReportProductFailedState extends ProductState {
  @override
  String toString() => 'ReportProductFailedState';
}

class ReportProductInProgressState extends ProductState {
  @override
  String toString() => 'ReportProductinProgressState';
}
