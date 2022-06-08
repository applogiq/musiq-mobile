
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view-model/cubit/login_bloc.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

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
                    const SizedBox(
                      height: 200,
                    ),
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
                    StreamBuilder(
                      stream: _loginScreenCubit.userNameStream,
                      builder: (context, snapshot) {
                        return ProfileFormTextFieldWidget(
                          onChange: (text){
                            _loginScreenCubit.updateUserName(text);
                          },
                          title: ConstantText.email,
                        );
                      }
                    ),
                    StreamBuilder(stream: _loginScreenCubit.userNameStream,builder: (context,snapshot){
                     return snapshot.hasError==true? Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red),):const SizedBox(width: 0,height: 0,);

                    }),
                    StreamBuilder(
                      stream:_loginScreenCubit.passwordStream,
                      builder: (context, snapshot) {
                        return ProfileFormTextFieldWidget(
                          obsecureText: true,
                          title: ConstantText.password,
                          onChange: (text){
                            _loginScreenCubit.updatePassword(text);
                          },
                        );
                      }
                    ),
                    //   StreamBuilder(stream: _loginScreenCubit.passwordStream,builder: (context,snapshot){
                    //  return snapshot.hasError==true? Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red),):const SizedBox(width: 0,height: 0,);

                    // }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                         ConstantText.forgotPassword,
                          style: fontWeight500(
                              color: CustomColor.subTitle2, size: 14.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: StreamBuilder(
                        stream: _loginScreenCubit.validateForm,
                        builder: (context, snapshot) {
                          return InkWell(
                            onTap:snapshot.hasError?(){
                              print("Please Validate");
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
                              
                              }
                              
                            },
                            child: CustomButton(
                              isValid: snapshot.hasData,
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
