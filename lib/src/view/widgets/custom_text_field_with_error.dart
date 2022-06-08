
import 'package:flutter/material.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

import '../../helpers/constants/string.dart';
import '../../view-model/cubit/login_bloc.dart';

class TextFieldWithError extends StatelessWidget {
   TextFieldWithError({
    Key? key,
    required LoginBloc loginScreenCubit,
    this.isValidatorEnable=false, required this.stream, required this.label, this.onChange
  }) : _loginScreenCubit = loginScreenCubit, super(key: key);

  final LoginBloc _loginScreenCubit;
  bool isValidatorEnable;
  final Stream stream;
  final String label;
  final ValueSetter<String>? onChange;
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              onChange: onChange,
              title: label  ,
            ),
        isValidatorEnable? snapshot.hasError? Padding(
             padding: const EdgeInsets.only(left:8.0),
             child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.red),),
           ):EmptyBox(  ):EmptyBox()
          ],
        );
      }
    );
  }
}
