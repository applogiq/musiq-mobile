
import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import '../../../../helpers/constants/string.dart';
import '../../../../logic/cubit/register/register_cubit.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field_with_error.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterCubit _regCubit;
  @override
  void initState() {
    super.initState();
    _regCubit=RegisterCubit();
  }
  @override
  void dispose() {
     super.dispose();
    _regCubit.close();
  }
  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
      child: Scaffold(
         appBar: const PreferredSize(
          preferredSize: Size(double.maxFinite, 80),
          child: Padding(
            padding: EdgeInsets.only(top:8.0),
            child: CustomAppBarWidget(
              title: "New Account",
            ),
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


                      TextFieldWithError(label: ConstantText.email,cubit: _regCubit,stream: _regCubit.emailStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateUserEmail(text);
                      },onTap: ()async{
                        _regCubit.emailAddressTap();
                      }, ),

                      TextFieldWithError(label: ConstantText.userName,cubit: _regCubit,stream: _regCubit.userNameStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateUserName(text);
                      } ,onTap: ()async{
                       _regCubit.userNameTap();
                        
                      
                     
                      },),
                      
                      
                      // CustomPasswordTextField(label: ConstantText.password,stream: _regCubit.passwordStream,cubit: _regCubit,obscure: true,onChange: (text){
                      //   _regCubit.updatePassword(text);
                      // },onTap: ()async{

                      //  _regCubit.passwordTap();
                      // },),
                       PasswordTextFieldWithError(isPassword: true,label: ConstantText.password,cubit: _regCubit,stream: _regCubit.passwordStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updatePassword(text);
                      }, onTap: () { 
                        _regCubit.passwordTap();
                         },),
                      PasswordTextFieldWithError(isPassword: true,label: ConstantText.confirmPassword,cubit: _regCubit,stream: _regCubit.confirmPasswordStream,isValidatorEnable: true,onChange:(text){

                      _regCubit.updateConfirmPassword(text);
                      }, onTap: () 
                      {
                         _regCubit.confirmPasswordTap(); 
                         },),
                      // PasswordMessage(),
                      SizedBox(height: 16,),
                      
                      StreamBuilder(
                        stream: _regCubit.validateForm,
                        builder: (context, snapshot) {
                         
                          return InkWell(onTap: ()async{
                            await _regCubit.createAccount();
                            if(snapshot.hasError==null){
                              print("NULL");
                            }
                            else if(snapshot.hasError==true){
                              print("SOLVE ERROR");
                            }
                            else if(snapshot.hasError==false){
                              _regCubit.registerAPI(context);
                             
                            }
                            else{
                              print("OKAY");
                            }
                            // print("SSSSS");
                            // print(snapshot.hasError==null&&snapshot.hasError==false);
                            // print(snapshot.hasError==false);
                            // print(snapshot.hasError==null);
                            // print("DDDDDDDD");
                            // if(snapshot.hasError==false){
                            //   _regCubit.registerAPI(context);
                            // }
                           
                          },child: StreamBuilder(stream: _regCubit.loadingStream,builder: (context,snapshot){
                            return _regCubit.isLoading.value==true?CustomButton(label: ConstantText.createAccount,margin: 0.0,isLoading: true,): CustomButton(label: ConstantText.createAccount,margin: 0.0,);
                          },));
                        }
                      )
                
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
      left: 12.0,
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
