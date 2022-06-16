import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/model/api_model/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart'as http;

import '../../../helpers/constants/api.dart';
import '../../../helpers/utils/validation.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with InputValidationMixin {
  RegisterCubit() : super(RegisterInitial());
  
  
  //controller
  final fullNameController = BehaviorSubject<String>.seeded("");
  final _userNameController = BehaviorSubject<String>.seeded("");
  final _userEmailController = BehaviorSubject<String>.seeded("");
  final _passwordController = BehaviorSubject<String>.seeded("");
  final _confirmController = BehaviorSubject<String>.seeded("");
  final isLoading=BehaviorSubject<bool>.seeded(false);
  final isSuccess=BehaviorSubject<bool>.seeded(false);
  
  
  final validator=BehaviorSubject<bool>.seeded(false);
  final passwordValid=BehaviorSubject<bool>.seeded(false);
  final storage = FlutterSecureStorage();
  

  //stream
  Stream<String> get fullNameStream => fullNameController.stream;
  Stream<String> get userNameStream => _userNameController.stream;
  Stream<String> get emailStream => _userEmailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get confirmPasswordStream => _confirmController.stream;
  Stream<bool> get validatorStream => validator.stream;
  Stream<bool> get loadingStream => isLoading.stream;
Stream<bool> get validateForm => Rx.combineLatest5(
    fullNameStream,
    userNameStream,
    emailStream,
    passwordStream,confirmPasswordStream,
        (a, b,c,d,e) => true,
  );
  registerAPI(BuildContext context) async{
    isLoading.sink.add(true);
      Map<String, dynamic> params = {
  "username": _userNameController.stream.value,
  "fullname": fullNameController.stream.value,
  "email": _userEmailController.stream.value,
  "password": _passwordController.stream.value

    };
    print(params);
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.REGISTER.toString());
   print(url);
    try{

    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
print(response.statusCode);
late User user;
if(response.statusCode==201){
  var data=jsonDecode(response.body.toString());
  user=User.fromMap(data);
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
              isLoading.sink.add(false);
   Navigation.navigateReplaceToScreen(context, 'selectArtistPref/');
   
  
}
else if(response.statusCode==400){
  
      var data=jsonDecode(response.body.toString());
    print(data['detail']["message"]);
     if(data['detail']["message"]=="email already exists")
    {
      _userEmailController.sink.addError("Email already exists");

    }
    else if(data['detail']["message"]=="username already exists")
    {
    _userNameController.sink.addError("Username already exists");

    }
        isLoading.sink.add(false);
 

}
    }
    catch(e){
      print(e.toString());
          isLoading.sink.add(false);
 
    return http.Response("Try Again",500);
    }
  }

//  registerAPI(BuildContext context)async{
// //   if(isSuccess==true){
// // isLoading.sink.add(false);
// //   }
// //   else{
// //     isLoading.sink.add(true);
// //   try{
//     var fullName="", userName="", email="",password="";
//       Map<String, dynamic> params = {
//   "username": _userNameController.stream.value,
//   "fullname": fullNameController.stream.value,
//   "email": _userEmailController.stream.value,
//   "password": _passwordController.stream.value

//     };
    
    
//     print(params);
    
//     var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.REGISTER.toString());
//    print(url);
    
//     var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
//               'Accept': 'application/json',
//               });
//   print(response.statusCode);
//   if(response.statusCode==201){
//  Navigation.navigateReplaceToScreen(context, 'selectArtistPref/');
//   }
//   else if(response.statusCode==400){
//     var data=jsonDecode(response.body.toString());
//     print(data['detail']["message"]);
//     if(data['detail']["message"]=="username already exists")
//     {
//     _userNameController.sink.addError("username already exists");

//     }
//     else if(data['detail']["message"]=="email already exists")
//     {
//       _userEmailController.sink.addError("email already exists");

//     }
//   }

// //   if(response.statusCode==200){
// //     isSuccess.sink.add(true);
// //     isInvalidCred.sink.add(true);
// //   }
// //   else if(response.statusCode==404){
// //     isInvalidCred.sink.addError(ConstantText.invalidEmailAndPassword);
// //    isSuccess.sink.add(false);
// //   }
// //   else{
// //    isSuccess.sink.add(false);
// //     isInvalidCred.sink.add(true);
// //   }
// //      isLoading.sink.add(false);
// //  return response.statusCode;
// //   }
// //   catch(e){
// //     print(e.toString());
// //      isLoading.sink.add(false);
// //     return http.Response("Error", 1);
// //   }
//   // }
// }


  void updateFullName(String text) {
    if(text.isEmpty){
      fullNameController.sink.add("");
      fullNameController.sink.addError(ConstantText.fieldRequired);
    }
    else{

    fullNameController.sink.add(text);
    }
  }
  void createAccount(){
 confirmPasswordTap();
 if(_confirmController.value.isEmpty){
  _confirmController.sink.addError(ConstantText.fieldRequired);
 }
 else if(_passwordController.value.toString()!=_confirmController.value.toString()){
  _confirmController.sink.addError(ConstantText.passwordNotMatch);
 }
  }

  void updateUserEmail(String text,{bool isTap=false}) {
     if(text.isEmpty){
      _userEmailController.sink.add("");
      _userEmailController.sink.addError(ConstantText.fieldRequired);
    }
    else if(!isEmailValid(text)){
        _userEmailController.sink.addError(ConstantText.invalidEmail);
    
    }
    else{

    _userEmailController.sink.add(text);
    }
  }

  void emailAddressTap() {
    if(fullNameController.value.isEmpty)updateFullName("");
  }

  void updateUserName(String text) {
    if(text.isEmpty){
      _userNameController.sink.add("");
      _userNameController.sink.addError(ConstantText.fieldRequired);
    }
    else if(text.contains(" ")){
        _userNameController.sink.addError(ConstantText.invalidUserName);
    
    }
    else{

    _userNameController.sink.add(text);
    }
  }

  void userNameTap() {
    if(fullNameController.value.isEmpty)updateFullName("");
    if(_userEmailController.value.isEmpty)updateUserEmail("");
    if(!isEmailValid(_userEmailController.value))updateUserEmail(_userEmailController.value);
  }

  void updatePassword(String text) {
    _passwordController.sink.add(text);
     if(text.isEmpty){
    
      _passwordController.sink.add("");
      _passwordController.sink.addError(ConstantText.fieldRequired);
      _confirmController.sink.addError("");
    }
    else if(_passwordController.value.isNotEmpty&&_confirmController.value.isNotEmpty){
 

      if(_passwordController.value.toString()==_confirmController.value.toString()){
        if(!validateStructure(_passwordController.value.toString())){
                     _passwordController.sink.addError("show toggle");

        }
        _confirmController.sink.add(_passwordController.value.toString());
        
      }
      else{
         if(!validateStructure(_passwordController.value.toString())){
          _passwordController.sink.addError("show toggle");
        }
        print("Not match");
        _confirmController.sink.addError(ConstantText.passwordNotMatch);

      }
    }
    else if(!validateStructure(_passwordController.value.toString())){
          _passwordController.sink.addError("show toggle");
      
    }
    
  }

  void passwordTap() {
    userNameTap();
    if(_userNameController.value.isEmpty){
      _userNameController.sink.addError(ConstantText.fieldRequired);
    }
    else if(_userNameController.value.toString().contains(" ")){
      _userNameController.sink.addError(ConstantText.invalidUserName);

    }
    if(_passwordController.value.isEmpty){
      _passwordController.sink.addError("show toggle");
    }
    else if(!validateStructure(_passwordController.value.toString())){
       _passwordController.sink.addError("show toggle");
   
    }
  }


  void updateConfirmPassword(String text) {
  _confirmController.sink.add(text);
  if(text.isEmpty){
    _confirmController.sink.add("");
    _confirmController.sink.addError(ConstantText.fieldRequired);
  }
   if(_passwordController.value.isNotEmpty&&_confirmController.value.isNotEmpty){
      if(_passwordController.value.toString()==_confirmController.value.toString()){
        print("Match");
      }
      else{
        _confirmController.sink.addError(ConstantText.passwordNotMatch);
      }
    }
  }

  void confirmPasswordTap() {
    passwordTap();
    if(_passwordController.value.isEmpty){
      _passwordController.sink.addError(ConstantText.fieldRequired);
    }
    else if(!validateStructure(_passwordController.value.toString())){
      _passwordController.sink.addError("show toggle alert");
    }
  }

  

   
//   void updatePassword(String text,{bool isTap=false,bool isTooltip=false}) {
//     print(_confirmController.value);
//     print(_passwordController.value);
//      if(text.isEmpty){
//       _passwordController.sink.add("");
//       _passwordController.sink.addError(ConstantText.fieldRequired);
//     }
    
// else if(_passwordController.value==_confirmController.value){
//          _passwordController.sink.add(text);
//       if(!_confirmController.value.isEmpty){
     
// _confirmController.sink.addError("Password does not match");
//       }
     
//     }
//     else if(isTap){
// print("object");
      
//       if(!validateStructure(_passwordController.value)){
//         _passwordController.sink.add(text);
     
//         _passwordController.sink.addError("show toggle alert");
//         print(_passwordController.error);
    
//     }
//     else if(_passwordController.error=="Field is required"){
//       print("FFFFF");
//     }
//     }
    
//     else if(!validateStructure(_passwordController.value)){
//       _passwordController.sink.add(text);
      
//         _passwordController.sink.addError("show toggle");
    
//     }
//     else{
//       print("VMMM");

//     _passwordController.sink.add(text);
//     }
//      if(isTooltip)_passwordController.sink.addError("show toggle");

//   }

//   void confirmPasswordTap() {
//     passwordTap();
//     print(_passwordController.value);
//     if(_passwordController.value.isEmpty)updatePassword(" ",isTap: true);
//     if(_passwordController.value.isNotEmpty){
//       if(validateStructure(_passwordController.value)){
//         print("object5");
//         }
//       else{
//         print("FFFGDSSF");
//         updatePassword(_passwordController.value,isTap: true);
      
//       }
//       print(validateStructure(_passwordController.value));
//     };
//     print(_passwordController.value);
//     print("NO");
//   }

//   void passwordTap() {
//     userNameTap();
//     if(_userNameController.value.isEmpty)updateUserName("");
//     else updateUserName(_userNameController.value);
//     if(validateStructure(_passwordController.value)){
//          updatePassword(_passwordController.value,isTap: true);
//       }
    
//   }

//   void updateConfirmPassword(String text) {
//     _confirmController.sink.add(text);
//     if(_passwordController.value!=_confirmController.value){
//       print("dds");
//      _confirmController.sink.addError("Password does not match");
//     }
//     else{
//       print("MATCH");
//       _confirmController.sink.addError("Password Match");
//     }
//     // if(text.isEmpty){
//     //   _confirmController.add("");
//     //        _confirmController.sink.addError(ConstantText.fieldRequired);
  
//     // }
    
//     // else if(_confirmController.value!=_passwordController.value){
//     //   _confirmController.sink.add(text);
     
//     //   _confirmController.sink.addError("NO");
//     // }
//     // else if(_confirmController.value==_passwordController.value){
//     //   _confirmController.sink.add(text);
     
//     //   _confirmController.sink.addError(" match");
//     // }
//     // else{
//     //   _confirmController.sink.add(text);
//     // }
//   }
  
//   void clearStreams() {
//     validator.sink.add(false);
//     updateFullName('');
//     // updateUserName('');
//     // updateUserEmail('');
//     // updatePassword('');
//     // updateConfirmPassword('');
//   }

//   void updateFullName(String text,{bool isTap=false}) {
//        if(validator.value==true){
//     if(text.isEmpty){
//     fullNameController.sink.addError(ConstantText.fieldRequired);

//     }
    
//    else{
//     fullNameController.sink.add(text);
//    print(fullNameController.value);

//    }

//    }
//    else{
//     fullNameController.sink.add(text);
//    print(fullNameController.value);
//    }

//     if(isTap){
//       validator.sink.add(false);
//     }
//   }

//   void updateUserEmail(String text,{bool isTap=false}) {
//          if(validator.value==true){
//            if(text.isEmpty){
//           _userEmailController.sink.addError(ConstantText.fieldRequired);

//             }
//             else if(!isEmailValid(text)){
//             _userEmailController.sink.addError("Invalid email");

//             }
    
//             else{
//             _userEmailController.sink.add(text);
//           }

//    }
//    else{
//     _userEmailController.sink.add(text);
//    }
//    if(isTap){
//     validator.sink.add(false);
//    }
//    print(_userEmailController.value);

//   }

//   void emailAddressTap() async{
//          var check1;
//                         try{

//                        check1=await fullNameStream.first;
//                        }
//                         catch (err){
//                           check1=err.toString();
//                          }
             
//                       if(check1==""){
//     validator.sink.add(true);

//                         updateFullName("",isTap: true);
//                       }}

// userNameTap()async{
//   validator.sink.add(true);
//      var check1;
//                         var check2;
//                         try{

//                        check1=await fullNameStream.first;
//                        print(check1);
//                        }
//                         catch (err){
//                           check1=err.toString();
//                          }
//                         try{
//  check2=await userNameStream.first;
                      
//                         }
//                         catch(err){
//                              check2=err.toString();
                      
//                         }
//                       if(check1=="")updateFullName("",isTap: true);
//                       if(check2=="")updateUserEmail("",isTap: true);

//   }

//   void updateUserName(String text,{bool isTap=false}) {
//         if(validator.value==true){
//            if(text.isEmpty){
//           _userNameController.sink.addError(ConstantText.fieldRequired);

//             }
//             else if(text.contains(" ")){
//             _userNameController.sink.addError("User name does not contain space");

//             }
    
//             else{
//             _userEmailController.sink.add(text);
//           }

//    }
//    else{
//     _userEmailController.sink.add(text);
//    }
//    if(isTap){
//     validator.sink.add(false);
//    }
//   }

//   updateValue(String value,BehaviorSubject<String> con){
//     if(validator.value==true){
// if(value.isEmpty){
//   con.sink.addError("error");
// }
// else if(value.length<5){
//   con.sink.addError("length error");

// }
//  else{
//       con.sink.add(value);
//     } 
//     }
//     else{
//       con.sink.add(value);
//     }
//     print(value);

//   }
  
//   updateFullName(String fullName){
//    if(validator.value==true){
//     if(fullName.isEmpty){
//     fullNameController.sink.addError(ConstantText.fieldRequired);

//     }
    
//    else{
//     fullNameController.sink.add(fullName);
//    print(fullNameController.value);

//    }

//    }
//    else{
//     fullNameController.sink.add(fullName);
//    print(fullNameController.value);
//    }
    
//   }
  
//    updateUserName(String userName){
     
//      if(validator.value==true){
//     if(userName.isEmpty){
//     _userNameController.sink.addError(ConstantText.fieldRequired);

//     }
//     else if(userName.contains(" ")){
//       _userNameController.sink.addError("User name does not contain space");
//     }
    
//    else{
//     _userNameController.sink.add(userName);
//    }

//    }
//    else{
    
//     _userNameController.sink.add(userName);
//    }
    
//   }
  
//    updateUserEmail(String userEmail){
    
//      if(validator.value==true){
//            if(userEmail.isEmpty){
//           _userEmailController.sink.addError(ConstantText.fieldRequired);

//             }
//             else if(!isEmailValid(userEmail)){
//             _userEmailController.sink.addError("Invalid email");

//             }
    
//             else{
//             _userEmailController.sink.add(userEmail);
//           }

//    }
//    else{
//     _userEmailController.sink.add(userEmail);
//    }
//   }
//    updatePassword(String password,{bool isTooltip=false,bool isError=false,}){
//     if(validator.value==true){
//   print(password);
//       if(password.isEmpty){
//         print("EMPTY");

//     if(isTooltip)_passwordController.sink.addError(ConstantText.fieldRequired);
//    }
//     else if(_passwordController.value.isNotEmpty){
//     _passwordController.sink.addError("show toggle");
  

//     }
   
    
//    else{
//     _passwordController.sink.add(password);
//    }

//    }
//    else{
//     _passwordController.sink.add(password);
//    }
// print(_passwordController.value.toString());
 


// //     print("1");
// //    if(validator.value==true){
// //     print("2");
// // print(_passwordController.value.toString());
// //     if(_passwordController.value.isEmpty&&isTooltip==false){
   
// //  if(validator.value)_passwordController.sink.addError("Password is mandatory");
// //     }

// //      else if(validateStructure(password)){
// //     print("4");
    
// //       if(isError)
// //       {
// //       print("MMMMMMMMMMMMMMMM");
// //       passwordValid.sink.add(true);
// //       }
// //       _passwordController.sink.add(password);
// //     }
// //     else{
// //       print("5");
// //       if(validator.value)_passwordController.sink.addError("show toggle");
// //     }
// //    }
//      }
//    updateConfirmPassword(String confirmPassword){
//    print(confirmPassword);
//    print(_passwordController.value.toString());
//    if(validator.value==true){
//      if(confirmPassword.isEmpty){
// if(validator.value)_confirmController.sink.addError("Confirm password is mandatory");
//     }
//     else if(_confirmController.value==_passwordController.value){
//       _confirmController.sink.add(confirmPassword);
//     }
//      else if(_confirmController.value!=_passwordController.value){
//         if(validator.value)_confirmController.sink.addError("Password not same");

//     }
//     else{
//       print("unmatch");
      
//      if(validator.value) _confirmController.sink.addError("Er");

//     }
//    }
//   }

// emailAddressTap()async{

//      var check1;
//                         try{

//                        check1=await fullNameStream.first;
//                        }
//                         catch (err){
//                           check1=err.toString();
//                          }
             
//                       if(check1==""){
//     validator.sink.add(true);

//                         updateFullName("");
//                       }}

// userNameTap()async{
//   validator.sink.add(true);
//      var check1;
//                         var check2;
//                         try{

//                        check1=await fullNameStream.first;
//                        }
//                         catch (err){
//                           check1=err.toString();
//                          }
//                         try{
//  check2=await userNameStream.first;
                      
//                         }
//                         catch(err){
//                              check2=err.toString();
                      
//                         }
//                       if(check1=="")updateFullName("");
//                       if(check2=="")updateUserEmail("");
// }



// passwordTap()async{
//   validator.sink.add(true);
//      var check1;
//                         var check2;
//                         var check3;
//                        print(fullNameController.value.toString());

//                         try{

//                        check1=await fullNameStream.first;
//                        }
//                         catch (err){
//                           check1=err.toString();
//                          }
//                         try{
//  check2=await userNameStream.first;
                      
//                         }
//                         catch(err){
//                              check2=err.toString();
                      
//                         }
//                           try{
//  check3=await emailStream.first;
                      
//                         }
//                         catch(err){
//                              check3=err.toString();
                      
//                         }
//                       //  try{

//                       //  }
//                       if(check1=="")updateFullName("");
//                       if(check2=="")updateUserName("");
//                       if(check3=="")updateUserEmail("");
//                       updatePassword("",isTooltip: true);
// }

// confirmPasswordTap()async{
//   validator.sink.add(true);
//      var check1;
//                         var check2;
//                         var check3;
//                         var check4;
//                         try{

//                        check1=await fullNameStream.first;
//                        }
//                         catch (err){
//                           check1=err.toString();
//                          }
//                         try{
//  check2=await userNameStream.first;
                      
//                         }
//                         catch(err){
//                              check2=err.toString();
                      
//                         }
//                           try{
//  check3=await emailStream.first;
                      
//                         }
//                         catch(err){
//                              check3=err.toString();
                      
//                         }
//                            try{
//  check4=await passwordStream.first;
                      
//                         }
//                         catch(err){
//                              check4=err.toString();
                      
//                         }
//                       if(check1=="")updateFullName("");
//                       if(check2=="")updateUserName("");
//                       if(check3=="")updateUserEmail("");
//                       if(check4=="")updatePassword("");
//                       if(check4!=" ")
//                       {
//                         print("ERRRMAHI");
//                       updatePassword(_passwordController.value.toString(),isError: true);

//                       }
// }
//  Stream<bool> get validateForm => Rx.combineLatest2(
//     userNameStream,
//     passwordStream,
//         (a, b,) => true,
//   );

//  registerAPI(BuildContext context)async{
// //   if(isSuccess==true){
// // isLoading.sink.add(false);
// //   }
// //   else{
// //     isLoading.sink.add(true);
// //   try{
//     var fullName="", userName="", email="",password="";
//       Map<String, dynamic> params = {
//   "username": _userNameController.stream.value,
//   "fullname": fullNameController.stream.value,
//   "email": _userEmailController.stream.value,
//   "password": _passwordController.stream.value

//     };
    
    
//     print(params);
    
//     var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.REGISTER.toString());
//    print(url);
    
//     var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
//               'Accept': 'application/json',
//               });
//   print(response.statusCode);
//   if(response.statusCode==201){
//  Navigation.navigateReplaceToScreen(context, 'selectArtistPref/');
//   }
//   else if(response.statusCode==400){
//     var data=jsonDecode(response.body.toString());
//     print(data['detail']["message"]);
//     if(data['detail']["message"]=="username already exists")
//     {
//     _userNameController.sink.addError("username already exists");

//     }
//     else if(data['detail']["message"]=="email already exists")
//     {
//       _userEmailController.sink.addError("email already exists");

//     }
//   }

// //   if(response.statusCode==200){
// //     isSuccess.sink.add(true);
// //     isInvalidCred.sink.add(true);
// //   }
// //   else if(response.statusCode==404){
// //     isInvalidCred.sink.addError(ConstantText.invalidEmailAndPassword);
// //    isSuccess.sink.add(false);
// //   }
// //   else{
// //    isSuccess.sink.add(false);
// //     isInvalidCred.sink.add(true);
// //   }
// //      isLoading.sink.add(false);
// //  return response.statusCode;
// //   }
// //   catch(e){
// //     print(e.toString());
// //      isLoading.sink.add(false);
// //     return http.Response("Error", 1);
// //   }
//   // }
// }


}
