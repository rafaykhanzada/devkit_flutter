import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:devkitflutter/model/integration/product_grid_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import './bloc.dart';

class ProductGridBloc extends Bloc<ProductGridEvent, ProductGridState> {
  ProductGridBloc() : super(InitialProductGridState());

  @override
  Stream<ProductGridState> mapEventToState(
    ProductGridEvent event,
  ) async* {
    if(event is GetProductGrid){
      yield* _getProductGrid(event.sessionId, event.skip, event.limit, event.apiToken);
    }
  }
}

Stream<ProductGridState> _getProductGrid(String sessionId, String skip, String limit, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield ProductGridWaiting();
  try {
    List<ProductGridModel> data = await _apiProvider.getProductGrid(sessionId, skip, limit, apiToken);
    yield GetProductGridSuccess(productGridData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield ProductGridError(errorMessage: ex.toString());
    }
  }
}