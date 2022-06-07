
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view-model/cubit/login_bloc.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/splash_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../profile/components/my_profile.dart';

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
              Background(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LogoWidget(
                        size: 60,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Welcome Back",
                        style: fontWeight600(size: 24.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: _loginScreenCubit.userNameStream,
                      builder: (context, snapshot) {
                        return ProfileFormTextFieldWidget(
                          onChange: (text){
                            _loginScreenCubit.updateUserName(text);
                          },
                          title: "Email Address",
                        );
                      }
                    ),
                    StreamBuilder(stream: _loginScreenCubit.userNameStream,builder: (context,snapshot){
                     return snapshot.hasError==true? Text(snapshot.error.toString(),style: TextStyle(color: Colors.red),):SizedBox(width: 0,height: 0,);

                    }),
                    StreamBuilder(
                      stream:_loginScreenCubit.passwordStream,
                      builder: (context, snapshot) {
                        return ProfileFormTextFieldWidget(
                          title: "Password",
                          onChange: (text){
                            _loginScreenCubit.updatePassword(text);
                          },
                        );
                      }
                    ),
                      StreamBuilder(stream: _loginScreenCubit.passwordStream,builder: (context,snapshot){
                     return snapshot.hasError==true? Text(snapshot.error.toString(),style: TextStyle(color: Colors.red),):SizedBox(width: 0,height: 0,);

                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot password ?",
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
                            onTap: ()async{_loginScreenCubit.updateValidator(true);
                            // _loginScreenCubit.updateUserName(_loginScreenCubit.userNameStream.toString());
                            // _loginScreenCubit.updatePassword(_loginScreenCubit.passwordStream.toString());
                            print(snapshot.data);
                              if(snapshot.data==true){
                               var isLog=await _loginScreenCubit.loginAPI();
                               print(isLog);
                               if(isLog){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
                               }
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
