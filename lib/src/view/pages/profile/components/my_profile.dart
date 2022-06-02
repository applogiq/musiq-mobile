import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../helpers/constants/color.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_color_container.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: CustomAppBarWidget(
          title: "My Profile",
        ),
      ),
      body: SingleChildScrollView(
        // reverse: true,
        child: Container(
            height: MediaQuery.of(context).size.height - 120,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 34),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOvIuFVvPFU596919Aj3EZMWryh0BAgjXX16N1kBboyn9Algcsl_hdUApl6j8qBcTE2nI&usqp=CAU",
                        ),
                        fit: BoxFit.cover),
                  ),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)),
                        child: Icon(Icons.edit),
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      children: [
                        ProfileFormTextFieldWidget(
                          title: "Name",
                        ),
                        ProfileFormTextFieldWidget(
                          title: "Username",
                        ),
                        ProfileFormTextFieldWidget(
                          title: "Email",
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                CustomButton(
                  label: "Save",
                )
              ],
            )),
      ),
    );
  }
}

class ProfileFormTextFieldWidget extends StatelessWidget {
  const ProfileFormTextFieldWidget({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          CustomColorContainer(
            horizontalPadding: 8,
            verticalPadding: 0,
            bgColor: CustomColor.textfieldBg,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints.expand(height: 46, width: double.maxFinite),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
