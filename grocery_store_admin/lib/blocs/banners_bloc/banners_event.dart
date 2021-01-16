part of 'banners_bloc.dart';

@immutable
abstract class BannersEvent {}

class GetAllBannersEvent extends BannersEvent {
  @override
  String toString() => 'GetAllBannersEvent';
}

class UpdateBannersEvent extends BannersEvent {
  final Map bannersMap;

  UpdateBannersEvent(this.bannersMap);
  @override
  String toString() => 'UpdateBannersEvent';
}

