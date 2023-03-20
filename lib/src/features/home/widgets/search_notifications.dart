import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../core/constants/color.dart';
import '../../../core/enums/enums.dart';
import '../../search/provider/search_provider.dart';
import '../../search/screens/search_screen.dart';

class SearchAndNotifications extends StatelessWidget {
  const SearchAndNotifications({
    Key? key,
    required this.searchStatus,
  }) : super(key: key);
  final SearchStatus searchStatus;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SearchTextWidget(
                textEditingController: null,
                isReadOnly: true,
                onTap: () {
                  context.read<SearchProvider>().resetState();
                  // context.read<HomeProvider>().goToSearch(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            searchRequestModel:
                                SearchRequestModel(searchStatus: searchStatus),
                          )));
                },
                hint: "Search Music and Podcasts",
                searchStatus: searchStatus,
              ),
            ),
            // const SizedBox(
            //   width: 8,
            // ),
            // CustomColorContainer(
            //   bgColor: CustomColor.textfieldBg,
            //   left: 12,
            //   verticalPadding: 6,
            //   child: Center(
            //     child: Stack(
            //       children: [
            //         const Icon(Icons.notifications),
            //         Positioned(
            //           right: 2,
            //           child: Container(
            //             padding: const EdgeInsets.all(4.5),
            //             decoration: BoxDecoration(
            //               color: CustomColor.secondaryColor,
            //               shape: BoxShape.circle,
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class SearchTextWidget extends StatelessWidget {
  const SearchTextWidget({
    Key? key,
    required this.hint,
    this.isReadOnly = false,
    required this.onTap,
    required this.searchStatus,
    required this.textEditingController,
    this.onChange,
  }) : super(key: key);
  final String hint;
  final bool isReadOnly;

  final VoidCallback onTap;
  final ValueSetter<String>? onChange;
  final SearchStatus searchStatus;
  final TextEditingController? textEditingController;

  // late TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      left: 1,
      verticalPadding: 2,
      bgColor: CustomColor.textfieldBg,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints.expand(height: 40, width: double.maxFinite),
        child: TextField(
          autofocus: true,
          controller: textEditingController,
          onTap: onTap,
          readOnly: isReadOnly,
          onChanged: onChange,
          onSubmitted: onChange,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
              ),
              border: InputBorder.none,
              hintStyle: const TextStyle(fontSize: 14),
              hintText: hint),
        ),
      ),
    );
  }
}
