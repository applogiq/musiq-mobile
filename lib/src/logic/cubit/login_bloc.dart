import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/constants/api.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/utils/validation.dart';
import 'package:http/http.dart'as http;

import '../../model/api_model/user_model.dart';
part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> with InputValidationMixin{
  LoginBloc():super(LoginInitialState());
   final userEmailController = BehaviorSubject<String>.seeded("");
  final passwordController = BehaviorSubject<String>.seeded("");
  final validator=BehaviorSubject<bool>.seeded(false);
  final isInvalidCred=BehaviorSubject<bool>.seeded(false);
  final isLoading=BehaviorSubject<bool>.seeded(false);
  final isSuccess=BehaviorSubject<bool>.seeded(false);
  final storage = FlutterSecureStorage();

  

  Stream<String> get userNameStream => userEmailController.stream;
  Stream<String> get passwordStream => passwordController.stream;
  Stream<bool> get errorStream => isInvalidCred.stream;
  Stream<bool> get loadingStream => isLoading.stream;
 

 void clearStreams() {
    isInvalidCred.sink.add(false);
    isLoading.sink.add(false);
    validator.sink.add(false);
    isSuccess.sink.add(false);
    updateUserName('');
    updatePassword('');
  }
dispose() {
    userEmailController.close();
    passwordController.close();
  }
  void updateUserName(String userName) {
     isInvalidCred.sink.add(false);
     if(validator.value==true){
      if(userName.isEmpty){
        userEmailController.sink.addError("Field is required");
      }
      else if(!isEmailValid(userName)){
        userEmailController.sink.addError("Invalid Email ID");
      }
      else{

      userEmailController.sink.add(userName);
      }

     }
     else{
      userEmailController.sink.add(userName);
     }
   
  
  }
   void updatePassword(String password) {
     isInvalidCred.sink.add(false);
  
   
     if(validator.value==true){
      if(password.isEmpty){
        passwordController.sink.addError("Field is required");
      }
      else{
passwordController.sink.add(password);
      }

     }
     else{
      passwordController.sink.add(password);
     }
  }

 
passwordTap()async{
  validator.sink.add(true);
  print(userEmailController.value.toString());
     var check1;
                        try{

                       check1=await userNameStream.first;
                       print(check1);
                       updateUserName(check1);
                       print("check");
                       }
                        catch (err){
                          print(err.toString());
                          check1=err.toString();
                         }
             
             print(check1);
                      if(check1==""){
                       userEmailController.sink.addError("Field is required");
                      }
                      else if(check1=="Invalid Email ID"){
                       userEmailController.sink.addError(check1);

                      }
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
     var data=jsonDecode(response.body.toString());
  User user=User.fromMap(data);
  print(user.toMap());
   await storage.deleteAll();
  
  var userData = user.records.toMap();
          for (final name in userData.keys) {
            final value = userData[name];
            debugPrint('$name,$value');
            await storage.write(
              key: name,
              value: value.toString(),
            );
          }
    Future.delayed(Duration(milliseconds: 600),(){
      Navigation.navigateReplaceToScreen(context, 'home/');
     clearStreams();
    });
  }
  else if(response.statusCode==404){
    print("ERRR");
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
    return 1;
  }
  }
}


}