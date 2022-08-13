
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/style.dart';
import '../../../../../logic/cubit/login_bloc.dart';

class CustomProgressButton extends StatefulWidget {
   CustomProgressButton({
    Key? key,  
this.isLoading=false




    
  }) : super(key: key);
  bool isLoading;

  @override
  State<CustomProgressButton> createState() => _CustomProgressButtonState();
}

class _CustomProgressButtonState extends State<CustomProgressButton> {
  bool is_load=false;
  bool is_success=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    LoginBloc _loginScreenCubit = BlocProvider.of<LoginBloc>(
      context,
      listen: false,
    );
    return StreamBuilder(
      stream: _loginScreenCubit.loadingStream,
     
      builder: (context, snapshot) {
        print(snapshot.data);
        return Container(
            margin: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: 52,
            decoration: BoxDecoration(
                color:!is_load&&is_success||widget.isLoading? CustomColor.secondaryColor:CustomColor.buttonDisableColor,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
              snapshot.data==true?Padding(
                padding: const EdgeInsets.symmetric(vertical:6.0,horizontal: 8),
                child: SizedBox(height: 24,width: 24,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,)),
              ):  Text(
                  "Login",
                  style: fontWeight500(color: is_success==true?Colors.white:CustomColor.subTitle2),
                ),
              ],
            )));
      }
    );
  }
}
