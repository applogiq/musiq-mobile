import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/image/auth_background.dart';
import '../../../utils/size_config.dart';
import '../../common/screen/offline_screen.dart';
import '../provider/login_provider.dart';
import '../widgets/login/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late var pro = Provider.of<LoginProvider>(context, listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pro.emailAddress = "";
    });
    super.initState();
  }

  @override
  void dispose() async {
    pro.emailAddress = "";

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: const [
                    Background(),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          );
  }
}
