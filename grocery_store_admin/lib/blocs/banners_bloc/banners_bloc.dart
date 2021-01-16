import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/manage_users_bloc.dart';
import 'package:ecommerce_store_admin/models/banner.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'banners_event.dart';
part 'banners_state.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  final UserDataRepository userDataRepository;

  BannersBloc({@required this.userDataRepository}) : super(null);
  @override
  Stream<BannersState> mapEventToState(
    BannersEvent event,
  ) async* {
    if (event is GetAllBannersEvent) {
      yield* mapGetAllBannersEventToState();
    }
    if (event is UpdateBannersEvent) {
      yield* mapUpdateBannersEventToState(event.bannersMap);
    }
  }

  Stream<BannersState> mapGetAllBannersEventToState() async* {
    yield GetAllBannersInProgressState();
    try {
      Map bannerMap = await userDataRepository.getAllBanners();
      if (bannerMap != null) {
        yield GetAllBannersCompletedState(bannerMap);
      } else {
        yield GetAllBannersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllBannersFailedState();
    }
  }

  Stream<BannersState> mapUpdateBannersEventToState(Map bannersMap) async* {
    yield UpdateBannersInProgressState();
    try {
      bool isUpdated = await userDataRepository.updateBanners(bannersMap);
      if (isUpdated) {
        yield UpdateBannersCompletedState();
      } else {
        yield UpdateBannersFailedState();
      }
    } catch (e) {
      print(e);
      yield UpdateBannersFailedState();
    }
  }
}
