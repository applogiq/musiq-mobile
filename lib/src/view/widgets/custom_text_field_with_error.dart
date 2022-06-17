
import 'package:flutter/material.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/register_screen.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

import '../../helpers/constants/color.dart';
import '../../helpers/constants/string.dart';
import '../../helpers/constants/style.dart';
import 'custom_color_container.dart';

class PasswordTextFieldWithError extends StatefulWidget {
   PasswordTextFieldWithError({
    Key? key,
    required  cubit,
    this.isPassword=false,
    this.isValidatorEnable=false, required this.stream, required this.label, this.onChange, required this.onTap
  }) : _cubit = cubit, super(key: key);

  final  _cubit;
  bool isValidatorEnable;
  bool isPassword;
  final Stream stream;
  final String label;
  final ValueSetter<String>? onChange;
  final VoidCallback onTap;

  @override
  State<PasswordTextFieldWithError> createState() => _PasswordTextFieldWithErrorState();
}

class _PasswordTextFieldWithErrorState extends State<PasswordTextFieldWithError> {
  bool obscure=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obscure=widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        print("errrrrrr");
        print(snapshot.hasError?snapshot.error:"no");
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
                left: 16,
                verticalPadding: 0,
                bgColor: CustomColor.textfieldBg,
              
              child: ConstrainedBox(
                  constraints:
                      BoxConstraints.expand(height: 46, width: double.maxFinite),
                  child: TextFormField(
                    onTap: widget.onTap,
                    obscureText: obscure,
                    cursorColor: Colors.white,
                   
                    
                    onChanged:widget.onChange,
                    
                    
                    decoration: InputDecoration(
                    suffixIcon: widget.isPassword? IconButton(icon: Icon(obscure?Icons.visibility:Icons.visibility_off,color: Colors.white,),onPressed: (){
                        setState(() {
                          obscure =!obscure;
                        });
                       },):SizedBox(height: 0,width: 0,),
                       border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            
            ),
          ),
          Builder(builder: (context){
            print("errrr"+snapshot.error.toString());
            if(widget.isValidatorEnable){
              if(snapshot.hasError){
                if(snapshot.error=="show toggle"){
                  // print(widget._cubit.passwordValid.value);
                  return PasswordMessage();
                }
                else if(snapshot.error=="show toggle alert"){
return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal:8.0),
                       child: Text("Invalid Format",style: const TextStyle(color: Colors.red)),
                     ),
                      PasswordMessage(),
                    ],
                  );
                }
                else if(snapshot.error=="Password does not match"){
                return Padding(
                       padding: const EdgeInsets.symmetric(horizontal:8.0),
                       child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red)),
                     );
                  
                }
                return  Padding(
                       padding: const EdgeInsets.symmetric(horizontal:8.0),
                       child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red)),
                     );
                

              }
              else{
                return EmptyBox();
              }
              
            }
            else{
              return EmptyBox();
            }
          })
    //      Builder(builder: (context,) {
    
    //   if(widget.isValidatorEnable) {
        
    //   }
    //   else {
    //     return Text('B');
    //   } 
    // })
   
        // widget.isValidatorEnable? snapshot.hasError?snapshot.error!="show toggle"? Padding(
        //      padding: const EdgeInsets.only(left:8.0),
        //      child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red),),
        //    ):PasswordMessage():EmptyBox(  ):EmptyBox()
          ],
        );
      }
    );
  }
}

class TextFieldWithError extends StatefulWidget {
   TextFieldWithError({
    Key? key,
    required  cubit,
    this.isPassword=false,
    this.isValidatorEnable=false, required this.stream, required this.label, this.onChange, required this.onTap
  }) : _cubit = cubit, super(key: key);

  final  _cubit;
  bool isValidatorEnable;
  bool isPassword;
  final Stream stream;
  final String label;
  final ValueSetter<String>? onChange;
  final VoidCallback onTap;

  @override
  State<TextFieldWithError> createState() => _TextFieldWithErrorState();
}

class _TextFieldWithErrorState extends State<TextFieldWithError> {
  bool obscure=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obscure=widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
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
                left: 16,
                right: 24,
                verticalPadding: 0,
                bgColor: CustomColor.textfieldBg,
              
              child: ConstrainedBox(
                  constraints:
                      BoxConstraints.expand(height: 46, width: double.maxFinite),
                  child: TextFormField(
                    onTap: widget.onTap,
                    obscureText: obscure,
                    cursorColor: Colors.white,
                   
                    
                    onChanged:widget.onChange,
                    
                    
                    decoration: InputDecoration(
                    // suffixIcon: widget.isPassword? IconButton(icon: Icon(obscure?Icons.visibility:Icons.visibility_off,color: Colors.white,),onPressed: (){
                    //     setState(() {
                    //       obscure =!obscure;
                    //     });
                    //    },):SizedBox(height: 0,width: 0,),
                       border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            
            ),
          ),
    //      Builder(builder: (context) {
    
    //   if(widget.isValidatorEnable) {
    //     if(snapshot.hasError)
    //   }
    //   else {
    //     return Text('B');
    //   } 
    // })
   
        widget.isValidatorEnable? snapshot.hasError?snapshot.error!="show toggle"? Padding(
             padding: const EdgeInsets.only(left:8.0),
             child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red),),
           ):PasswordMessage():EmptyBox(  ):EmptyBox()
          ],
        );
      }
    );
  }
}
