import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'inventory_bloc.dart';

class AllCategoriesBloc extends Bloc<InventoryEvent, InventoryState> {
  final UserDataRepository userDataRepository;

  AllCategoriesBloc({this.userDataRepository}) : super(null);

  StreamSubscription allCategoriesSubscription;

  @override
  Future<void> close() {
    print('Closing All Categories BLOC');
    allCategoriesSubscription?.cancel();
    return super.close();
  }

  InventoryState get initialState => AllCategoriesInitial();

  @override
  Stream<InventoryState> mapEventToState(
    InventoryEvent event,
  ) async* {
    if (event is GetAllCategoriesEvent) {
      yield* mapGetAllCategoriesEventToState();
    }
    if (event is UpdateGetAllCategoriesEvent) {
      yield* mapUpdateGetAllCategoriesEventToState(event.categories);
    }
    if (event is AddNewCategoryEvent) {
      yield* mapAddNewCategoryEventToState(event.category);
    }
    if (event is EditCategoryEvent) {
      yield* mapEditCategoryEventToState(event.category);
    }
    if (event is DeleteCategoryEvent) {
      yield* mapDeleteCategoryEventToState(event.categoryId);
    }
  }

  Stream<InventoryState> mapUpdateGetAllCategoriesEventToState(
      List<Category> categories) async* {
    yield GetAllCategoriesCompletedState(categories: categories);
  }

  Stream<InventoryState> mapGetAllCategoriesEventToState() async* {
    yield GetAllCategoriesInProgressState();
    try {
      List<Category> categories = await userDataRepository.getAllCategories();
      if (categories != null) {
        yield GetAllCategoriesCompletedState(categories: categories);
      } else {
        yield GetAllCategoriesFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllCategoriesFailedState();
    }
  }

  Stream<InventoryState> mapAddNewCategoryEventToState(
      Map<dynamic, dynamic> category) async* {
    yield AddNewCategoryInProgressState();
    try {
      bool isAdded = await userDataRepository.addNewCategory(category);
      if (isAdded) {
        yield AddNewCategoryCompletedState();
      } else {
        yield AddNewCategoryFailedState();
      }
    } catch (e) {
      print(e);
      yield AddNewCategoryFailedState();
    }
  }

  Stream<InventoryState> mapEditCategoryEventToState(
      Map<dynamic, dynamic> category) async* {
    yield EditCategoryInProgressState();
    try {
      bool isEdited = await userDataRepository.editCategory(category);
      if (isEdited) {
        yield EditCategoryCompletedState();
      } else {
        yield EditCategoryFailedState();
      }
    } catch (e) {
      print(e);
      yield EditCategoryFailedState();
    }
  }

  Stream<InventoryState> mapDeleteCategoryEventToState(
      String categoryId) async* {
    yield DeleteCategoryInProgressState();
    try {
      bool isDeleted = await userDataRepository.deleteCategory(categoryId);
      if (isDeleted) {
        yield DeleteCategoryCompletedState();
      } else {
        yield DeleteCategoryFailedState();
      }
    } catch (e) {
      print(e);
      yield DeleteCategoryFailedState();
    }
  }
}
