
import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 0,height: 0,);
  }
}
