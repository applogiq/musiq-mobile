import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/model/form_stream_model.dart';
import 'package:musiq/src/view-model/cubit/register/register_cubit.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';
import 'package:musiq/src/view/widgets/custom_password_textfield.dart';

import '../../../../helpers/constants/string.dart';
import '../../../../view-model/cubit/login_bloc.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field_with_error.dart';
import '../../profile/components/my_profile.dart';
import 'components/background_image.dart';
import 'components/logo_image.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegisterCubit _regCubit = BlocProvider.of<RegisterCubit>(
      context,
      listen: false,
    );
List<FormstreamModel> getStreamDetails=[
  FormstreamModel(stream: _regCubit.fullNameStream, function:(v){
    _regCubit.updateFullName("");
  }
  
  ),
  FormstreamModel(stream: _regCubit.userNameStream, function: (v){
     _regCubit.updateUserName("");
  }
  ),
    FormstreamModel(stream: _regCubit.emailStream, function:(v){
      _regCubit.updateUserEmail("");
    }),
  
  FormstreamModel(stream: _regCubit.passwordStream, function: (v){
    _regCubit.updatePassword(_regCubit.passwordStream.toString());
  })
  ,
    FormstreamModel(stream: _regCubit.confirmPasswordStream, function:(v){
       _regCubit.updateConfirmPassword(_regCubit.confirmPasswordStream.toString());
    },
  ),
];
    return SafeArea(
      child: Scaffold(
         appBar: PreferredSize(
          preferredSize: Size(double.maxFinite, 50),
          child: CustomAppBarWidget(
            title: "New Account",
          ),
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                    TextFieldWithError(label: ConstantText.fullName,cubit: _regCubit,stream: _regCubit.fullNameStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateFullName(text);

                      },onTap: (){}, ),
                      TextFieldWithError(label: ConstantText.userName,cubit: _regCubit,stream: _regCubit.userNameStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateUserName(text);
                      } ,onTap: ()async{
                       _regCubit.userNameTap();
                        
                      
                     
                      },),TextFieldWithError(label: ConstantText.email,cubit: _regCubit,stream: _regCubit.emailStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateUserEmail(text);
                      },onTap: ()async{
                        _regCubit.emailAddressTap();
                      }, ),
                      // CustomPasswordTextField(label: ConstantText.password,stream: _regCubit.passwordStream,cubit: _regCubit,obscure: true,onChange: (text){
                      //   _regCubit.updatePassword(text);
                      // },onTap: ()async{

                      //  _regCubit.passwordTap();
                      // },),
                       TextFieldWithError(isPassword: true,label: ConstantText.password,cubit: _regCubit,stream: _regCubit.passwordStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updatePassword(text);
                      }, onTap: () { _regCubit.passwordTap(); },),
                      TextFieldWithError(isPassword: true,label: ConstantText.confirmPassword,cubit: _regCubit,stream: _regCubit.confirmPasswordStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateConfirmPassword(text);
                      }, onTap: () { _regCubit.confirmPasswordTap(); },),
                      // PasswordMessage(),
                      SizedBox(height: 16,),
                      CustomButton(label: ConstantText.createAccount,margin: 0.0,)
                
              ],
            ),
          ),
        ) ),
    );
  }
}

class PasswordMessage extends StatelessWidget {
  const PasswordMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      horizontalPadding: 12.0,
      verticalPadding: 12.0,
      bgColor: CustomColor.textfieldBg,
      
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Icon(Icons.info,color: CustomColor.subTitle2,)

        ,Expanded(child: Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Text(ConstantText.passwordToolTip,style:fontWeight400(size: 12.0,color: CustomColor.subTitle2,),textAlign: TextAlign.left,),
        ))
      ],),
    );
  }
}
//  Stack(
//         children: [
//           Background(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: ListView(
//               shrinkWrap: true,
//               children: [
//                 SizedBox(
//                   height: 118,
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: LogoWidget(
//                       size: 60,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     "Get started",
//                     style: fontWeight600(size: 24.0),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 CustomTextField(
//                   title: "Full Name",
//                 ),
//                 CustomTextField(
//                   title: "Username",
//                 ),
//                 CustomTextField(
//                   title: "Email Address",
//                 ),
//                 CustomTextField(
//                   title: "Password",
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 60.0, bottom: 12),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => SelectYourFavList()));
//                     },
//                     child: CustomButton(
//                       label: "Create account",
//                       margin: 0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
   