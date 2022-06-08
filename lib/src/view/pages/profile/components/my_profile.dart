import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../helpers/constants/color.dart';
import '../../../../helpers/constants/style.dart';
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

class ProfileFormTextFieldWidget extends StatefulWidget {
  const ProfileFormTextFieldWidget({Key? key, required this.title, this.onChange, this.obsecureText = false})
      : super(key: key);
  final String title;
  final ValueSetter<String>? onChange;
  final bool obsecureText;

  @override
  State<ProfileFormTextFieldWidget> createState() => _ProfileFormTextFieldWidgetState();
}

class _ProfileFormTextFieldWidgetState extends State<ProfileFormTextFieldWidget> {
 bool obsecure = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obsecure = widget.obsecureText;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    obsecure = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.title,
              style: fontWeight500(size: 14.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomColorContainer(
              horizontalPadding: 16,
              verticalPadding: 0,
              bgColor: CustomColor.textfieldBg,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.expand(height: 46, width: double.maxFinite),
                child: TextField(
                  cursorColor: Colors.white,
                  obscureText: obsecure,
                  onChanged: widget.onChange,
                  decoration: InputDecoration(
                     suffixIcon: widget.obsecureText
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        icon: Icon(
                            obsecure ? Icons.visibility_off : Icons.visibility))
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
