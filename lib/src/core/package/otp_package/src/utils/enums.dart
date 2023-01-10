part of '../pinput.dart';

enum PinputAutovalidateMode {
  disabled,

  onSubmit,
}

enum AndroidSmsAutofillMethod {
  none,

  smsRetrieverApi,

  smsUserConsentApi,
}

enum PinAnimationType {
  none,
  scale,
  fade,
  slide,
  rotation,
}

enum HapticFeedbackType {
  disabled,
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

typedef PinputErrorBuilder = Widget Function(String? errorText, String pin);
