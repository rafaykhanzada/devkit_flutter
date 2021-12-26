import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:devkitflutter/network/api_provider.dart';
import './bloc.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(InitialExampleState());

  @override
  Stream<ExampleState> mapEventToState(
    ExampleEvent event,
  ) async* {
    if(event is GetExample){
      yield* _getExample(event.apiToken);
    } else if(event is PostExample){
      yield* _postExample(event.id, event.apiToken);
    }
  }
}

Stream<ExampleState> _getExample(apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield ExampleWaiting();
  try {
    String data = await _apiProvider.getExample(apiToken);
    yield GetExampleSuccess(exampleData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield ExampleError(errorMessage: ex.toString());
    }
  }
}

Stream<ExampleState> _postExample(id, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield ExampleWaiting();
  try {
    String data = await _apiProvider.postExample(id, apiToken);
    yield PostExampleSuccess(exampleData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield ExampleError(errorMessage: ex.toString());
    }
  }
}