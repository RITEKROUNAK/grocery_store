part of 'banners_bloc.dart';

@immutable
abstract class BannersState {}

class BannersInitial extends BannersState {}

class GetAllBannersCompletedState extends BannersState {
  final Map bannerMap;

  GetAllBannersCompletedState(this.bannerMap);

  String toString() => 'GetAllBannersCompletedState';
}

class GetAllBannersFailedState extends BannersState {
  String toString() => 'GetAllBannersFailedState';
}

class GetAllBannersInProgressState extends BannersState {
  String toString() => 'GetAllBannersInProgressState';
}

class UpdateBannersCompletedState extends BannersState {
  String toString() => 'UpdateBannersCompletedState';
}

class UpdateBannersFailedState extends BannersState {
  String toString() => 'UpdateBannersFailedState';
}

class UpdateBannersInProgressState extends BannersState {
  String toString() => 'UpdateBannersInProgressState';
}
