import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // for Base64 encoding
import 'package:http/http.dart' as http;

class FishImageUploader extends StatefulWidget {
  final int pageCount;
  const FishImageUploader({super.key, this.pageCount = 1});

  @override
  State<FishImageUploader> createState() => _FishImageUploaderState();
}

class _FishImageUploaderState extends State<FishImageUploader> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _responseMessage; // To hold the API response
  bool _isLoading = false; // To track loading state
  String? _predictedClass; // Store the predicted class (Grade A, B, or C)
  List<dynamic> _predictions = []; // Store all predictions

  // Pick an image from the gallery
  Future<void> pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _responseMessage =
            null; // Clear the previous response when a new image is picked
        _predictedClass = null; // Clear previous predictions
        _predictions.clear(); // Clear previous predictions
      });
    }
  }

  // Analyze the image (send Base64 encoded image to the API)
  Future<void> analyzeImage() async {
    if (_image == null) {
      print("No image selected");
      return;
    }

    setState(() {
      _isLoading = true; // Set loading to true before starting the analysis
    });

    try {
      // Convert the image to Base64 format
      String base64Image = base64Encode(await _image!.readAsBytes());

      print(base64Image);

      // API URL and headers
      String url = "https://pawelbrothers.lk/test.php";
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      // Sending the Base64-encoded image in the request body
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          "base64Image": base64Image,
        }),
      );

      setState(() {
        _isLoading = false; // Set loading to false after receiving the response
      });

      if (response.statusCode == 200) {
        // Handle the successful response here
        var responseBody = json.decode(response.body);
        var predictions = responseBody['predictions'];

        // Check if predictions are available
        if (predictions != null && predictions.isNotEmpty) {
          // Find the prediction with the highest confidence
          var highestConfidencePrediction = predictions
              .reduce((a, b) => a['confidence'] > b['confidence'] ? a : b);

          setState(() {
            _predictedClass = highestConfidencePrediction['class'];
            _predictions = predictions; // Store all predictions for display
            _responseMessage = "Image analyzed successfully!";
          });
        } else {
          setState(() {
            _responseMessage = "No predictions found.";
            _predictions.clear(); // Clear previous predictions
          });
        }
      } else {
        // Handle the error response here
        setState(() {
          _responseMessage =
              "Failed to analyze image. Status Code: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false on error
        _responseMessage = "Error analyzing image: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> appBarTitles = [
      "FISH EYE UPLOADER",
      "FISH SKIN UPLOADER",
      "FISH GILLS UPLOADER"
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade200,
          toolbarHeight: 50.h,
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
                  appBarTitles[widget.pageCount - 1],
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
        backgroundColor: Colors.blue.shade50,
        body: SingleChildScrollView(
          // Wrap the body content in a scrollable view
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center everything vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_image != null)
                  Center(
                    child: Stack(
                      children: [
                        Image.file(
                          _image!,
                          width: MediaQuery.of(context).size.width *
                              0.9, // 90% of screen width
                          height: null, // Maintain aspect ratio
                          fit: BoxFit.contain, // Ensures image isn't cropped
                        ),
                        if (_predictedClass != null)
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              color: Colors.red.withOpacity(
                                  0.7), // Set the background color to red
                              padding: EdgeInsets.all(8.sp),
                              child: Text(
                                _predictedClass!,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // Make text white for contrast
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    onPressed: pickFromGallery,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Pick an Image from Gallery",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_image !=
                    null) // Show Analyze button only after picking an image
                  SizedBox(height: 20.h),
                if (_image != null)
                  ElevatedButton(
                    onPressed: analyzeImage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Analyze Image",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                if (_responseMessage != null)
                  Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.sp,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _responseMessage!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                // Display predictions if available
                if (_predictions.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _predictions.map((prediction) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.sp),
                          child: Text(
                            "Class: ${prediction['class']}, Confidence: ${prediction['confidence'].toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                // If no predictions are found
                if (_predictions.isEmpty && _responseMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 20.sp),
                    child: Text(
                      "No predictions found.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
