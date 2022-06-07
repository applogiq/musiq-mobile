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
  Stream<String> get userNameStream => _userEmailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

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

  void updatePassword(String password) {
   if(validator.hasValue){
      if (password.isEmpty) {
      _passwordController.sink.addError("Password is mandatory");
    }
    else if(!validateStructure(password)){
      _passwordController.sink.addError("Invalid Password");
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
    print(params);
    
    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
  print(response.statusCode);
  if(response.statusCode==200){
    return true;
  }
  else if (response.statusCode==404){
    print("INVALID");
    return false;
  }
  else{
    return false;
  }
  }
  catch(e){
    print(e.toString());
    return false;
  }
}
}