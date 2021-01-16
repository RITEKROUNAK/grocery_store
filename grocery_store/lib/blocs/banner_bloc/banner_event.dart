part of 'banner_bloc.dart';

@immutable
abstract class BannerEvent {}

class LoadBannersEvent extends BannerEvent {
  @override
  String toString() => 'LoadBannersEvent';
}

class LoadBannerAllProductsEvent extends BannerEvent {
  final String category;

  LoadBannerAllProductsEvent(this.category);
  @override
  String toString() => 'LoadBannerAllProductsEvent';
}
