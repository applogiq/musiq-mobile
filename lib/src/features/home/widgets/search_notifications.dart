import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/home/provider/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';

class SearchAndNotifications extends StatelessWidget {
  const SearchAndNotifications({
    Key? key,
  }) : super(key: key);

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
                isReadOnly: true,
                onTap: () {
                  print("DATA");
                  context.read<SearchProvider>().resetState();
                  context.read<HomeProvider>().goToSearch(context);
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                hint: "Search Music and Podcasts",
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

class SearchTextWidget extends StatefulWidget {
  SearchTextWidget({
    Key? key,
    required this.hint,
    this.isReadOnly = false,
    required this.onTap,
  }) : super(key: key);
  final String hint;
  bool isReadOnly;

  final VoidCallback onTap;

  @override
  State<SearchTextWidget> createState() => _SearchTextWidgetState();
}

class _SearchTextWidgetState extends State<SearchTextWidget> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  void debouncing({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(_onSearchChange);
    super.initState();
  }

  void _onSearchChange() {
    debouncing(
      fn: () {
        context.read<SearchProvider>().artistSearch(_controller.text);
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChange);
    super.dispose();
  }

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
          controller: _controller,
          onTap: widget.onTap,
          readOnly: widget.isReadOnly,
          onChanged: (val) {},
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
              hintText: widget.hint),
        ),
      ),
    );
  }
}
