import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_fish_app/Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 130.h,
                child: Image.asset(
                  "assets/splashlogo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 130.h, 
          child: BottomAppBar(
            height: 100.h,
            color: Colors.blue, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "From:",
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.white,
                    fontFamily: "AlternateGotNo3D",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                Text(
                  "@Group 2",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color.fromARGB(255, 44, 44, 44),
                    fontFamily: "AlternateGotNo3D",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
