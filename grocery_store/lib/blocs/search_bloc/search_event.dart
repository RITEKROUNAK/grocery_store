part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class FirstSearchEvent extends SearchEvent {
  final String searchWord;

  FirstSearchEvent(this.searchWord);
  @override
  String toString() => 'FirstSearchEvent';
}

class NewSearchEvent extends SearchEvent {
  final String searchWord;
  final List<Product> products;

  NewSearchEvent(this.searchWord, this.products);
  @override
  String toString() => 'NewSearchEvent';
}
