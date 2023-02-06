import 'package:flutter/material.dart';
import 'package:musiq/src/features/search/provider/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../common_widgets/list/list_header_widget.dart';
import '../../../core/constants/constant.dart';
import '../../../core/local/model/search_model.dart';
import '../../common/screen/no_song_screen.dart';

class SongSearchHistoryBuilder extends StatelessWidget {
  const SongSearchHistoryBuilder({
    Key? key,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SearchSongLocalModel>>(
        stream: objectbox.getSongSearch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }
          return (snapshot.data == null || snapshot.data!.isEmpty)
              ? const NoSongScreen(mainTitle: "No History", subTitle: "")
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListHeaderWidget(
                        title: "Recent Searches",
                        actionTitle: "Clear",
                        dataList: const [],
                        callback: () {
                          context.read<SearchProvider>().clearSongHistoryList();
                        },
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                        itemBuilder: (context, index) {
                          List s = snapshot.data!.reversed.toList();
                          return InkWell(
                            onTap: () {
                              _controller.text = s[index].searchName;
                              FocusScope.of(context).unfocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.restore),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                      s[index].searchName,
                                      style: fontWeight400(size: 14.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                );
        });
  }
}
