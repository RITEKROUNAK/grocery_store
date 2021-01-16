import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

class EditProductBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;

  EditProductBloc({@required this.userDataRepository}) : super(null);

  ProductsState get initialState => EditProductInitialState();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is EditProductEvent) {
      yield* mapEditProductEventToState(event.product);
    }
    if (event is DeleteProductEvent) {
      yield* mapDeleteProductEventToState(event.id);
    }
  }

    Stream<ProductsState> mapEditProductEventToState(Map<dynamic,dynamic> product) async* {
    yield EditProductInProgressState();
    try {
      bool isEdited  = await userDataRepository.editProduct(product);
      if (isEdited) {
        yield EditProductCompletedState();
      } else {
        yield EditProductFailedState();
      }
    } catch (e) {
      print(e);
      yield EditProductFailedState();
    }
  }

  Stream<ProductsState> mapDeleteProductEventToState(String id)async*{
    yield DeleteProductInProgressState();
    try {
      bool isDeleted = await userDataRepository.deleteProduct(id);
      if (isDeleted) {
        yield DeleteProductCompletedState();
      }else{
      yield DeleteProductFailedState();

      }
    } catch (e) {
      print(e);
      yield DeleteProductFailedState();
    }
  }
}
