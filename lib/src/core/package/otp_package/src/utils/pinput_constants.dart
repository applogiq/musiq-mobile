part of '../pinput.dart';

class PinputConstants {
  const PinputConstants._();

  static const defaultSmsCodeMatcher = '\\d{4,7}';

  static const _animationDuration = Duration(milliseconds: 180);

  static const _defaultLength = 4;

  static const _defaultSeparator = SizedBox(width: 8);

  static const _hiddenTextStyle =
      TextStyle(fontSize: 1, height: 1, color: Colors.transparent);

  static const _defaultPinFillColor = Color.fromRGBO(222, 231, 240, .57);
  static const _defaultPinputDecoration = BoxDecoration(
    color: _defaultPinFillColor,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const _defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: TextStyle(),
    decoration: _defaultPinputDecoration,
  );
}
