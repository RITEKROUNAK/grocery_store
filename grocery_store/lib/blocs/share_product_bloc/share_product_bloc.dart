import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'share_product_event.dart';
part 'share_product_state.dart';

class ShareProductBloc extends Bloc<ShareProductEvent, ShareProductState> {
  ShareProductBloc(ShareProductState initialState) : super(initialState);

  @override
  ShareProductState get initialState => ShareProductInitial();

  @override
  Stream<ShareProductState> mapEventToState(
    ShareProductEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
