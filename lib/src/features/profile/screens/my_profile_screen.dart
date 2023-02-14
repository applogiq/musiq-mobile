import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../common_widgets/loader.dart';
import '../../../common_widgets/text_field/custom_text_field.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/string.dart';
import '../../../core/utils/size_config.dart';
import '../../../core/utils/url_generate.dart';
import '../../common/screen/offline_screen.dart';
import '../provider/profile_provider.dart';
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
        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? const OfflineScreen()
            : Consumer<ProfileProvider>(builder: (context, pro, _) {
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
                                          provider.profileAPIModel.records !=
                                                  null
                                              ? provider.profileAPIModel
                                                  .records!.fullname!
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
                                          provider.profileAPIModel.records !=
                                                  null
                                              ? provider.profileAPIModel
                                                  .records!.username!
                                              : "",
                                      onTap: () {},
                                      label: ConstantText.userName,
                                      errorMessage:
                                          provider.userNameErrorMessage,
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
                                            FocusScope.of(context).unfocus();
                                            provider.profileUpdate(context);
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
            image: (pro.fileImage != null && pro.memoryImage != null)
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
                              Images.userDefault,
                            ),
                            fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage(
                          Images.userDefault,
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
            //               Images.userDefault,
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
                  builder: (context) => ImagePickerSheet(mainContext: context),
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
