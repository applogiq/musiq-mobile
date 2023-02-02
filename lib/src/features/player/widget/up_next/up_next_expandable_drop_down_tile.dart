import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/player_provider.dart';
import '../../screen/player_screen/up_next.dart';

class UpNextExpandableDropDownTile extends StatelessWidget {
  const UpNextExpandableDropDownTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const UpNext(),
      trailing: InkWell(
          onTap: () {
            context.read<PlayerProvider>().toggleUpNext();
          },
          child: const Icon(Icons.keyboard_arrow_down_rounded)),
    );
  }
}
