import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/logic/cubit/forgot/cubit/forgotpassword_cubit.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';
import 'package:musiq/src/view/widgets/custom_text_field_with_error.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

import '../../../../../../logic/cubit/login_bloc.dart';
import '../../../../../widgets/custom_app_bar.dart';

class ForgotPasswordMainScreen extends StatefulWidget {
  const ForgotPasswordMainScreen({Key? key,}) : super(key: key);

  @override
  State<ForgotPasswordMainScreen> createState() => _ForgotPasswordMainScreenState();
}

class _ForgotPasswordMainScreenState extends State<ForgotPasswordMainScreen> {
  late ForgotpasswordCubit _forgotpasswordCubit;
 
  @override
  void initState() {
    
    super.initState();
  
    this._forgotpasswordCubit=ForgotpasswordCubit();
    
  }
  @override
  void dispose() {
    
    super.dispose();
    // _forgotpasswordCubit.close();
  
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  PreferredSize(
            preferredSize: Size(double.maxFinite, 80),
            child: Padding(
              padding: EdgeInsets.only(top:8.0),
              child: CustomAppBarWidget(
                title: ConstantText.forgotPassword2,
              ),
            ),
          ),
          body:SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start
                ,children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(ConstantText.forgotPasswordMain,textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:24.0),
                  child: TextFieldWithError(cubit: _forgotpasswordCubit, stream: _forgotpasswordCubit.userEmailStream,
                   label: ConstantText.email,
                    onTap:(){},
                    isValidatorEnable: true,
                                onChange: (text) {
                                  _forgotpasswordCubit.updateUserEmail(text);
                                }),
                ),
             StreamBuilder(stream:_forgotpasswordCubit.errorStream,builder: (context,snap){
              print(snap);
              return snap.hasError?Padding(
             padding: const EdgeInsets.only(left:8.0),
             child: Text(snap.error.toString(),style: const TextStyle(color: Colors.red),textAlign: TextAlign.left,),
           ):EmptyBox();
             }),
                Padding(
                  padding: const EdgeInsets.only(top:100.0),
                  child: StreamBuilder(
                    stream:_forgotpasswordCubit.loadingStream,
                    builder: (context, snapshot) {
                      return snapshot.data==true?CustomButton(label: "label",margin: 0.0,isLoading: true,): InkWell( onTap: (){
                        _forgotpasswordCubit.sendOTP(context);
                      },child: CustomButton(label: ConstantText.continueButton,margin: 0.0,));
                    }
                  )
                ),
              ],),
            ),
          )
      ),
    );
  }
}