import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/helpers/constants/string.dart';

import '../../../../helpers/constants/color.dart';
import '../../../../helpers/constants/style.dart';
import '../../../../logic/controller/profile_controller.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_color_container.dart';
import '../../../widgets/empty_box.dart';
import 'image_picker_sheet.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key}) : super(key: key);
String value="Name";
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    profileController.loadData();

    var size = MediaQuery.of(context).size;

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
            height: MediaQuery.of(context).size.height - 1,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ProfileImageEdit(
                    size: size, profileController: profileController),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                value,
                                style: fontWeight500(size: 14.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomColorContainer(
                                left: 16,
                                right: 24,
                                verticalPadding: 0,
                                bgColor: CustomColor.textfieldBg,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints.expand(
                                      height: 46, width: double.maxFinite),
                                  child: Obx(() => TextFormField(
                                        initialValue: profileController.nameValue.value,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          profileController.checkName(value);
                                          // libraryController.checkPlayListName(value);
                                        },

                                        // inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),],,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(fontSize: 14),
                                        ),
                                      )),
                                ),
                              ),
                            ),

                             Obx((){
                              return profileController.isNameError.value? Padding(
                                 padding: const EdgeInsets.only(left:8.0),
                                 child: Text(profileController.nameError.value,style: const TextStyle(color: Colors.red),),
                               ):EmptyBox();
                             }),
                          ],
                        ),
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                ConstantText.userName,
                                style: fontWeight500(size: 14.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomColorContainer(
                                left: 16,
                                right: 24,
                                verticalPadding: 0,
                                bgColor: CustomColor.textfieldBg,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints.expand(
                                      height: 46, width: double.maxFinite),
                                  child: Obx(() => TextFormField(
                                        initialValue: profileController.userNameValue.value,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          profileController.checkUserName(value);
                                          // libraryController.checkPlayListName(value);
                                        },

                                        // inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),],,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(fontSize: 14),
                                        ),
                                      )),
                                ),
                              ),
                            ),

                             Obx((){
                              return profileController.isUserNameError.value? Padding(
                                 padding: const EdgeInsets.only(left:8.0),
                                 child: Text(profileController.userNameError.value,style: const TextStyle(color: Colors.red),),
                               ):EmptyBox();
                             }),
                          ],
                        ),
                       
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                InkWell(
                  onTap: (){
                        profileController.saveUpdate();
                  },
                  child: CustomButton(
                    label: "Save",
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class ProfileImageEdit extends StatelessWidget {
  const ProfileImageEdit({
    Key? key,
    required this.size,
    required this.profileController,
  }) : super(key: key);

  final Size size;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      initState: (_) {},
      builder: (_) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: size.height * 0.034),
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: profileController.isImagePicked == false
                ? DecorationImage(
                    image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOvIuFVvPFU596919Aj3EZMWryh0BAgjXX16N1kBboyn9Algcsl_hdUApl6j8qBcTE2nI&usqp=CAU",
                    ),
                    fit: BoxFit.cover)
                : DecorationImage(
                    image: FileImage(
                      profileController.imagePath,
                    ),
                    fit: BoxFit.cover),
          ),
          child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => bulidsheet(context),
                    backgroundColor: Colors.transparent,
                  );
                  //  profileController.changeImage();
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: Icon(Icons.edit),
                ),
              )),
        );

        ;
      },
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key, required this.title, this.onChange, this.obsecureText = false})
      : super(key: key);
  final String title;
  final ValueSetter<String>? onChange;
  final bool obsecureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
              left: 16,
              verticalPadding: 0,
              bgColor: CustomColor.textfieldBg,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.expand(height: 46, width: double.maxFinite),
                child: TextFormField(
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
                              obsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ))
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
