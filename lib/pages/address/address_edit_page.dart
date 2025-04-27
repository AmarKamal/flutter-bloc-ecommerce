// lib/pages/address/address_edit_page.dart
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todak_commerce/widgets/app_button.dart';
import '../../models/address.dart';

class AddressEditPage extends StatefulWidget {
  final Address? initialAddress; // Pass existing address if editing

  const AddressEditPage({super.key, this.initialAddress});

  @override
  AddressEditPageState createState() => AddressEditPageState();
}

class AddressEditPageState extends State<AddressEditPage> {
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _stateController = TextEditingController();

  bool _isEditing = false; // Track if we are editing an existing address

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _isEditing = true;
      _addressLineController.text = widget.initialAddress!.addressLine;
      _cityController.text = widget.initialAddress!.city;
      _postcodeController.text = widget.initialAddress!.postcode;
      _stateController.text = widget.initialAddress!.state;
    }
  }

  @override
  void dispose() {
    _addressLineController.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  // Function to save the address to SharedPreferences
  Future<void> _saveAddress() async {
    final address = Address(
      addressLine: _addressLineController.text,
      city: _cityController.text,
      postcode: _postcodeController.text,
      state: _stateController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    // Convert Address object to JSON string and save
    await prefs.setString('userAddress', address.toRawJson());
    floatingSnackBar(message: 'Address saved successfully!', context: context);    
    Navigator.pop(context, true); // Pop and indicate success
  }

  // Function to delete the address from SharedPreferences
  Future<void> _deleteAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userAddress');

    floatingSnackBar(message: 'Address deleted successfully!', context: context);    
    Navigator.pop(context, true); // Pop and indicate success
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _addressLineController,
              decoration: const InputDecoration(labelText: 'Address Line'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _postcodeController,
              decoration: const InputDecoration(labelText: 'Postcode'),
              keyboardType: TextInputType.number, // Suggest numeric keyboard
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 24.0),            
            AppButton(
              text: _isEditing ? 'Update Address' : 'Add Address',
              onPressed: _saveAddress,
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              borderRadius: 8.0,
            ),
            if (_isEditing) // Show delete button only if editing
              const SizedBox(height: 12.0),
            if (_isEditing)
              OutlinedButton(
              onPressed: _deleteAddress,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red, 
                side: const BorderSide(color: Colors.red), 
                padding: const EdgeInsets.symmetric(vertical: 23.0),
              ),
              child: const Text(
                'Delete Address',
                style: TextStyle(fontSize: 16.0), // Increase font size for better visibility
              ),
              ),
          ],
        ),
      ),
    );
  }
}
