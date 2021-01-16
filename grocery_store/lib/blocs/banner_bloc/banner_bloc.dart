import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/banner.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final UserDataRepository userDataRepository;

  BannerBloc({this.userDataRepository}) : super(null);

  BannerState get initialState => BannerInitialState();

  @override
  Stream<BannerState> mapEventToState(
    BannerEvent event,
  ) async* {
    if (event is LoadBannersEvent) {
      yield* mapLoadBannersEventToState();
    }

  }

  Stream<BannerState> mapLoadBannersEventToState() async* {
    yield LoadBannersInProgressState();

    try {
      Banner banner = await userDataRepository.getBanners();
      if (banner != null) {
        print('inside banner :: ${banner.topBanner}');
        yield LoadBannersCompletedState(banner);
      } else {
        yield LoadBannersFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadBannersFailedState();
    }
  }

}
