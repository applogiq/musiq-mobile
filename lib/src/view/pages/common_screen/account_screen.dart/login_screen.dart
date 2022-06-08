
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view-model/cubit/login_bloc.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../../widgets/custom_text_field_with_error.dart';
import '../../../widgets/empty_box.dart';
import '../../profile/components/my_profile.dart';
import 'components/background_image.dart';
import 'components/logo_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   LoginBloc _loginScreenCubit = BlocProvider.of<LoginBloc>(
      context,
      listen: false,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              const Background(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: LogoWidget(
                        size: 60,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        ConstantText.welcomeBack,
                        style: fontWeight600(size: 24.0),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWithError(label: ConstantText.email,loginScreenCubit: _loginScreenCubit,stream: _loginScreenCubit.userNameStream,isValidatorEnable: true,onChange:(text){

                    _loginScreenCubit.updateUserName(text);
                    } ),
                   TextFieldWithError(label: ConstantText.password,loginScreenCubit: _loginScreenCubit,stream: _loginScreenCubit.passwordStream,isValidatorEnable: true,onChange:(text){

                    _loginScreenCubit.updatePassword(text);
                    }),
                  
                    
                    ForgotPassword(),

                 ErrorContainer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: StreamBuilder(
                        stream: _loginScreenCubit.validateForm,
                        builder: (context, snapshot) {
                          return InkWell(
                            onTap:snapshot.hasError?(){
                              print("Please Validate");
                              print(_loginScreenCubit.userNameStream.toString());
                               _loginScreenCubit.updateUserName(_loginScreenCubit.userNameStream.toString());
                            _loginScreenCubit.updatePassword(_loginScreenCubit.passwordStream.toString());
                            }: ()
                            
                            
                            
                            async{_loginScreenCubit.updateValidator(true);
                            
                              if(snapshot.data==true){
                               var isLog=await _loginScreenCubit.loginAPI();
                               print(isLog);
                               if(isLog==200){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
                               }
                               else{
                           print("404");    
                               }
                              }
                              else{
                                  _loginScreenCubit.updateUserName(_loginScreenCubit.userNameStream.toString());
                            _loginScreenCubit.updatePassword(_loginScreenCubit.passwordStream.toString());
                           
                              }
                              
                            },
                            child: CustomButton(
                               label: "Log In",
                              margin: 0,
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
         ConstantText.forgotPassword,
          style: fontWeight500(
              color: CustomColor.subTitle2, size: 14.0),
        ),
      ),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     LoginBloc _loginScreenCubit = BlocProvider.of<LoginBloc>(
      context,
      listen: false,
    );
    return StreamBuilder(
      stream: _loginScreenCubit.errorStream,
      builder: (context, snapshot) {
        return snapshot.hasData?EmptyBox(): Container(width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.symmetric(vertical:16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: CustomColor.errorStatusColor,
        borderRadius: BorderRadius.circular(8.0)
        ,)
        ,child: Row(children: [Icon(Icons.info,color: Colors.red,),
        SizedBox(width: 8,),
        Text(ConstantText.invalidEmailAndPassword,style: fontWeight400(size: 14.0,color: CustomColor.subTitle2,)
        ,
        
        ),
        Spacer(),
        InkWell(onTap: (){_loginScreenCubit.isInvalidCred.add(false);},child: Icon(Icons.close))
        ],),);
      }
    );
  }
}
