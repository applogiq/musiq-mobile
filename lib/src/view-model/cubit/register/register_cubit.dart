import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart'as http;

import '../../../helpers/constants/api.dart';
import '../../../helpers/utils/validation.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with InputValidationMixin {
  RegisterCubit() : super(RegisterInitial());
    final _fullNameController = BehaviorSubject<String>.seeded("");
    final _userNameController = BehaviorSubject<String>.seeded("");
    final _userEmailController = BehaviorSubject<String>.seeded("");
  final _passwordController = BehaviorSubject<String>.seeded("");
  final _confirmController = BehaviorSubject<String>.seeded("");
    final validator=BehaviorSubject<bool>.seeded(false);


   Stream<String> get fullNameStream => _fullNameController.stream;
   Stream<String> get userNameStream => _userNameController.stream;
   Stream<String> get emailStream => _userEmailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get confirmPasswordStream => _confirmController.stream;
  Stream<bool> get validatorStream => validator.stream;
   void clearStreams() {
    validator.sink.add(false);
    updateFullName('');
    updateUserName('');
    updateUserEmail('');
    updatePassword('');
    updateConfirmPassword('');
  }
   updateFullName(String fullName){
    if(validator.value==true){
if(fullName.isEmpty){
  if(validator.value)_fullNameController.sink.addError("Full Name is mandatory");
    }
   
    else{
_fullNameController.sink.add(fullName);
    }
    }
    
  }
  
   updateUserName(String userName){
     
     if(validator.value==true){
      if(userName.isEmpty){
       if(validator.value)_userNameController.sink.addError("User Name is mandatory");
    }
    
    else if(userName.contains(" ")){
        if(validator.value) _userNameController.sink.addError("User Name does not contain space");
    }
    else{
_userNameController.sink.add(userName);
    }
     }
    
  }
  
   updateUserEmail(String userEmail){
     if(validator.value==true){
       if(userEmail.isEmpty){
    if(validator.value) _userEmailController.sink.addError("Email Id is mandatory");
   }
   else if (!isEmailValid(userEmail)) {
      print('F');
     if(validator.value) _userEmailController.sink.addError("Invalid Email ID");
    } else {
      _userEmailController.sink.add(userEmail);
    }
     }
  }
   updatePassword(String password,{bool isTooltip=false,bool isError=false,}){
   if(validator.value==true){
    if(password.isEmpty&&isTooltip==false){
 if(validator.value)_passwordController.sink.addError("Password is mandatory");
    }
     else if(validateStructure(password)){
      _passwordController.sink.add(password);
    }
    else{
      if(validator.value)_passwordController.sink.addError("show toggle");
    }
   }
     }
   updateConfirmPassword(String confirmPassword){
   print(confirmPassword);
   print(_passwordController.value.toString());
   if(validator.value==true){
     if(confirmPassword.isEmpty){
if(validator.value)_confirmController.sink.addError("Confirm password is mandatory");
    }
    else if(_confirmController.value==_passwordController.value){
      _confirmController.sink.add(confirmPassword);
    }
     else if(_confirmController.value!=_passwordController.value){
        if(validator.value)_confirmController.sink.addError("Password not same");

    }
    else{
      print("unmatch");
      
     if(validator.value) _confirmController.sink.addError("Er");

    }
   }
  }

userNameTap()async{
    validator.sink.add(true);

     var check1;
                        try{

                       check1=await fullNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
             
                      if(check1=="")updateFullName("");
}

emailAddressTap()async{
  validator.sink.add(true);
     var check1;
                        var check2;
                        try{

                       check1=await fullNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
                        try{
 check2=await userNameStream.first;
                      
                        }
                        catch(err){
                             check2=err.toString();
                      
                        }
                      if(check1=="")updateFullName("");
                      if(check2=="")updateUserName("");
}



passwordTap()async{
  validator.sink.add(true);
     var check1;
                        var check2;
                        var check3;
                        try{

                       check1=await fullNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
                        try{
 check2=await userNameStream.first;
                      
                        }
                        catch(err){
                             check2=err.toString();
                      
                        }
                          try{
 check3=await emailStream.first;
                      
                        }
                        catch(err){
                             check3=err.toString();
                      
                        }
                      if(check1=="")updateFullName("");
                      if(check2=="")updateUserName("");
                      if(check3=="")updateUserEmail("");
                      updatePassword("",isTooltip: true);
}

confirmPasswordTap()async{
  validator.sink.add(true);
     var check1;
                        var check2;
                        var check3;
                        var check4;
                        try{

                       check1=await fullNameStream.first;
                       }
                        catch (err){
                          check1=err.toString();
                         }
                        try{
 check2=await userNameStream.first;
                      
                        }
                        catch(err){
                             check2=err.toString();
                      
                        }
                          try{
 check3=await emailStream.first;
                      
                        }
                        catch(err){
                             check3=err.toString();
                      
                        }
                           try{
 check4=await passwordStream.first;
                      
                        }
                        catch(err){
                             check4=err.toString();
                      
                        }
                      if(check1=="")updateFullName("");
                      if(check2=="")updateUserName("");
                      if(check3=="")updateUserEmail("");
                      if(check4=="")updatePassword("");
}
 Stream<bool> get validateForm => Rx.combineLatest2(
    userNameStream,
    passwordStream,
        (a, b,) => true,
  );

 registerAPI(BuildContext context)async{
//   if(isSuccess==true){
// isLoading.sink.add(false);
//   }
//   else{
//     isLoading.sink.add(true);
//   try{
    var fullName="", userName="", email="",password="";
      Map<String, dynamic> params = {
  "username": _userNameController.stream.value,
  "fullname": _fullNameController.stream.value,
  "email": _userEmailController.stream.value,
  "password": _passwordController.stream.value

    };
    
    
    print(params);
    
    var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.REGISTER.toString());
   print(url);
    
    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
  print(response.statusCode);
  if(response.statusCode==201){
 Navigation.navigateReplaceToScreen(context, 'selectArtistPref/');
  }
  else if(response.statusCode==400){
    var data=jsonDecode(response.body.toString());
    print(data['detail']["message"]);
    if(data['detail']["message"]=="username already exists")
    {
    _userNameController.sink.addError("username already exists");

    }
    else if(data['detail']["message"]=="email already exists")
    {
      _userEmailController.sink.addError("email already exists");

    }
  }

//   if(response.statusCode==200){
//     isSuccess.sink.add(true);
//     isInvalidCred.sink.add(true);
//   }
//   else if(response.statusCode==404){
//     isInvalidCred.sink.addError(ConstantText.invalidEmailAndPassword);
//    isSuccess.sink.add(false);
//   }
//   else{
//    isSuccess.sink.add(false);
//     isInvalidCred.sink.add(true);
//   }
//      isLoading.sink.add(false);
//  return response.statusCode;
//   }
//   catch(e){
//     print(e.toString());
//      isLoading.sink.add(false);
//     return http.Response("Error", 1);
//   }
  // }
}


}
