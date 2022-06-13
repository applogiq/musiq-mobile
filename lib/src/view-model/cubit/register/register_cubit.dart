import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helpers/utils/validation.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with InputValidationMixin {
  RegisterCubit() : super(RegisterInitial());
    final _fullNameController = BehaviorSubject<String>.seeded("");
    final _userNameController = BehaviorSubject<String>.seeded("");
    final _userEmailController = BehaviorSubject<String>.seeded("");
  final _passwordController = BehaviorSubject<String>.seeded("");
  final _confirmController = BehaviorSubject<String>.seeded("");
    final validator=BehaviorSubject<bool>.seeded(true);


   Stream<String> get fullNameStream => _fullNameController.stream;
   Stream<String> get userNameStream => _userNameController.stream;
   Stream<String> get emailStream => _userEmailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get confirmPasswordStream => _confirmController.stream;
  Stream<bool> get validatorStream => validator.stream;
  
   updateFullName(String fullName){
    if(validator.value==true){
if(fullName.isEmpty){
       _fullNameController.sink.addError("Full Name is mandatory");
    }
   
    else{
_fullNameController.sink.add(fullName);
    }
    }
    
  }
  
   updateUserName(String userName){
     
     if(validator.value==true){
      if(userName.isEmpty){
       _userNameController.sink.addError("User Name is mandatory");
    }
    
    else if(userName.contains(" ")){
         _userNameController.sink.addError("User Name does not contain space");
    }
    else{
_userNameController.sink.add(userName);
    }
     }
    
  }
  
   updateUserEmail(String userEmail){
     if(validator.value==true){
       if(userEmail.isEmpty){
     _userEmailController.sink.addError("Email Id is mandatory");
   }
   else if (!isEmailValid(userEmail)) {
      print('F');
      _userEmailController.sink.addError("Invalid Email ID");
    } else {
      _userEmailController.sink.add(userEmail);
    }
     }
  }
   updatePassword(String password){
   if(validator.value==true){
    if(password.isEmpty){
 _passwordController.sink.addError("Password is mandatory");
    }
     else if(validateStructure(password)){
      print("valid");
      _passwordController.sink.add(password);
    }
    else{
      _passwordController.sink.addError("show toggle");
    }
   }
     }
   updateConfirmPassword(String confirmPassword){
   
   if(validator.value==true){
     if(confirmPassword.isEmpty){
_confirmController.sink.addError("error");
    }
    else if(confirmPassword==_passwordController.value){
      _confirmController.sink.add(confirmPassword);
    }
    else{
      print("unmatch");
      _confirmController.sink.addError("error");

    }
   }
  }
//  void updateUserName(String userName) {
//     //  isInvalidCred.sink.add(false);
//    if(true){
//      if(userName.isEmpty){
//      _userEmailController.sink.addError("Email Id is mandatory");
//    }
//    else if (!isEmailValid(userName)) {
//       print('F');
//       _userEmailController.sink.addError("Invalid Email ID");
//     } else {
//       _userEmailController.sink.add(userName);
//     }
//    }
//   //  else{

//   //  print("Check");
//   //  }
//   }
//   // void updateValidator(bool val){
//   //   validator.sink.add(val);
//   // }
//   //  void updateError(){
//   //   isInvalidCred.sink.add(true);
//   // }

  // void updatePassword(String password) {
  // //    isInvalidCred.sink.add(false);
  
  // //  if(validator.value==true){
  // //    print("MAKE");
  // //    print(password);
  // //     if (password.isEmpty) {
  // //     _passwordController.sink.addError("Password is mandatory");
  // //   }
   
  // //    else {
  // //     _passwordController.sink.add(password);
  // //   }

  // //  }
  // //  else{

  // //  print("Check");
  // //  }
  // }

userNameTap()async{
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
                      updatePassword("");
}

confirmPasswordTap()async{
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
}
