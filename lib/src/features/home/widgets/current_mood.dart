import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../common_widgets/list/horizontal_list_view.dart';
import '../../../utils/image_url_generate.dart';
import '../domain/model/aura_model.dart';
import '../provider/view_all_provider.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';
import '../view_all_status.dart';

class CurrentMood extends StatelessWidget {
  const CurrentMood({super.key, required this.auraModel});
  final AuraModel auraModel;

  @override
  Widget build(BuildContext context) {
    return HorizonalListViewWidget(
      title: "Current Mood",
      actionTitle: "",
      listWidget: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 12),
        height: 180,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: auraModel.records.length,
            itemBuilder: (context, index) => Row(
                  children: [
                    index == 0
                        ? const SizedBox(
                            width: 10,
                          )
                        : const SizedBox(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<ViewAllProvider>().loaderEnable();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewAllScreen(
                                        status: ViewAllStatus.aura,
                                        id: auraModel.records[index].id,
                                        auraId: auraModel.records[index].auraId,
                                        title:
                                            auraModel.records[index].auraName,
                                      )));
                            },
                            child: CustomColorContainer(
                              shape: BoxShape.circle,
                              child: Image.network(
                                generateAuraImageUrl(
                                    auraModel.records[index].auraId),
                                height: 125,
                                width: 125,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            auraModel.records[index].auraName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
