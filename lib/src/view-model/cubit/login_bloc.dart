import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/api.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/utils/validation.dart';
import 'package:http/http.dart'as http;
part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> with InputValidationMixin{
  LoginBloc():super(LoginInitialState());
   final _userEmailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final validator=BehaviorSubject<bool>();
  final isInvalidCred=BehaviorSubject<bool>();
  Stream<String> get userNameStream => _userEmailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<bool> get errorStream => isInvalidCred.stream;

 void clearStreams() {
    updateUserName('');
    updatePassword('');
  }

  void updateUserName(String userName) {
   if(validator.hasValue){
     if(userName.isEmpty){
     _userEmailController.sink.addError("Email Id is mandatory");
   }
   else if (!isEmailValid(userName)) {
      print('F');
      _userEmailController.sink.addError("Invalid Email ID");
    } else {
      _userEmailController.sink.add(userName);
    }
   }
  }
  void updateValidator(bool val){
    validator.sink.add(val);
  }
   void updateError(){
    isInvalidCred.sink.add(true);
  }

  void updatePassword(String password) {
   if(validator.hasValue){
      if (password.isEmpty) {
      _passwordController.sink.addError("Password is mandatory");
    }
   
     else {
      _passwordController.sink.add(password);
    }
   }
  }

  Stream<bool> get validateForm => Rx.combineLatest2(
    userNameStream,
    passwordStream,
        (a, b,) => true,
  );


 loginAPI()async{
  try{
    var email="",password="";
      Map<String, dynamic> params = {
     "email": _userEmailController.stream.value,
     "password": _passwordController.stream.value
    };
    
    var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.LOGIN.toString());
   
    
    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
  print(response.statusCode);
  if(response.statusCode==200){
    isInvalidCred.sink.add(false);
  }
  else if(response.statusCode==404){
    isInvalidCred.sink.addError(true);
   //
  }
 return response.statusCode;
  }
  catch(e){
    print(e.toString());
    return http.Response("Error", 1);
  }
}
}