import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../constants/style.dart';
import '../container/custom_color_container.dart';
import '../container/password_message.dart';

class PasswordTextFieldWithError extends StatefulWidget {
  const PasswordTextFieldWithError(
      {Key? key,
      this.isPassword = false,
      this.isValidatorEnable = false,
      required this.label,
      required this.errorMessage,
      this.onChange,
      required this.onTap})
      : super(key: key);

  final bool isValidatorEnable;
  final bool isPassword;

  final String label;
  final String errorMessage;
  final ValueSetter<String>? onChange;
  final VoidCallback onTap;

  @override
  State<PasswordTextFieldWithError> createState() =>
      _PasswordTextFieldWithErrorState();
}

class _PasswordTextFieldWithErrorState
    extends State<PasswordTextFieldWithError> {
  bool obscure = true;
  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                onChanged: widget.onChange,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility
                      ,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ),
        Builder(builder: (context) {
          if (widget.errorMessage == "") {
            return SizedBox.shrink();
          } else if (widget.errorMessage == "show toggle") {
            return PasswordMessage();
          } else if (widget.errorMessage == "show toggle with field required") {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Field is Required",
                      style: const TextStyle(color: Colors.red)),
                ),
                PasswordMessage(),
              ],
            );
          } else if (widget.errorMessage == "show toggle with invalid") {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Invalid Format",
                      style: const TextStyle(color: Colors.red)),
                ),
                PasswordMessage(),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.errorMessage.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        })

        // Builder(builder: (context) {
        //   print("errrr" + snapshot.error.toString());
        //   if (widget.isValidatorEnable) {
        //     if (snapshot.hasError) {
        //       if (snapshot.error == "show toggle") {
        //         // print(widget._cubit.passwordValid.value);
        //         // return PasswordMessage();
        //       } else if (snapshot.error == "show toggle alert") {
        //         return
        // Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Padding(
        //               padding:
        //                   const EdgeInsets.symmetric(horizontal: 8.0),
        //               child: Text("Invalid Format",
        //                   style: const TextStyle(color: Colors.red)),
        //             ),
        //             // PasswordMessage(),
        //           ],
        //         );
        //       } else if (snapshot.error == "Password does not match") {
        //         return Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //           child: Text(snapshot.error.toString(),
        //               style: const TextStyle(color: Colors.red)),
        //         );
        //       }
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Text(snapshot.error.toString(),
        //             style: const TextStyle(color: Colors.red)),
        //       );
        //     } else {
        //       return EmptyBox();
        //     }
        //   } else {
        //     return EmptyBox();
        //   }
        // })
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
}
