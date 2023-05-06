import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:group_chat_app_pic/hepler/hepler_function.dart';
import 'package:group_chat_app_pic/pages/auth/loginpage.dart';
import 'package:group_chat_app_pic/pages/homepage.dart';
import 'package:group_chat_app_pic/shared/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appid,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp( DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(), // Wrap your app
  ),);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserLoggedInStatus();
    super.initState();
  }

  void getUserLoggedInStatus()
  async 
  {
    await HelperFunctions.getUserLoggedInStatus().then((value) {

     
         if(value != null)
      {

        setState(() {
          _isSignedIn = value;
          
        });
          
      }
        
     
     
    });

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: ThemeData(

        primaryColor: Constants().pColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true

      

      ).copyWith(),

      //debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LogInPage(),
    );
  }
}
