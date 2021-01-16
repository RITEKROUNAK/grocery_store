part of 'inventory_bloc.dart';

@immutable
abstract class InventoryState {}

class InventoryInitial extends InventoryState {
  @override
  String toString() => 'InventoryInitial';
}

class LowInventoryInitial extends InventoryState {
  @override
  String toString() => 'LowInventoryInitial';
}

class AllCategoriesInitial extends InventoryState {
  @override
  String toString() => 'AllCategoriesInitial';
}

class GetLowInventoryProductsInProgressState extends InventoryState {
  @override
  String toString() => 'GetLowInventoryProductsInProgressState';
}

class GetLowInventoryProductsFailedState extends InventoryState {
  @override
  String toString() => 'GetLowInventoryProductsFailedState';
}

class GetLowInventoryProductsCompletedState extends InventoryState {
  final List<Product> products;

  GetLowInventoryProductsCompletedState({
    @required this.products,
  });

  @override
  String toString() => 'GetLowInventoryProductsCompletedState';
}

class GetAllCategoriesInProgressState extends InventoryState {
  @override
  String toString() => 'GetAllCategoriesInProgressState';
}

class GetAllCategoriesFailedState extends InventoryState {
  @override
  String toString() => 'GetAllCategoriesFailedState';
}

class GetAllCategoriesCompletedState extends InventoryState {
  final List<Category> categories;

  GetAllCategoriesCompletedState({
    @required this.categories,
  });

  @override
  String toString() => 'GetAllCategoriesCompletedState';
}

class GetInventoryAnalyticsCompletedState extends InventoryState {
  final InventoryAnalytics inventoryAnalytics;

  GetInventoryAnalyticsCompletedState({
    @required this.inventoryAnalytics,
  });

  String toString() => 'GetInventoryAnalyticsCompletedState';
}

class GetInventoryAnalyticsFailedState extends InventoryState {
  String toString() => 'GetInventoryAnalyticsFailedState';
}

class GetInventoryAnalyticsInProgressState extends InventoryState {
  String toString() => 'GetInventoryAnalyticsInProgressState';
}

class UpdateInventoryAnalyticsState extends InventoryState {
  final InventoryAnalytics inventoryAnalytics;

  UpdateInventoryAnalyticsState(this.inventoryAnalytics);

  String toString() => 'UpdateInventoryAnalyticsState';
}

class UpdateLowInventoryProductInProgressState extends InventoryState {
  @override
  String toString() => 'UpdateLowInventoryProductInProgressState';
}

class UpdateLowInventoryProductFailedState extends InventoryState {
  @override
  String toString() => 'UpdateLowInventoryProductFailedState';
}

class UpdateLowInventoryProductCompletedState extends InventoryState {
  @override
  String toString() => 'UpdateLowInventoryProductCompletedState';
}

class AddNewCategoryInProgressState extends InventoryState {
  @override
  String toString() => 'AddNewCategoryInProgressState';
}

class AddNewCategoryFailedState extends InventoryState {
  @override
  String toString() => 'AddNewCategoryFailedState';
}

class AddNewCategoryCompletedState extends InventoryState {
  @override
  String toString() => 'AddNewCategoryCompletedState';
}

class EditCategoryInProgressState extends InventoryState {
  @override
  String toString() => 'EditCategoryInProgressState';
}

class EditCategoryFailedState extends InventoryState {
  @override
  String toString() => 'EditCategoryFailedState';
}

class EditCategoryCompletedState extends InventoryState {
  @override
  String toString() => 'EditCategoryCompletedState';
}

class DeleteCategoryInProgressState extends InventoryState {
  @override
  String toString() => 'DeleteCategoryInProgressState';
}

class DeleteCategoryFailedState extends InventoryState {
  @override
  String toString() => 'DeleteCategoryFailedState';
}

class DeleteCategoryCompletedState extends InventoryState {
  @override
  String toString() => 'DeleteCategoryCompletedState';
}
