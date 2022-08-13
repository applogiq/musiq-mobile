 import 'package:flutter/material.dart';

import '../color.dart';

BoxDecoration PlayListNoImageDecoration() {
    return BoxDecoration(
                                          color: CustomColor.defaultCard,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: CustomColor
                                                  .defaultCardBorder,
                                              width: 2.0),);
  }

