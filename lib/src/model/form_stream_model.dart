import 'package:flutter/cupertino.dart';

class FormstreamModel{
  FormstreamModel({required this.stream,required this.function, });
  final stream;
  final  ValueSetter<String>?  function;
}