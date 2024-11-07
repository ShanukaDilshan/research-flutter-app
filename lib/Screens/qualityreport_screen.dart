import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_fish_app/Screens/dashboard_screen.dart';
import 'package:fresh_fish_app/Widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QualityreportScreen extends StatefulWidget {
  const QualityreportScreen({super.key});

  @override
  State<QualityreportScreen> createState() => _QualityreportScreenState();
}

class _QualityreportScreenState extends State<QualityreportScreen> {
  @override
  Widget build(BuildContext context) {

    double physicalHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade200,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF080C27),
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: 50.h,
          titleSpacing: 40.w,
          title: Center(
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  child: Image.asset(
                    "assets/splashlogo2.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "QUALITY REPORT",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFF080C27),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 30.w,right: 30.w),
          child: physicalHeight < 680
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildColumnChildren(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildColumnChildren(),
                ),
        ),
      ),
    );
  }

  // Method to generate the structure of the screen content
  List<Widget> _buildColumnChildren() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      
        children: [
          SizedBox(height: 20.h),
          _gradebox("Grade A", "HIGH", Colors.green),
          SizedBox(height: 20.h),
          _gradebox("Grade B", "MEDIUM", Colors.yellow),
          SizedBox(height: 20.h),
          _gradebox("Grade C", "LOW", Colors.red),
        ],
      ),
      SizedBox(height: 20.h),
      Divider(color: Colors.blue.shade200, thickness: 2.sp),
      SizedBox(height: 20.h),
      Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "QUALITY RESULT",
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF080C27),
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 60.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Center(
                child: Text(
                  "Grade A",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFF080C27),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20.h),
      CustomButton(
        text: "Back to Dashboard",
        icon: Icons.dashboard_outlined,
        onPressed: () async {
          final SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.clear();
          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
      SizedBox(height: 20.h),
    ];
  }

  // Method to create each grade box
  Widget _gradebox(String grade, String gradevalue, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Center(
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color(0xFF080C27),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Container(
            height: 60.h,
            width: 200.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Center(
              child: Text(
                gradevalue,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color(0xFF080C27),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
