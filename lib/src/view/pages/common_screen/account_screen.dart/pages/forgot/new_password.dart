import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/logic/cubit/forgot/cubit/forgotpassword_cubit.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/register_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../../../../../helpers/constants/string.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/custom_text_field_with_error.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
 late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    
    super.initState();
  
    this._forgotpasswordCubit=ForgotpasswordCubit();
    print(widget.email);
  }
  @override
  void dispose() {
    
    super.dispose();
    _forgotpasswordCubit.close();
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size(double.maxFinite, 80),
            child: Padding(
              padding: EdgeInsets.only(top:8.0),
              child: CustomAppBarWidget(
                title: ConstantText.resetPassswordAppbar,
              ),
            ),
          ),
    body: SingleChildScrollView(
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(ConstantText.resetPassswordTitle,style: fontWeight400(size: 14.0),),
          ),
                Padding(
                  padding: const EdgeInsets.only(top:24.0),
                  child: PasswordTextFieldWithError(isPassword: true,cubit: _forgotpasswordCubit, stream: _forgotpasswordCubit.passwordStream,
                   label: ConstantText.resetPassswordNew,
                    onTap:(){_forgotpasswordCubit.passwordTap();},
                    isValidatorEnable: true,
                                onChange: (text) {
                                  _forgotpasswordCubit.updateUserNewPassword(text);
                                }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:24.0),
                  child: PasswordTextFieldWithError(isPassword: true,cubit: _forgotpasswordCubit, stream: _forgotpasswordCubit.confirmPasswordStream,
                   label: ConstantText.confirmPassword,
                    onTap:(){
                      _forgotpasswordCubit.confirmPasswordTap();
                    },
                    isValidatorEnable: true,
                                onChange: (text) {
                                  _forgotpasswordCubit.updateUserConfirmPassword(text);
                                }),
                ),
          
          
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: StreamBuilder(
              stream: _forgotpasswordCubit.validateForm,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: (){
                   
                    if(snapshot.hasError){
                      print("VALIDATE");
                    }
                    else{
                     print("Valid");
                     _forgotpasswordCubit.changePassword(widget.email, _forgotpasswordCubit.passwordController.value, context);
                    }
                  },
                  child: StreamBuilder(
                    stream: _forgotpasswordCubit.loadingStream,
                    builder: (context, snapshot) {
                      return snapshot.data==true?CustomButton(label: ConstantText.resetPasssword,isLoading: true,verticalMargin: 0.0,horizontalMargin: 0.0,): CustomButton(label: ConstantText.resetPasssword,verticalMargin: 0.0,horizontalMargin: 0.0,);
                    }
                  ));
              }
            ),
          )
        ],),
      ),
    ),
    );
  }
}