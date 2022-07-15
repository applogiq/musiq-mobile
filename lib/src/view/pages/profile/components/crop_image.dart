// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// // import 'package:image_crop/image_crop.dart';
// import 'package:musiq/src/logic/controller/profile_controller.dart';
// import 'package:musiq/src/view/widgets/custom_button.dart';

// class ImageCropperScreen extends StatefulWidget {
//   ImageCropperScreen({Key? key, this.imagePath}) : super(key: key);
//   var imagePath;

//   @override
//   State<ImageCropperScreen> createState() => _ImageCropperScreenState();
// }

// class _ImageCropperScreenState extends State<ImageCropperScreen> {
//   final _controller = CropController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 150,
//           ),
//           Expanded(
//             child: Crop(
//                 cornerDotBuilder: (size, edgeAlignment) =>
//                     const DotControl(color: Colors.transparent),
//                 interactive: true,
//                 fixArea: true,
//                 // aspectRatio: 4.5,
//                 initialAreaBuilder: (rect) => Rect.fromLTRB(rect.left + 74,
//                     rect.top + 42, rect.right - 34, rect.bottom - 42),
//                 image: widget.imagePath,
//                 controller: _controller,
//                 onCropped: (d) {
//                   print("object");
//                   print(d.toString());
//                   setState(() {
//                     widget.imagePath = d;
//                   });
//                 }),
//           ),
//           SizedBox(
//             height: 150,
//           ),
//           InkWell(
//               onTap: () {
//                 print("object1");
//                 _controller.crop;
//                 print("object2");
//                 print(_controller.toString());

//                 // ProfileController profileController = ProfileController();
//                 // profileController.cropImage(cropKey);
//               },
//               child: CustomButton(label: "Save"))
//         ],
//       ),
//     );
//   }
// }
