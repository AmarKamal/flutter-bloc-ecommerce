import 'dart:convert'; // Needed for JSON encoding/decoding

class Address {
  final String addressLine;
  final String city;
  final String postcode;
  final String state;

  Address({
    required this.addressLine,
    required this.city,
    required this.postcode,
    required this.state,
  });

  // Convert an Address object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'addressLine': addressLine,
      'city': city,
      'postcode': postcode,
      'state': state,
    };
  }

  // Create an Address object from a JSON map
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine: json['addressLine'] ?? '', // Provide default empty string for safety
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      state: json['state'] ?? '',
    );
  }

  // Helper to convert Address object to a JSON string
  String toRawJson() => json.encode(toJson());

  // Helper to create Address object from a JSON string
  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  // Helper to get a formatted address string
  String get formattedAddress {
    return '$addressLine, $city, $state $postcode';
  }
}
