import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:musiq/src/features/auth/screens/otp_field.dart';
import 'package:musiq/src/features/auth/widgets/otp_widget.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/buttons/custom_elevated_button.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../provider/forgot_password_provider.dart';



class OTPScreen extends StatefulWidget {
  OTPScreen({
    Key? key,
    this.email = "",
  }) : super(key: key);
  String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  String otpValue = "";
  // late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _forgotpasswordCubit = ForgotpasswordCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _forgotpasswordCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ForgotPasswordProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 80),
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: AppBar(
      toolbarHeight: 64,
      titleSpacing: 0.1,
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            
         provider.isNotClearError();
          },
          child: Icon(Icons.arrow_back_ios_rounded)),
      title: Text(ConstantText.otp),
      
    )
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
                  child: InkWell(
                    onTap: () {
                     
                    },
                    child: Text("An OTP has been sent to example@gmail.com. Please enter the OTP below")),
                ),
                SizedBox(height: 32,),
                 Padding(
                   padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 45,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                         child:Center(
                           child: TextField(
                             textAlign: TextAlign.center,
                              decoration: InputDecoration(
                             border: InputBorder.none
                            ),
                             keyboardType: TextInputType.number,
                              inputFormatters:[
                               LengthLimitingTextInputFormatter(1),
                               FilteringTextInputFormatter.digitsOnly
                              ],
                             style: TextStyle(color: Colors.white),
                             cursorColor: Colors.white,
                             autofocus: true,
                             onChanged: (value){
                           provider.otpValidation(value);
                                 if(value.length==1 ){
                             FocusScope.of(context).nextFocus();
                             }
                             else if(value.length==0){
                              FocusScope.of(context).unfocus();
                             }
                             },
                           ),
                         ),
                     
                        ),

                        Container(
                        height: 45,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                         child:Center(
                           child: TextField(
                             textAlign: TextAlign.center,
                              decoration: InputDecoration(
                             border: InputBorder.none
                            ),
                             keyboardType: TextInputType.number,
                              inputFormatters:[
                               LengthLimitingTextInputFormatter(1),
                               FilteringTextInputFormatter.digitsOnly
                              ],
                             style: TextStyle(color: Colors.white),
                             cursorColor: Colors.white,
                             autofocus: true,
                             onChanged: (value){
                                provider.otp2validation(value);
                           print(value);
                                 if(value.length==1 ){
                             FocusScope.of(context).nextFocus();
                             }
                             else if(value.length==0){
                              FocusScope.of(context).previousFocus();
                             }
                             },
                           ),
                         ),
                     
                        ),
                        Container(
                       height: 45,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                         child:Center(
                           child: TextField(
                             textAlign: TextAlign.center,
                              decoration: InputDecoration(
                             border: InputBorder.none
                            ),
                             keyboardType: TextInputType.number,
                              inputFormatters:[
                               LengthLimitingTextInputFormatter(1),
                               FilteringTextInputFormatter.digitsOnly
                              ],
                             style: TextStyle(color: Colors.white),
                             cursorColor: Colors.white,
                             autofocus: true,
                             onChanged: (value){
                                provider.otp3validation(value);
                           print(value);
                                 if(value.length==1 ){
                             FocusScope.of(context).nextFocus();
                             }
                             else if(value.length==0){
                              FocusScope.of(context).previousFocus();
                             }
                             },
                           ),
                         ),
                     
                        ),
                        Container(
                       height: 45,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                         child:Center(
                           child: TextField(
                             textAlign: TextAlign.center,
                              decoration: InputDecoration(
                             border: InputBorder.none
                            ),
                             keyboardType: TextInputType.number,
                              inputFormatters:[
                               LengthLimitingTextInputFormatter(1),
                               FilteringTextInputFormatter.digitsOnly
                              ],
                             style: TextStyle(color: Colors.white),
                             cursorColor: Colors.white,
                             autofocus: true,
                             onChanged: (value){
                                provider.otp4validation(value);
                           print(value);
                                 if(value.length==1 ){
                             FocusScope.of(context).nextFocus();
                             }
                             else if(value.length==0){
                              FocusScope.of(context).previousFocus();
                             }
                             },
                           ),
                         ),
                     
                        ),
                        Container(
                        height: 45,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                         child:Center(
                           child: TextField(
                             textAlign: TextAlign.center,
                              decoration: InputDecoration(
                             border: InputBorder.none
                            ),
                             keyboardType: TextInputType.number,
                              inputFormatters:[
                               LengthLimitingTextInputFormatter(1),
                               FilteringTextInputFormatter.digitsOnly
                              ],
                             style: TextStyle(color: Colors.white),
                             cursorColor: Colors.white,
                             autofocus: true,
                             onChanged: (value){
                                provider.otp5validation(value);
                           print(value);
                                 if(value.length==1 ){
                             FocusScope.of(context).nextFocus();
                             }
                             else if(value.length==0){
                              FocusScope.of(context).previousFocus();
                             }
                             },
                           ),
                         ),
                     
                        ),
                        Container(
                        height: 45,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                         child:Center(
                           child: TextField(
                             textAlign: TextAlign.center,
                              decoration: InputDecoration(
                             border: InputBorder.none
                            ),
                             keyboardType: TextInputType.number,
                              inputFormatters:[
                               LengthLimitingTextInputFormatter(1),
                               FilteringTextInputFormatter.digitsOnly
                              ],
                             style: TextStyle(color: Colors.white),
                             cursorColor: Colors.white,
                             autofocus: true,
                             onChanged: (value){
                                provider.otp6validation(value);
                           print(value);
                                 if(value.length==1 ){
                             FocusScope.of(context).unfocus();
                             }
                             else if(value.length==0){
                              FocusScope.of(context).previousFocus();
                             }
                             },
                           ),
                         ),
                     
                        ),
                      
                    ],
                   ),
                 ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
                      child: Text(provider.otp1.error,style: TextStyle(color: Color.fromRGBO(234, 41, 41, 1)),),
                    ),
                     Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                             provider.login(context);
                             provider.isClear("");
                            },
                            child: Text(
                              ConstantText.resendOTP,
                              style:
                                  fontWeight400(color: CustomColor.subTitle2),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                 
                  Spacer(),
                  Consumer<ForgotPasswordProvider>(
                      builder: (context, provider, _) {
                    return CustomElevatedButton(
                      horizontalMargin: 4,
                      label: ConstantText.continueButton,
                      onTap: () {
                        provider.postotp();
                        provider.continueTapped(otpValue, context);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
