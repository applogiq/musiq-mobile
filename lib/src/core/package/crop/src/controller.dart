import 'dart:typed_data';

import 'package:flutter/material.dart';

class CropController {
  late CropControllerDelegate _delegate;

  set delegate(CropControllerDelegate value) => _delegate = value;

  void crop() => _delegate.onCrop(false);

  void cropCircle() => _delegate.onCrop(true);

  set image(Uint8List value) => _delegate.onImageChanged(value);

  set aspectRatio(double? value) => _delegate.onChangeAspectRatio(value);

  set withCircleUi(bool value) => _delegate.onChangeWithCircleUi(value);

  set rect(Rect value) => _delegate.onChangeRect(value);

  set area(Rect value) => _delegate.onChangeArea(value);
}

class CropControllerDelegate {
  late ValueChanged<bool> onCrop;

  late ValueChanged<Uint8List> onImageChanged;

  late ValueChanged<double?> onChangeAspectRatio;

  late ValueChanged<bool> onChangeWithCircleUi;

  late ValueChanged<Rect> onChangeRect;

  late ValueChanged<Rect> onChangeArea;
}
