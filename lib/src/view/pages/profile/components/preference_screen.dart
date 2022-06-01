import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../widgets/custom_app_bar.dart';

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.maxFinite, 60),
        child: CustomAppBarWidget(
          title: "Preferences",
        ),
      ),
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Text(
                "Music Preference",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              title: Text("Artist Preference"),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
