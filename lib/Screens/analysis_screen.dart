import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_fish_app/Screens/qualityreport_screen.dart';
import 'package:fresh_fish_app/Widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String fishEyeUrl = '';
  String fishSkinUrl = '';
  String fishGillsUrl = '';

  @override
  void initState() {
    super.initState();
    getUrlsFromSharedPreferences();
  }

  Future<void> getUrlsFromSharedPreferences() async {
    try {
      final SharedPreferences localStorage =
          await SharedPreferences.getInstance();

      // Retrieve the URLs from SharedPreferences
      setState(() {
        fishEyeUrl = localStorage.getString('fish_eye_url') ?? '';
        fishSkinUrl = localStorage.getString('fish_skin_url') ?? '';
        fishGillsUrl = localStorage.getString('fish_gills_url') ?? '';
      });
    } catch (e) {
      // Handle error retrieving URLs from SharedPreferences
    }
  }

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
                  "FISH ANALYSIS",
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
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: physicalHeight < 700
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

  // Method to generate all the content inside the screen
  List<Widget> _buildColumnChildren() {
    return [
      SizedBox(height: 10.h),
      _imageBox(fishEyeUrl, "FISH EYE"),
      SizedBox(height: 10.h),
      _imageBox(fishSkinUrl, "FISH SKIN"),
      SizedBox(height: 10.h),
      _imageBox(fishGillsUrl, "FISH GILLS"),
      SizedBox(height: 15.h),
      CustomButton(
        text: "Analyze",
        icon: Icons.assessment_outlined,
        onPressed: () async {
          await Future.delayed(const Duration(seconds: 2));
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const QualityreportScreen(),
            ),
          );
        },
      ),
      SizedBox(height: 10.h),
    ];
  }

  // Method to create image box for each type of fish image
  Widget _imageBox(String imageUrl, String title) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.blue.shade200,
                thickness: 1.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF080C27).withOpacity(0.9),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.blue.shade200,
                thickness: 1.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Container(
          width: 188.spMax,
          height: 141.spMax,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.network(imageUrl);
              },
            ),
          ),
        ),
      ],
    );
  }
}
