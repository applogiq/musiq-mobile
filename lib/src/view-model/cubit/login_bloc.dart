import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/api.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/utils/validation.dart';
import 'package:http/http.dart'as http;
part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> with InputValidationMixin{
  LoginBloc():super(LoginInitialState());
   final _userEmailController = BehaviorSubject<String>.seeded("");
  final _passwordController = BehaviorSubject<String>.seeded("");
  final validator=BehaviorSubject<bool>.seeded(false)
  ;
  final isInvalidCred=BehaviorSubject<bool>.seeded(false);
  final isLoading=BehaviorSubject<bool>.seeded(false);
  Stream<String> get userNameStream => _userEmailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<bool> get errorStream => isInvalidCred.stream;
  Stream<bool> get loadingStream => isLoading.stream;

 void clearStreams() {
    updateUserName('');
    updatePassword('');
  }

  void updateUserName(String userName) {
     isInvalidCred.sink.add(false);
   if(validator.value==true){
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
   else{

   print("Check");
   }
  }
  
passwordTap()async{
     var check1;
                        try{

                       check1=await userNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
             
                      if(check1=="")updateUserName("");
}

  checkEmptyValidation()async{
     var check1;
                        var check2;
                        try{

                       check1=await userNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
                        try{
 check2=await passwordStream.first;
                      
                        }
                        catch(err){
                             check2=err.toString();
                      
                        }
                      if(check1=="")updateUserName("");
                      if(check2=="")updatePassword("");

  }
  void updateValidator(bool val){
    validator.sink.add(val);
  }
   void updateError(){
    isInvalidCred.sink.add(true);
  }

  void updatePassword(String password) {
     isInvalidCred.sink.add(false);
  
   if(validator.value==true){
     print("MAKE");
     print(password);
      if (password.isEmpty) {
      _passwordController.sink.addError("Password is mandatory");
    }
   
     else {
      _passwordController.sink.add(password);
    }

   }
   else{

   print("Check");
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
    
    print(params);
    
    var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.LOGIN.toString());
   print(url);
    
    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
  print(response.statusCode);
  if(response.statusCode==200){
    isInvalidCred.sink.add(true);
  }
  else if(response.statusCode==404){
    isInvalidCred.sink.addError(ConstantText.invalidEmailAndPassword);
   //
  }
  else{
    isInvalidCred.sink.add(true);
  }
 return response.statusCode;
  }
  catch(e){
    print(e.toString());
    return http.Response("Error", 1);
  }
}
}