// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:musiq/src/logic/controller/library_controller.dart';

// import '../../../../constants/color.dart';
// import '../../../../constants/string.dart';
// import '../../../../widgets/custom_dialog_box.dart';


// class PlaylistButton extends StatelessWidget {
//   const PlaylistButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     LibraryController libraryController = Get.put(LibraryController());

//     return FloatingActionButton(
//       mini: false,
//       onPressed: () {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return CustomDialogBox(
//                 title: ConstantText.createPlaylist,
//                 fieldName: ConstantText.name,
//                 buttonText: ConstantText.create,
//                 // callback: libraryController.createPlaylist(context),
//               );
//               ;
//             });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: CustomColor.secondaryColor,
//           borderRadius: BorderRadius.all(
//             Radius.circular(100),
//           ),
//           border: Border.all(color: Colors.transparent, width: 0.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.white.withOpacity(0.3),
//             ),
//           ],
//         ),
//         child: Icon(
//           Icons.add_rounded,
//         ),
//       ),
//     );
//   }
// }
