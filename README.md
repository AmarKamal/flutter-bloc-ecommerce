# Simple E-commerce App

A basic mobile e-commerce application built with Flutter, featuring product listing, cart management, address saving, order placement, and order history.

## Description

This project is a simple demonstration of building a mobile e-commerce application using Flutter. It simulates fetching product data from a dummy API, allows users to add items to a cart, manage their cart, save a shipping address, place orders, and view their past order history.

The app utilizes the Bloc state management pattern for organizing application logic and state changes, Dio for handling network requests, and Shared Preferences for local data persistence (like user address and order history). It also incorporates a basic search and filter functionality for the product list and pull-to-refresh.

## Features

- User Authentication (Simulated Login using DummyJSON)
- Browse Products (Fetched from DummyJSON API)
- Infinite Scrolling Product Grid (Load more products as you scroll)
- Search Products (Filters loaded products by title/description via API)
- Filter Products by Category (Filters loaded products by category via API)
- Pull-to-Refresh Product List
- View Product Details
- Add Products to Cart
- View and Manage Cart Items (Update quantity, remove items)
- Add and Save Shipping Address (using Shared Preferences)
- Proceed to Order Summary
- Complete Order and Save to Order History (using Shared Preferences)
- View Order History
- View Details of Past Orders
- Shimmer Loading Effect for Product Grid
- Reusable Button Widget
- Custom Font Integration

## Technologies Used

- **Framework**: Flutter
- **State Management**: Bloc
- **Networking**: Dio
- **Data Persistence**: Shared Preferences
- **Loading Effect**: Shimmer
- **Other Packages**: equatable, uuid, intl
- **API**: [DummyJSON](https://dummyjson.com/)

## Project Structure

The project follows a standard Flutter project structure with logical separation of concerns:

```
simple_ecommerce_app/
├── lib/               # Where all your Dart code lives
│   ├── main.dart             # App entry point and Bloc Providers setup
│   |
│   ├── api/                  # API service classes
│   │   └── api_service.dart  # Handles communication with DummyJSON
│   |
│   ├── models/               # Data models (Address, Order, Product, User)
│   │   ├── address.dart
│   │   ├── order.dart
│   │   └── product.dart
│   │   └── user.dart
│   |
│   ├── bloc/                 # Bloc implementation for state management
│   │   ├── auth/             # Authentication Bloc
│   │   ├── cart/             # Cart Management Bloc
│   │   ├── order/            # Order History Bloc
│   │   └── product/          # Product Listing Bloc (includes search/filter state)
│   |
│   ├── pages/                # Main screens/pages of the app
│   │   ├── address/          # Address Edit Page
│   │   ├── auth/             # Login Page
│   │   ├── cart/             # Cart Page
│   │   ├── home/             # Home Page (contains Product List, Orders, Profile tabs)
│   │   ├── order_detail/     # Order Detail Page
│   │   ├── order_history/    # Order History Page
│   │   ├── order_summary/    # Order Summary Page
│   │   └── profile/          # Profile Page
│   |
│   ├── utils/                # Utility files (constants, helper functions, theme)
│   │   ├── app_colors.dart   # Custom color definitions
│   │   ├── app_theme.dart    # Custom theme data configuration
│   │   ├── constants.dart    # App constants (API URLs, limits)
│   │   └── simple_bloc_observer.dart # Custom Bloc Observer for logging
│   |
│   └── widgets/              # Reusable UI widgets
│       ├── app_button.dart       # Reusable button widget
│       ├── product_grid_item.dart  # Widget for displaying a product in the grid
│       ├── product_item.dart     # Widget for displaying a product in a list (less used now)
│       └── shimmer_grid_loading.dart # Shimmer effect for the product grid
│
├── assets/                   # App assets (fonts, images, vectors)
│   ├── fonts/                # Your font files (.ttf)
│   │   └── ...
│   ├── images/               # Placeholder images, etc.
│   │   └── ...
│   └── vectors/              # If you have vector assets
│
└── pubspec.yaml              # Project dependencies and asset/font declarations
```

## Setup and Installation

To get a copy of the project up and running on your local machine, follow these steps:

### Clone the Repository:

```
git clone <repository_url>
cd simple_ecommerce_app
```

(Replace `<repository_url>` with the actual URL of your GitHub repository)

### Ensure Flutter is Installed:

If you don't have Flutter installed, follow the official guide:
https://flutter.dev/docs/get-started/install

### Open in your IDE:

Open the project folder in your preferred Flutter development environment (like VS Code or Android Studio).

### Get Dependencies:

Fetch the necessary packages by running this command in the project root directory:

```
flutter pub get
```

Your IDE might also do this automatically.

### Add Assets:

Ensure you have created the `assets/fonts/` and `assets/images/` folders in your project root and placed your font files (.ttf) and placeholder images (e.g., placeholder_product.png, placeholder_image.png) inside them, as declared in pubspec.yaml.

## Running the App

### Connect a Device or Start an Emulator:

Have an Android emulator, iOS simulator, or a physical device connected to your computer. You can check available devices with:

```
flutter devices
```

### Run the Application:

Execute the following command in your project's root directory:

```
flutter run
```

Alternatively, use the "Run" option in your IDE.

## Troubleshooting

- **`flutter pub get` fails**: Check pubspec.yaml for syntax errors or incorrect indentation. Ensure you have a stable internet connection.

- **"Undefined name" or "Method not found" errors**: Verify your import statements are correct and that the class/method you're using exists and is spelled correctly.

- **"Null check operator used on null value" errors**: This indicates you're trying to use a variable that is null without handling the null case. Review the relevant code line and add null checks (??, !, if (variable != null)).

- **API Errors (e.g., "Failed to fetch products")**: Check your internet connection and the baseUrl in lib/utils/constants.dart. Add print statements in ApiService methods to inspect the API response status and data.

- **UI Not Updating**: Ensure your Bloc is receiving events and emitting new state objects. Use the SimpleBlocObserver (enabled in main.dart) to see Bloc transitions in the console. Verify your UI widgets are using BlocBuilder or BlocListener correctly.

- **Login works in Debug but not Release APK**: Double-check the API baseUrl in lib/utils/constants.dart for release builds and ensure the login credentials you are using are correct for the deployed API endpoint.
