
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';

class CustomProgressButton extends StatefulWidget {
  const CustomProgressButton({
    Key? key,
  }) : super(key: key);

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
    return InkWell(
      onTap:is_success==true? (){
        setState(() {
          is_load=true;
          // is_success=1;
        });
        Timer(Duration(seconds: 3), () {
  print("Yeah, this line is printed immediately")
  ;
  setState(() {
    
  is_load=false;
  });
});
      }:(){},
      child: Container(
          margin: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: 52,
          decoration: BoxDecoration(
              color:!is_load? CustomColor.secondaryColor:CustomColor.buttonDisableColor,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
            is_load?Padding(
              padding: const EdgeInsets.symmetric(vertical:6.0,horizontal: 8),
              child: SizedBox(height: 24,width: 24,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,)),
            ):  Text(
                "Log In",
                style: fontWeight500(color: is_success==true?Colors.white:CustomColor.subTitle2),
              ),
            ],
          ))),
    );
  }
}
