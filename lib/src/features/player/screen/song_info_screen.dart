import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/loader.dart';
import '../../../core/constants/color.dart';
import '../../../core/utils/size_config.dart';
import '../provider/player_provider.dart';
import '../widget/song_info/song_info.dart';

class SongInfoScreen extends StatefulWidget {
  const SongInfoScreen({super.key, required this.id});

  final int id;

  @override
  State<SongInfoScreen> createState() => _SongInfoScreenState();
}

class _SongInfoScreenState extends State<SongInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PlayerProvider>().songInfo(widget.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.bg,
        body: Consumer<PlayerProvider>(
          builder: (context, pro, _) {
            return pro.issongInfoDetailsLoad
                ? const LoaderScreen()
                : pro.songInfoModel == null
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SongInfoCover(),
                            SongInfoLabelDetails(),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
