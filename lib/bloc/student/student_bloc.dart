import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:devkitflutter/model/integration/student_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import './bloc.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(InitialStudentState());

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    if(event is GetStudent){
      yield* _getStudent(event.sessionId, event.apiToken);
    } else if(event is AddStudent){
      yield* _addStudent(event.sessionId, event.studentName, event.studentPhoneNumber, event.studentGender, event.studentAddress, event.apiToken);
    } else if(event is EditStudent){
      yield* _editStudent(event.sessionId, event.index, event.studentId, event.studentName, event.studentPhoneNumber, event.studentGender, event.studentAddress, event.apiToken);
    } else if(event is DeleteStudent){
      yield* _deleteStudent(event.sessionId, event.studentId, event.index, event.apiToken);
    }
  }
}

Stream<StudentState> _getStudent(String sessionId, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield GetStudentWaiting();
  try {
    List<StudentModel> data = await _apiProvider.getStudent(sessionId, apiToken);
    yield GetStudentSuccess(studentData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield GetStudentError(errorMessage: ex.toString());
    }
  }
}

Stream<StudentState> _addStudent(String sessionId, String studentName, String studentPhoneNumber, String studentGender, String studentAddress, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  String errorMessage='';
  if(studentName==''){
    errorMessage = 'Student name cannot be empty';
  } else if(studentPhoneNumber==''){
    errorMessage = 'Student phone number can not be empty';
  } else if(studentGender==''){
    errorMessage = 'Student gender can not be empty';
  } else if(studentAddress==''){
    errorMessage = 'Student address can not be empty';
  }

  if(errorMessage == ''){
    yield AddStudentWaiting();
    try {
      List data = await _apiProvider.addStudent(sessionId, studentName, studentPhoneNumber, studentGender, studentAddress, apiToken);
      yield AddStudentSuccess(msg: data[0], studentId:data[1], studentName: studentName, studentPhoneNumber: studentPhoneNumber, studentGender: studentGender, studentAddress: studentAddress);
    } catch (ex){
      yield AddStudentError(errorMessage: ex.toString());
    }
  } else {
    yield StudentErrorValidation(errorMessage: errorMessage);
  }
}

Stream<StudentState> _editStudent(String sessionId, int index, int studentId,  String studentName, String studentPhoneNumber, String studentGender, String studentAddress, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  String errorMessage='';
  if(studentName==''){
    errorMessage = 'Student name cannot be empty';
  } else if(studentPhoneNumber==''){
    errorMessage = 'Student phone number can not be empty';
  } else if(studentGender==''){
    errorMessage = 'Student gender can not be empty';
  } else if(studentAddress==''){
    errorMessage = 'Student address can not be empty';
  }

  if(errorMessage == ''){
    yield EditStudentWaiting();
    try {
      String message = await _apiProvider.editStudent(sessionId, studentId, studentName, studentPhoneNumber, studentGender, studentAddress, apiToken);
      yield EditStudentSuccess(msg: message, index:index, studentId:studentId, studentName: studentName, studentPhoneNumber: studentPhoneNumber, studentGender: studentGender, studentAddress: studentAddress);
    } catch (ex){
      yield EditStudentError(errorMessage: ex.toString());
    }
  } else {
    yield StudentErrorValidation(errorMessage: errorMessage);
  }
}

Stream<StudentState> _deleteStudent(String sessionId, int studentId, int index, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield DeleteStudentWaiting();
  try {
    String msg = await _apiProvider.deleteStudent(sessionId, studentId, apiToken);
    yield DeleteStudentSuccess(msg: msg, index: index);
  } catch (ex){
    yield DeleteStudentError(errorMessage: ex.toString());
  }
}