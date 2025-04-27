import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text; // The text to display on the button
  final VoidCallback? onPressed; // The function to call when the button is pressed
  final bool isLoading; // Optional: show a loading indicator
  final Color? backgroundColor; // Optional: button background color
  final Color? textColor; // Optional: button text color
  final double borderRadius; // Optional: button border radius

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed, // Make onPressed required for a functional button
    this.isLoading = false, // Default to not loading
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.8, // Button width is 80% of the screen width
      height: screenHeight * 0.07, // Button height is 7% of the screen height
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable button if loading
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor, // Use provided or theme color
          foregroundColor: textColor ?? Colors.white, // Use provided or default white text color
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Add padding for better appearance
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white, // Spinner color
                    ),
                  ),
                  const SizedBox(width: 12), // Spacing between spinner and text
                  Text(
                    'Loading...',
                    style: TextStyle(color: textColor ?? Colors.white),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.0, // Adjust font size
                  fontWeight: FontWeight.w600, // Make text bold
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
