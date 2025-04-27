// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:todak_commerce/utils/app_colors.dart'; // Import your color definitions

// Define your custom app theme
ThemeData getAppTheme() {
  return ThemeData(
    brightness: Brightness.dark, // Start with a dark theme base   
    primaryColor: kcPrimary,
    colorScheme: const ColorScheme.dark( // Define dark color scheme
      primary: kcPrimary,
      secondary: kcAccent,
      surface: kcCardDark, // Card/surface color      
      error: kcError,
      onPrimary: Colors.black, // Text/icons on primary
      onSecondary: Colors.black, // Text/icons on secondary
      onSurface: kcTextPrimary, // Text/icons on surface      
      onError: Colors.black, // Text/icons on error
    ),
    scaffoldBackgroundColor: kcBackgroundDark,
    cardColor: kcCardDark,
    textTheme: const TextTheme( // Define text styles
      bodyMedium: TextStyle(color: kcTextPrimary),
      titleMedium: TextStyle(color: kcTextPrimary),
      headlineSmall: TextStyle(color: kcTextPrimary),
      // Define more text styles here if needed
    ).apply( // Apply font family to the whole text theme
       fontFamily: 'CircularStd', // Apply your custom font       
       displayColor: kcTextPrimary,
    ),
    appBarTheme: const AppBarTheme(
       backgroundColor: kcCardDark, // Dark AppBar background
       foregroundColor: kcTextPrimary, // Light text/icon color
       titleTextStyle: TextStyle(
         color: kcTextPrimary,
         fontSize: 20,
         fontWeight: FontWeight.bold,
         fontFamily: 'CircularStd', // Ensure custom font for title
       ),
       iconTheme: IconThemeData(color: kcPrimary), // Accent color for icons
    ),
    buttonTheme: const ButtonThemeData( // Old button theme (still included for compatibility)
      buttonColor: kcPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData( // New ElevatedButton theme
      style: ElevatedButton.styleFrom(
        backgroundColor: kcPrimary, // Button background color
        foregroundColor: Colors.black, // Text color on button
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'CircularStd'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
      ),
    ),
     outlinedButtonTheme: OutlinedButtonThemeData( // OutlinedButton theme
      style: OutlinedButton.styleFrom(
        foregroundColor: kcAccent, // Text color
        side: const BorderSide(color: kcAccent, width: 2), // Border color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'CircularStd'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme( // TextField decoration theme
      filled: true,
      fillColor: kcCardDark, // Dark background for input fields
      labelStyle: TextStyle(color: kcTextSecondary, fontFamily: 'CircularStd'),
      hintStyle: TextStyle(color: kcTextSecondary, fontFamily: 'CircularStd'),
      border: OutlineInputBorder( // Border style
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide.none, // No visible border usually in cyberpunk
      ),
       focusedBorder: OutlineInputBorder( // Focused border style
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: kcAccent, width: 2.0), // Accent border when focused
      ),
       enabledBorder: OutlineInputBorder( // Enabled border style
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: kcCardDark, width: 1.0), // Subtle border when enabled
      ),
    ),
    iconTheme: const IconThemeData(color: kcTextPrimary), // Default icon color
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kcCardDark, // Dark background
      selectedItemColor: kcPrimary, // Accent color for selected item
      unselectedItemColor: kcTextSecondary, // Muted color for unselected
      selectedLabelStyle: TextStyle(fontFamily: 'CircularStd'),
      unselectedLabelStyle: TextStyle(fontFamily: 'CircularStd'),
      type: BottomNavigationBarType.fixed, // Prevent shifting
    ),
  );
}
