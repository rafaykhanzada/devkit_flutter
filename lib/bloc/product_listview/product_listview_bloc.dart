import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:devkitflutter/model/integration/product_listview_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import './bloc.dart';

class ProductListviewBloc extends Bloc<ProductListviewEvent, ProductListviewState> {
  ProductListviewBloc() : super(InitialProductListviewState());

  @override
  Stream<ProductListviewState> mapEventToState(
    ProductListviewEvent event,
  ) async* {
    if(event is GetProductListview){
      yield* _getProductListview(event.sessionId, event.skip, event.limit, event.apiToken);
    }
  }
}

Stream<ProductListviewState> _getProductListview(String sessionId, String skip, String limit, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield ProductListviewWaiting();
  try {
    List<ProductListviewModel> data = await _apiProvider.getProductListview(sessionId, skip, limit, apiToken);
    yield GetProductListviewSuccess(productListviewData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield ProductListviewError(errorMessage: ex.toString());
    }
  }
}