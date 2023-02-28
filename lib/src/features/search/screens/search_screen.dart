import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../../common/screen/offline_screen.dart';
import '../../home/widgets/search_notifications.dart';
import '../provider/search_provider.dart';
import '../widgets/search_list_view.dart';

class SearchRequestModel {
  SearchRequestModel({required this.searchStatus, this.playlistId});

  final int? playlistId;
  final SearchStatus searchStatus;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.searchRequestModel})
      : super(key: key);

  final SearchRequestModel searchRequestModel;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = TextEditingController();

    if (widget.searchRequestModel.searchStatus ==
        SearchStatus.artistPreference) {
      context.read<SearchProvider>().searchArtistPreference();
    }

    super.initState();
  }

  void debouncing({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  void _onSearchChange() {
    debouncing(
      fn: () {
        if (mounted) {
          context.read<SearchProvider>().getSearch(
              _controller.text,
              widget.searchRequestModel.searchStatus,
              widget.searchRequestModel.playlistId,
              context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
              backgroundColor: const Color(0xFF16151C),
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  SearchFieldWidget(
                    onChanged: (value) {
                      _onSearchChange();
                    },
                    controller: _controller,
                    searchRequestModel: widget.searchRequestModel,
                  ),
                  SearchListView(
                    searchRequestModel: widget.searchRequestModel,
                    controller: _controller,
                  ),
                ],
              ),
            ),
    );
  }
}

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    Key? key,
    required TextEditingController controller,
    required this.searchRequestModel,
    this.onChanged,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final SearchRequestModel searchRequestModel;
  final ValueSetter<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.arrow_back_ios_rounded)),
          ),
          Expanded(
            child: SearchTextWidget(
              onChange: onChanged,
              textEditingController: _controller,
              onTap: () {
                // context.read<SearchProvider>().searchFieldTap();
              },
              hint: (searchRequestModel.searchStatus == SearchStatus.artist ||
                      searchRequestModel.searchStatus ==
                          SearchStatus.artistPreference)
                  ? "Search Artist"
                  : "Search Music and Podcasts",
              searchStatus: searchRequestModel.searchStatus,
            ),
          ),
        ],
      ),
    );
  }
}
