import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final Future<void> Function() onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.onPressed();
                setState(() {
                  _isLoading = false;
                });
              },
        child: Container(
          height: 55.sp,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: _isLoading ? Colors.blue.withOpacity(0.4) : Colors.blue,
          ),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null)
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      if (widget.icon != null)
                        SizedBox(
                          width: 10.w,
                        ),
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.white,
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
