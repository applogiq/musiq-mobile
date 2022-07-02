import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/model/api_model/user_model.dart';
import 'package:musiq/src/view/pages/artist_preference/artist_preference.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart'as http;

import '../../../helpers/constants/api.dart';
import '../../../helpers/utils/validation.dart';
import '../../../view/pages/common_screen/account_screen.dart/select_your fav_artist.dart';

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
    if(_userNameController.stream.value.isEmpty||fullNameController.stream.value.isEmpty||_userEmailController.stream.value.isEmpty||_passwordController.stream.value.isEmpty||_confirmController.stream.value.isEmpty){
    confirmPasswordTap();
    }
    else{

    
    isLoading.sink.add(true);
      Map<String, dynamic> params = {
  "username": _userNameController.stream.value,
  "fullname": fullNameController.stream.value,
  "email": _userEmailController.stream.value,
  "password": _passwordController.stream.value

    };
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.REGISTER.toString());
    try{

    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
late User user;
print(response.statusCode);
if(response.statusCode==201){
  var data=jsonDecode(response.body.toString());
  
  user=User.fromMap(data);
     await storage.deleteAll();
  
  var userData = user.records.toMap();
          for (final name in userData.keys) {
            final value = userData[name];
             await storage.write(
              key: name,
              value: value.toString(),
            );
          }
          await storage.write(key: "artist_list", value:jsonEncode(user.records.preference.artist));
         await storage.write(key: "password_cred", value:_passwordController.stream.value);
         var list1=await storage.read(key: "artist_list");
         print(list1);
              isLoading.sink.add(false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ArtistPreferenceMain(artist_list: user.records.preference.artist,)));
  
        // Navigation.navigateReplaceToScreen(context, 'selectArtistPref/');
    
   
  
}
else if(response.statusCode==400){
  
      var data=jsonDecode(response.body.toString());
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
           isLoading.sink.add(false);
 
    return http.Response("Try Again",500);
    }
  
    }}

  void updateFullName(String text) {
    if(text.isEmpty){
      fullNameController.sink.add("");
      fullNameController.sink.addError(ConstantText.fieldRequired);
    }
    else{

    fullNameController.sink.add(text);
    }
  }
   createAccount(){
 confirmPasswordTap();
 if(_confirmController.value.isEmpty){
  _confirmController.sink.addError(ConstantText.fieldRequired);
 }
 else if(_passwordController.value.toString()!=_confirmController.value.toString()){
  _confirmController.sink.addError(ConstantText.passwordNotMatch);
 }
 else{
  print("CHECK YOUR ERROR");
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

  

   
}
