// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:musiq/src/common_widgets/box/vertical_box.dart';
// import 'package:musiq/src/features/profile/provider/profile_provider.dart';
// import 'package:musiq/src/utils/size_config.dart';
// import 'package:provider/provider.dart';

// import '../../../common_widgets/buttons/custom_button.dart';
// import '../../../common_widgets/text_field/custom_text_field.dart';
// import '../../../constants/string.dart';

// class MyProfile extends StatefulWidget {
//   const MyProfile({super.key});

//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }

// class _MyProfileState extends State<MyProfile> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Provider.of<ProfileProvider>(context, listen: false).getuserApi();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     var pro = Provider.of<ProfileProvider>(context);
//     return Scaffold(
// appBar: AppBar(
//   automaticallyImplyLeading: false,
//   toolbarHeight: getProportionateScreenHeight(70),
//   title: const Text("My Profile"),
//   titleSpacing: 0.1,
//   leading: InkWell(
//       onTap: () {
//         Navigator.pop(context);
//         pro.clearError();
//       },
//       child: const Icon(Icons.arrow_back_ios)),
// ),
//       body: Consumer<ProfileProvider>(builder: (context, pro, child) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: getProportionateScreenHeight(24),
//               ),
//               Center(
//                 child: Stack(
//                   children: [
//                     pro.pickedImage == null
//                         ? pro.profileAPI!.records!.isImage == true
//                             ? CircleAvatar(
//                                 radius: 65,
//                                 backgroundImage: NetworkImage(pro.updatedImage),
//                               )
//                             : CircleAvatar(
//                                 radius: getProportionateScreenHeight(65),
//                                 backgroundImage: const AssetImage(
//                                     "assets/images/defaultimage.png"))
//                         : CircleAvatar(
//                             radius: getProportionateScreenHeight(65),
//                             backgroundImage: MemoryImage(
//                                 pro.pickedImage!.readAsBytesSync())),
//                     Positioned(
//                       top: getProportionateScreenHeight(80),
//                       left: getProportionateScreenWidth(77),
//                       child: GestureDetector(
//                         onTap: () {
//                           showModalBottomSheet(
//                               backgroundColor: Colors.transparent,
//                               context: context,
//                               isDismissible: true,
//                               builder: (BuildContext context) {
//                                 return Container(
//                                   height: 250,
//                                   decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(25),
//                                         topRight: Radius.circular(25)),
//                                     color: Color.fromRGBO(33, 33, 44, 1),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 16, right: 16),
//                                         child: Row(children: [
//                                           Text(
//                                             "Profile photo",
//                                             style: GoogleFonts.poppins(
//                                                 textStyle: const TextStyle(
//                                                     color: Color.fromRGBO(
//                                                       255,
//                                                       255,
//                                                       255,
//                                                       1,
//                                                     ),
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 15)),
//                                           ),
//                                           const Spacer(),
//                                           IconButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             icon: const Icon(
//                                               Icons.close_rounded,
//                                               color: Color.fromRGBO(
//                                                   255, 255, 255, 1),
//                                             ),
//                                           ),
//                                         ]),
//                                       ),
//                                       const Divider(
//                                         thickness: 1,
//                                         height: 0,
//                                         color:
//                                             Color.fromRGBO(255, 255, 255, 0.1),
//                                       ),
//                                       ListTile(
//                                           leading: const Icon(
//                                             Icons.photo_camera,
//                                             color: Color.fromRGBO(
//                                                 255, 255, 255, 0.7),
//                                             size: 24,
//                                           ),
//                                           title: InkWell(
//                                             onTap: () {
//                                               pro.pickImage(
//                                                   ImageSource.camera, context);
//                                             },
//                                             child: Text(
//                                               "Open camera",
//                                               style: GoogleFonts.poppins(
//                                                   textStyle: const TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Color.fromRGBO(
//                                                           255, 255, 255, 1))),
//                                             ),
//                                           )),
//                                       InkWell(
//                                         onTap: () {
//                                           pro.pickImage(
//                                               ImageSource.gallery, context);
//                                         },
//                                         child: ListTile(
//                                             leading: const Icon(
//                                               Icons.image,
//                                               color: Color.fromRGBO(
//                                                   255, 255, 255, 0.7),
//                                               size: 25,
//                                             ),
//                                             title: Text(
//                                               "Choose from gallery",
//                                               style: GoogleFonts.poppins(
//                                                   textStyle: const TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Color.fromRGBO(
//                                                           255, 255, 255, 1))),
//                                             )),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           pro.profileDeleteImage(context);
//                                         },
//                                         child: ListTile(
//                                             leading: const Icon(
//                                               Icons.delete,
//                                               color: Color.fromRGBO(
//                                                   255, 255, 255, 0.7),
//                                               size: 25,
//                                             ),
//                                             title: Text(
//                                               "Delete picture",
//                                               style: GoogleFonts.poppins(
//                                                   textStyle: const TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: Color.fromRGBO(
//                                                     255, 255, 255, 1),
//                                               )),
//                                             )),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               });
//                         },
//                         child: Stack(children: [
//                           Container(
//                             height: 45,
//                             width: 45,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(100),
//                               color: Colors.white,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.5, top: 2.5),
//                             child: Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(100),
//                                   color: Colors.black),
//                               child:
//                                   const Icon(Icons.edit, color: Colors.white),
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const VerticalBox(height: 33),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(8)),
//                 child:
//                     Consumer<ProfileProvider>(builder: (context, provider, _) {
//                   return TextFieldWithError(
//                       initialValue: provider.profileName,
//                       onTap: () {},
//                       label: "Name",
//                       errorMessage: pro.nameError,
//                       isValidatorEnable: true,
//                       onChange: (value) {
//                         pro.nameChanged(value);
//                       });
//                 }),
//               ),
//               const VerticalBox(height: 16),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(8)),
//                 child: TextFieldWithError(
//                     initialValue: pro.profileUserName,
//                     onTap: () {},
//                     label: "Username",
//                     errorMessage: pro.userNameError,
//                     isValidatorEnable: true,
//                     onChange: (value) {
//                       pro.userNameChanged(value);
//                     }),
//               ),
//               // Spacer(),
//               const VerticalBox(height: 100),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(
//               //       horizontal: getProportionateScreenWidth(8)),
//               //   child: InkWell(
//               //     onTap: () {
//               //       pro.updateProfile();
//               //     },
//               //     child: Container(
//               //       height: getProportionateScreenHeight(52),
//               //       width: double.maxFinite,
//               //       decoration: BoxDecoration(
//               //           borderRadius: BorderRadius.circular(12),
//               //           color: const Color.fromRGBO(254, 86, 49, 1)),
//               //       child: Center(
//               //         child: Text(
//               //           "Save",
//               //           style: fontWeight500(
//               //               size: 16.0,
//               //               color: const Color.fromRGBO(255, 255, 255, 0.75)),
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               Consumer<ProfileProvider>(builder: (context, provider, _) {
//                 return InkWell(
//                   onTap: () {
//                     provider.updateProfile(context);
//                   },
//                   child: CustomButton(
//                     isValid: true,
//                     isLoading: provider.isLoading,
//                     label: ConstantText.save,
//                     horizontalMargin: 0,
//                   ),
//                 );
//               }),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/features/profile/provider/profile_provider.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../common_widgets/text_field/custom_text_field.dart';
import '../../../constants/images.dart';
import '../../../utils/size_config.dart';
import '../widgets/image_picker_sheet.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ProfileProvider>(context, listen: false).getProfileDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: getProportionateScreenHeight(70),
          title: Text(ConstantText.myProfile),
          titleSpacing: 0.1,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                // pro.clearError();
              },
              child: const Icon(Icons.arrow_back_ios)),
        ),
        body: Consumer<ProfileProvider>(builder: (context, pro, _) {
          return pro.myProfileLoading
              ? const LoaderScreen()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: size.height - 100,
                      width: size.width,
                      child: Column(
                        children: [
                          ProfileImageEdit(size: size),
                          Consumer<ProfileProvider>(
                              builder: (context, provider, _) {
                            return TextFieldWithError(
                                initialValue:
                                    provider.profileAPIModel.records != null
                                        ? provider
                                            .profileAPIModel.records!.fullname!
                                        : "",
                                onTap: () {},
                                label: ConstantText.name,
                                errorMessage: provider.nameErrorMessage,
                                isValidatorEnable: true,
                                onChange: (text) {
                                  provider.profileNameChanged(text);
                                });
                          }),
                          Consumer<ProfileProvider>(
                              builder: (context, provider, _) {
                            return TextFieldWithError(
                                initialValue:
                                    provider.profileAPIModel.records != null
                                        ? provider
                                            .profileAPIModel.records!.username!
                                        : "",
                                onTap: () {},
                                label: ConstantText.userName,
                                errorMessage: provider.userNameErrorMessage,
                                isValidatorEnable: true,
                                onChange: (text) {
                                  provider.profileUserNameChanged(text);
                                });
                          }),
                          const Spacer(),
                          Consumer<ProfileProvider>(
                              builder: (context, provider, _) {
                            return GestureDetector(
                              onTap: provider.isProfileSave
                                  ? () {
                                      provider.profileUpdate();
                                    }
                                  : () {},
                              child: CustomButton(
                                isValid: provider.isProfileSave,
                                isLoading: provider.isProfileSaveLoading,
                                label: ConstantText.save,
                                horizontalMargin: 0,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
        }));
  }
}

class ProfileImageEdit extends StatelessWidget {
  const ProfileImageEdit({
    Key? key,
    required this.size,
    // required this.profileController,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, pro, _) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.034),
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: pro.fileImage != null
                ? DecorationImage(
                    image: MemoryImage(
                      pro.memoryImage!,
                    ),
                    fit: BoxFit.cover)
                : pro.profileAPIModel.records != null
                    ? (pro.profileAPIModel.records!.isImage != null &&
                            pro.profileAPIModel.records!.isImage != false)
                        ? DecorationImage(
                            image: NetworkImage(generateProfileImageUrl(pro
                                .profileAPIModel.records!.registerId
                                .toString())),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: AssetImage(
                              Images.user_default,
                            ),
                            fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage(
                          Images.user_default,
                        ),
                        fit: BoxFit.cover)
            // // profileController.isImagePicked == false
            // //     ? profileController.isImage.value == true
            // //         ?
            //       1==0?1==0?  DecorationImage(
            //             image: NetworkImage(
            //               generateProfileImageUrl(
            //                   profileController.registerId.value),
            //             ),
            //             fit: BoxFit.cover)
            //         : DecorationImage(
            //             image: AssetImage(
            //               Images.user_default,
            //             ),
            //             fit: BoxFit.cover)
            // : DecorationImage(
            //     image: FileImage(
            //       profileController.imagePath,
            //     ),
            //     fit: BoxFit.cover),
            ),
        child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const ImagePickerSheet(),
                  backgroundColor: Colors.transparent,
                );
                //  profileController.changeImage();
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: const Icon(Icons.edit),
              ),
            )),
      );
    });
  }
}
