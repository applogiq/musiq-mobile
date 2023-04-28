import 'package:flutter/material.dart';

class PreferenceProvider extends ChangeNotifier {
  String initialAudioQualityValue = "low";
  qualityPreferenceOnchanged(String value) {
    initialAudioQualityValue = value;
    notifyListeners();
  }
}
