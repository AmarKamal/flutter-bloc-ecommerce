// lib/pages/profile/profile_page.dart
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../models/user.dart';
import '../../models/address.dart'; // Import Address model to potentially load it here
import '../../widgets/app_button.dart'; // Import the AppButton widget
import '../../utils/app_colors.dart'; // Import custom colors for potential use
import '../address/address_edit_page.dart'; // Import the AddressEditPage


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Function to navigate to the Address Edit Page
  // This function is defined here in the StatelessWidget
  void _navigateToEditAddress(BuildContext context, Address? currentAddress) async {
    // Navigate to AddressEditPage and wait for the result (true if address was saved or deleted)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressEditPage(initialAddress: currentAddress), // Pass the current address
      ),
    );

    // Although ProfilePage is StatelessWidget and doesn't hold address state,
    // if it were Stateful and displayed the address, you would reload it here:
    // if (result == true) {
    //   // Reload address here if ProfilePage displayed it
    // }

    // Optionally show a confirmation snackbar after returning from edit page
    if (result == true) {
      floatingSnackBar(message: 'Address updated.', context: context)
       ;
    }
  }


  @override
  Widget build(BuildContext context) {
    // Access the AuthBloc to get the current user
    final authState = context.watch<AuthBloc>().state;
    User? currentUser;

    if (authState is Authenticated) {
      currentUser = authState.user;
    }

    // Get theme colors and text styles
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // We need to load the current address here to pass it to the edit page
    // Since ProfilePage is StatelessWidget, we'll load it asynchronously
    // inside the builder for the address section or pass null initially.
    // A better approach for displaying the address would be StatefulWidget,
    // but for just navigating, this works.

    return Scaffold(
      body: currentUser == null
          ? Center(child: Text('User not logged in', style: textTheme.bodyMedium)) // Should not happen if navigated from Authenticated state
          : SingleChildScrollView( // Wrap in SingleChildScrollView to prevent overflow
              padding: const EdgeInsets.all(24.0), // Increased padding
              child: Center( // Center the content
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: <Widget>[                                         

                    // User Image (Handle potential null image URL)
                    Lottie.asset(
                      'assets/loftie/profile.json', // Path to Lottie file
                      width: 100, // Adjust size as needed
                      height: 100,
                      fit: BoxFit.cover, // Cover the available space
                      repeat: false, // Do not repeat the animation
                    ),
                    const SizedBox(height: 24.0), // Increased spacing

                    // User Details
                    Text(
                      currentUser.fullName, // fullName getter handles nulls
                      style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground, fontWeight: FontWeight.bold), // Use titleMedium from theme
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      currentUser.email ?? 'N/A', // Use ?? to provide a default if email is null
                      style: textTheme.bodyMedium?.copyWith(color: kcTextSecondary), // Use bodyMedium, secondary text color
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Username: ${currentUser.username ?? 'N/A'}', // Use ?? in interpolation
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground), // Use bodyMedium
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Gender: ${currentUser.gender ?? 'N/A'}', // Use ?? in interpolation
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground), // Use bodyMedium
                    ),
                    // Add more user details as needed

                    const SizedBox(height: 32.0), // Increased spacing

                    const Divider(), // Separator

                    const SizedBox(height: 16.0), // Spacing after separator

                    // Section for Shipping Address Management
                    Align( // Align the column to the left
                       alignment: Alignment.centerLeft,
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipping Address:',
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          // FutureBuilder to load the address asynchronously
                          FutureBuilder<Address?>(
                            future: SharedPreferences.getInstance().then((prefs) {
                              final addressJsonString = prefs.getString('userAddress');
                              if (addressJsonString != null && addressJsonString.isNotEmpty) {
                                try {
                                  return Address.fromRawJson(addressJsonString);
                                } catch (e) {
                                  print('Error decoding saved address in ProfilePage: $e');
                                  return null;
                                }
                              }
                              return null;
                            }),
                            builder: (context, snapshot) {
                              final Address? currentAddress = snapshot.data;
                              return InkWell( // Make the address section tappable
                                // *** CHANGED: Only allow tapping if currentAddress is null ***
                                onTap: currentAddress == null
                                    ? () => _navigateToEditAddress(context, currentAddress) // Navigate to add if null
                                    : null, // Disable tap if address exists
                                child: Container(
                                   width: double.infinity, // Take full width
                                   padding: const EdgeInsets.all(12.0),
                                   decoration: BoxDecoration(
                                     border: Border.all(color: colorScheme.surface), // Border color from theme
                                     borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                   ),
                                  child: snapshot.connectionState == ConnectionState.waiting
                                      ? Center(child: CircularProgressIndicator(color: colorScheme.primary)) // Show loading indicator
                                      : currentAddress == null
                                          ? Text(
                                              'Tap to add shipping address',
                                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary), // Primary color for link
                                            )
                                          : Text(currentAddress.formattedAddress, style: textTheme.bodyMedium), // Display formatted address
                                ),
                              );
                            },
                          ),
                        ],
                       ),
                    ),

                    const SizedBox(height: 32.0), // Spacing before logout button

                    // Logout Button using AppButton
                    AppButton(
                      text: 'LOGOUT', // Button text
                      onPressed: () {
                        // Dispatch LogoutRequested event when button is pressed
                        BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
                      },
                       // No isLoading state needed for logout in this simple flow
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
