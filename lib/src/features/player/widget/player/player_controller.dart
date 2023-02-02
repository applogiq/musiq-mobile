import 'package:flutter/material.dart';

import '../../../../common_widgets/box/vertical_box.dart';
import 'player_widgets.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        children: const [VerticalBox(height: 18), PlayerControllerWidget()],
      ),
    );
  }
}
