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
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      onTap: () {
        context.read<PlayerProvider>().toggleUpNext();
      },
      title: const UpNext(),
      trailing: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onPressed: () {
          context.read<PlayerProvider>().toggleUpNext();
        },
      ),
    );
  }
}
