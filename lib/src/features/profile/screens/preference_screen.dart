import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/app_bar.dart';
import '../../../constants/color.dart';
import '../../../routing/route_name.dart';
import '../../common/screen/offline_screen.dart';

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size(double.maxFinite, 60),
              child: CustomAppBarWidget(
                title: "Preferences",
              ),
            ),
            body: ListView(children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: PreferenceMainHeaderWidget(
                  mainTitle: "Music Preference",
                  subTitle1: "Artist Preference",
                  navigationScreen1: RouteName.profileArtistPreference,
                  subTitle2: "Audio Quality",
                  navigationScreen2: "audioQuality",
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
              //   child: PreferenceMainHeaderWidget(
              //     mainTitle: "Podcast Preference",
              //     subTitle1: "Artist Preference",
              //     navigationScreen1: "artistPreference",
              //     subTitle2: "Audio Quality",
              //     navigationScreen2: "audioQuality",
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
              //   child: NotificationPreferenceHeaderWidget(
              //     mainTitle: "Notification Preference",
              //     subTitle1: "New Releases",
              //     subTitle2: "Artist Updates",
              //   ),
              // ),
            ]),
          );
  }
}

class PreferenceMainHeaderWidget extends StatelessWidget {
  const PreferenceMainHeaderWidget({
    Key? key,
    required this.mainTitle,
    required this.subTitle1,
    required this.subTitle2,
    required this.navigationScreen1,
    required this.navigationScreen2,
  }) : super(key: key);

  final String mainTitle;
  final String navigationScreen1;
  final String navigationScreen2;
  final String subTitle1;
  final String subTitle2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          mainTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 21.0),
          child: PreferenceListTile(
            label: subTitle1,
            navigationRoute: navigationScreen1,
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 24.0),
        //   child: PreferenceListTile(
        //     label: subTitle2,
        //     navigationRoute: navigationScreen2,
        //   ),
        // ),
      ],
    );
  }
}

class NotificationPreferenceHeaderWidget extends StatelessWidget {
  const NotificationPreferenceHeaderWidget({
    Key? key,
    required this.mainTitle,
    required this.subTitle1,
    required this.subTitle2,
  }) : super(key: key);

  final String mainTitle;
  final String subTitle1;
  final String subTitle2;

  @override
  Widget build(BuildContext context) {
    bool isNewReleaseSwitched = false;
    bool isArtistUpdateSwitched = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          mainTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        NotificationPreferenceListTile(
            title: subTitle1, isSwitched: isNewReleaseSwitched),
        NotificationPreferenceListTile(
            title: subTitle2, isSwitched: isArtistUpdateSwitched),
      ],
    );
  }
}

class NotificationPreferenceListTile extends StatefulWidget {
  NotificationPreferenceListTile({
    Key? key,
    required this.title,
    this.isSwitched = false,
  }) : super(key: key);

  bool isSwitched;
  final String title;

  @override
  State<NotificationPreferenceListTile> createState() =>
      _NotificationPreferenceListTileState();
}

class _NotificationPreferenceListTileState
    extends State<NotificationPreferenceListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: widget.isSwitched,
            onChanged: (value) {
              setState(() {
                widget.isSwitched = value;
              });
            },
            activeTrackColor: Colors.white,
            activeColor: CustomColor.subTitle,
            inactiveTrackColor: CustomColor.subTitle,
            inactiveThumbColor: CustomColor.secondaryColor,
          ),
        ],
      ),
    );
  }
}

class PreferenceListTile extends StatelessWidget {
  const PreferenceListTile({
    Key? key,
    required this.label,
    required this.navigationRoute,
  }) : super(key: key);

  final String label;
  final String navigationRoute;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(navigationRoute);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
          ),
        ],
      ),
    );
    // return ListTile(
    //   contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
    //   title: Text(label),
    // trailing: Icon(
    //   Icons.arrow_forward_ios_rounded,
    //   size: 20,
    // ),
    // );
  }
}
