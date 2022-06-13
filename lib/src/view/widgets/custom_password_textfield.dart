import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/register_screen.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

import '../../helpers/constants/color.dart';
import '../../helpers/constants/style.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({Key? key, required this.stream,required this.
cubit, this.onChange, required this.onTap, required this.obscure, required this.label,  }) : super(key: key);
final Stream stream;
  final Cubit cubit;
  final VoidCallback onTap;
  final ValueSetter<String>? onChange;
  final bool obscure;
  final String label;

  @override
  State<CustomPasswordTextField> createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool isObscure=true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context,snapShot){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            widget.label,
            style: fontWeight500(size: 14.0),
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0),
            child: CustomColorContainer(
                horizontalPadding: 16,
                verticalPadding: 0,
                bgColor: CustomColor.textfieldBg,
              
              child: ConstrainedBox(
                  constraints:
                      BoxConstraints.expand(height: 46, width: double.maxFinite),
                  child: TextFormField(
                    onTap: widget.onTap,
                    cursorColor: Colors.white,
                    obscureText: isObscure,
                    
                    onChanged:widget.onChange,
                    
                    decoration: InputDecoration(
                    
                       suffixIcon:  IconButton(icon: Icon(isObscure?Icons.visibility:Icons.visibility_off,color: Colors.white,),onPressed: (){
                        setState(() {
                          isObscure =!isObscure;
                        });
                       },),
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            
            ),
          ),
         snapShot.hasError? PasswordMessage():EmptyBox()
        ],
      );
    });
  }
}