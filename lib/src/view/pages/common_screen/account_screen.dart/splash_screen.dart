import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                  flex: 2,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoWidget(
                        size: 80,
                      ),
                      Text(
                        "MUSIQ",
                        style: GoogleFonts.kdamThmor(
                            textStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          "Queue your favourite music",
                          textAlign: TextAlign.center,
                          style: fontWeight500(size: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          "All your latest songs and podacsts\n in one palce",
                          textAlign: TextAlign.center,
                          style: fontWeight500(
                              size: 14.0,
                              color: Color.fromRGBO(255, 255, 255, 0.6)),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("register");
                          },
                          child: CustomButton(label: "Register")),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: fontWeight500(size: 14.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("login");
                            },
                            child: Text(
                              " Log In",
                              style:
                                  fontWeight500(size: 14.0, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      // body: Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     Image.asset(
      //       "assets/icons/bg.jpg",
      //       fit: BoxFit.fill,
      //     ),
      //     Container(
      //       decoration: BoxDecoration(
      //           gradient: LinearGradient(colors: [
      //         Color.fromRGBO(22, 21, 28, 0),
      //         Color.fromRGBO(2, 0, 1, 1)
      //       ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      //     ),
      //     Container(
      //       child: Column(
      //         children: [
      //           Spacer(),
      // Container(
      //   height: 80,
      //   width: 80,
      //   child: Image.asset(
      //     "assets/icons/logo.png",
      //     fit: BoxFit.cover,
      //   ),
      // ),
      // Text(
      //   "MUSIQ",
      //   style: GoogleFonts.modak(textStyle: TextStyle(fontSize: 24)),
      // ),
      // Text("Queue your favourite music"),
      // Text(
      //   "All your latest songs and podacsts\n in one palce",
      //   textAlign: TextAlign.center,
      // ),
      // Spacer(),
      // CustomButton(label: "Register")
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImageWidget(),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [
                0.1,
                0.65
              ],
                  colors: [
                Color.fromRGBO(22, 21, 28, 0),
                Color.fromRGBO(2, 0, 1, 1),
              ])),
        )
        // Column(
        //   children: [
        //     Expanded(
        //       flex: 7,
        //       child: Container(
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [
        //               Color.fromRGBO(22, 21, 28, 0),
        //               Color.fromRGBO(2, 0, 1, 1),
        //             ],
        //             begin: Alignment.topLeft,
        //             end: Alignment.bottomRight,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       flex: 6,
        //       child: Container(
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [
        //               Color.fromRGBO(2, 0, 1, 0.9),
        //               Color.fromRGBO(2, 0, 1, 1),
        //             ],
        //             begin: Alignment.topLeft,
        //             end: Alignment.bottomRight,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
    required this.size,
  }) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: Image.asset(
          "assets/icons/logo.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/icons/bg.jpg",
              ),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
              fit: BoxFit.cover)),
    );
  }
}
