part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class LoadProductEvent extends ProductEvent {
  final String id;

  LoadProductEvent(this.id);
  @override
  String toString() => 'LoadProductEvent';
}

class LoadTrendingProductsEvent extends ProductEvent {
  @override
  String toString() => 'LoadTrendingProductsEvent';
}

class LoadFeaturedProductsEvent extends ProductEvent {
  @override
  String toString() => 'LoadFeaturedProductsEvent';
}

class LoadSimilarProductsEvent extends ProductEvent {
  final String category;
  final String subCategory;
  final String productId;

  LoadSimilarProductsEvent({this.category, this.subCategory, this.productId});
  @override
  String toString() => 'LoadSimilarProductsEvent';
}

class LoadCategoryProductsEvent extends ProductEvent {
  final String category;

  LoadCategoryProductsEvent({
    this.category,
  });

  @override
  String toString() => 'LoadCategoryProductsEvent';
}

class AddToWishlistEvent extends ProductEvent {
  final String productId;
  final String uid;

  AddToWishlistEvent(this.productId, this.uid);

  @override
  String toString() => 'AddToWishlistEvent';
}

class RemoveFromWishlistEvent extends ProductEvent {
  final String productId;
  final String uid;

  RemoveFromWishlistEvent(this.productId, this.uid);

  @override
  String toString() => 'RemoveFromWishlistEvent';
}

class InitializeWishlistEvent extends ProductEvent {
  @override
  String toString() => 'InitializeWishlistEvent';
}

class LoadWishlistProductEvent extends ProductEvent {
  final String uid;

  LoadWishlistProductEvent(this.uid);

  @override
  String toString() => 'LoadWishlistProductEvent';
}

class PostQuestionEvent extends ProductEvent {
  final String uid;
  final String productId;
  final String question;

  PostQuestionEvent(this.uid, this.productId, this.question);

  @override
  String toString() => 'PostQuestionEvent';
}

class RateProductEvent extends ProductEvent {
  final String uid;
  final String productId;
  final String rating;
  final String review;
  final String result;
  final Product product;

  RateProductEvent(
    this.uid,
    this.productId,
    this.rating,
    this.review,
    this.result,
    this.product,
  );

  @override
  String toString() => 'RateProductEvent';
}

class CheckRateProductEvent extends ProductEvent {
  final String uid;
  final String productId;
  final Product product;

  CheckRateProductEvent(this.uid, this.productId, this.product);

  @override
  String toString() => 'CheckRateProductEvent';
}

class IncrementViewEvent extends ProductEvent {
  final String productId;

  IncrementViewEvent(this.productId);

  @override
  String toString() => 'IncrementViewEvent';
}

class ReportProductEvent extends ProductEvent {
  final String productId;
  final String reportDescription;
  final String uid;

  ReportProductEvent(this.productId, this.reportDescription, this.uid);

  @override
  String toString() => 'ReportProductEvent';
}
