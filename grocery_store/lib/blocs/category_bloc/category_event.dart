part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {
  @override
  String toString() => 'LoadCategoriesEvent';
}
