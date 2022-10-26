import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/features/profile/provider/profile_provider.dart';
import 'package:musiq/src/features/profile/widgets/custom_text_field.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/text_field/custom_text_field.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var pro = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: getProportionateScreenHeight(70),
        title: const Text("My Profile"),
        titleSpacing: 0.1,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            pro.clearError();
          },
          child: const Icon(Icons.arrow_back_ios)),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, Provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(24),
              ),
              Center(
                child: Stack(
                  children: [
                Provider.pickedImage ==null? CircleAvatar(
                      radius: getProportionateScreenHeight(65),
                     backgroundImage: AssetImage("assets/images/defaultimage.png")
                     
                    ):  CircleAvatar(
                      radius: getProportionateScreenHeight(65),
                     backgroundImage: FileImage(Provider.pickedImage!)
                    ),
                    Positioned(
                      top: getProportionateScreenHeight(80),
                      left: getProportionateScreenWidth(77),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isDismissible: true,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 250,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                    color: Color.fromRGBO(33, 33, 44, 1),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Row(children: [
                                          Text(
                                            "Profile photo",
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                      255,
                                                      255,
                                                      255,
                                                      1,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              color:
                                                  Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        height: 0,
                                        color: Color.fromRGBO(255, 255, 255, 0.1),
                                      ),
                                      ListTile(
                                          leading: const Icon(
                                            Icons.photo_camera,
                                            color:
                                                Color.fromRGBO(255, 255, 255, 0.7),
                                            size: 24,
                                          ),
                                          title: InkWell(
                                            onTap: () {
                                          Provider.pickImage(ImageSource.camera, context);
                                            },
                                            child: Text(
                                              "Open camera",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1))),
                                            ),
                                          )),
                                      InkWell(
                                        onTap: () {
                                          Provider.pickImage(ImageSource.gallery, context);
      
                                        },
                                        child: ListTile(
                                            leading: const Icon(
                                              Icons.image,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.7),
                                              size: 25,
                                            ),
                                            title: Text(
                                              "Choose from gallery",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1))),
                                            )),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Provider.profileDeleteImage(context);
                                        },
                                        child: ListTile(
                                            leading: const Icon(
                                              Icons.delete,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.7),
                                              size: 25,
                                            ),
                                            title: Text(
                                              "Delete picture",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              )),
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Stack(children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.5, top: 2.5),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.black),
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalBox(height: 33),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(8)),
                child: Consumer<ProfileProvider>(
                  builder: (context,provider,_) {
                    return TextFieldWithError(
                        initialValue: provider.profileName,
                        onTap: () {},
                        label: "Name",
                        errorMessage: Provider.nameError,
                        isValidatorEnable: true,
                        onChange: (value) {
                          pro.nameChanged(value);
                        });
                  }
                ),
              ),
              VerticalBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(8)),
                child: TextFieldWithError(
                    initialValue: Provider.profileUserName,
                    onTap: () {},
                    label: "Username",
                    errorMessage: Provider.userNameError,
                    isValidatorEnable: true,
                    onChange: (value) {
                      pro.userNameChanged(value);
                    }),
              ),
            // Spacer(),
            VerticalBox(height: 100),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(8)),
                child: InkWell(
                  onTap: () {
            pro.updateProfile();
                    
                  },
                  child: Container(
                    height: getProportionateScreenHeight(52),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(254, 86, 49, 1)),
                    child: Center(
                      child: Text(
                        "Save",
                        style: fontWeight500(
                            size: 16.0, color: Color.fromRGBO(255, 255, 255, 0.75)),
                      ),
                    ),
                  ),
                ),
              ),
        
            ],
          ),
        );
        }
      ),
    );
  }
}
