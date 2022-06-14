import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/api.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/utils/validation.dart';
import 'package:http/http.dart'as http;
part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> with InputValidationMixin{
  LoginBloc():super(LoginInitialState());
   final userEmailController = BehaviorSubject<String>.seeded("");
  final passwordController = BehaviorSubject<String>.seeded("");
  final validator=BehaviorSubject<bool>.seeded(false);
  final isInvalidCred=BehaviorSubject<bool>.seeded(false);
  final isLoading=BehaviorSubject<bool>.seeded(false);
  final isSuccess=BehaviorSubject<bool>.seeded(false);
  

  Stream<String> get userNameStream => userEmailController.stream;
  Stream<String> get passwordStream => passwordController.stream;
  Stream<bool> get errorStream => isInvalidCred.stream;
  Stream<bool> get loadingStream => isLoading.stream;
  // Stream<bool> get successStream => isLoading.stream;

 void clearStreams() {
    isInvalidCred.sink.add(false);
    isLoading.sink.add(false);
    validator.sink.add(false);
    isSuccess.sink.add(false);
    updateUserName('');
    updatePassword('');
  }

  void updateUserName(String userName) {
     isInvalidCred.sink.add(false);
   
     if(userName.isEmpty){
      if(validator.value==true){

     userEmailController.sink.addError("Email Id is mandatory");
      }
   }
   else if (!isEmailValid(userName)) {
     if(validator.value==true){

      userEmailController.sink.addError("Invalid Email ID");
     }
    } else {
      userEmailController.sink.add(userName);
    }
   
  
  }
  
passwordTap()async{
  validator.sink.add(true);
  print(userEmailController.value.toString());
     var check1;
                        try{

                       check1=await userNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
             
                      if(check1==""){
                        updateUserName("");
                      }
                      else{

                      updateUserName(userEmailController.value.toString());
                      } 
                      print(userEmailController.value.toString());
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

                      var isValid=await validateForm.toString();
                      print("isValid");
                      print(isValid);
                      if(check1=="" || check2==""){
                        return false;
                      }
                      else{
                        return true;
                      }

  }
  void updateValidator(bool val){
    validator.sink.add(val);
  }
   void updateError(){
    isInvalidCred.sink.add(true);
  }

  void updatePassword(String password) {
     isInvalidCred.sink.add(false);
  
   
      if (password.isEmpty) {
        if(validator.value==true){
           passwordController.sink.addError("Password is mandatory");
        }
    }
   
     else {
      passwordController.sink.add(password);
    }

  }

  Stream<bool> get validateForm => Rx.combineLatest2(
    userNameStream,
    passwordStream,
        (a, b,) => true,
  );


 loginAPI(BuildContext context)async{
  if(isSuccess==true){
isLoading.sink.add(false);
  }
  else{
    isLoading.sink.add(true);
  try{
    var email="",password="";
      Map<String, dynamic> params = {
     "email": userEmailController.stream.value,
     "password": passwordController.stream.value
    };
    
    print(params);
    
    var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.LOGIN.toString());
   print(url);
    
    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
  print(response.statusCode);
  if(response.statusCode==200){
    isSuccess.sink.add(true);
    isInvalidCred.sink.add(true);
    // Future.delayed(Duration(milliseconds: 600),(){
      Navigation.navigateReplaceToScreen(context, 'home/');
     clearStreams();
    // });
  }
  else if(response.statusCode==404){
    isInvalidCred.sink.addError(ConstantText.invalidEmailAndPassword);
   isSuccess.sink.add(false);
  }
  else{
   isSuccess.sink.add(false);
    isInvalidCred.sink.add(true);
  }
     isLoading.sink.add(false);
 return response.statusCode;
  }
  catch(e){
    print(e.toString());
     isLoading.sink.add(false);
    return http.Response("Error", 1);
  }
  }
}


}