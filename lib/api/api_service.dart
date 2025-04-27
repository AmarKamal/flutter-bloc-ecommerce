// lib/api/api_service.dart
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class ApiService {
  final Dio _dio = Dio();

  // Constructor to set up Dio with base URL
  ApiService() {
    _dio.options.baseUrl = Constants.baseUrl;
    // Optional: Add interceptors for detailed logging
    // _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
  }

  // --- Authentication ---
  // Logs in a user with username and password
  Future<User?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login', // DummyJSON login endpoint
        data: {
          'username': username,
          'password': password,
        },
      );

      print('Login response status code: ${response.statusCode}'); // Debug logging
      print('Login response data: ${response.data}'); // Debug logging


      if (response.statusCode == 200) {
        // Parse the successful response into a User object
        return User.fromJson(response.data);
      } else {
        // Handle other status codes (e.g., 401 for invalid credentials)
        print('Login failed with status: ${response.statusCode}'); // Debug logging
        print('Login error response: ${response.data}'); // Debug logging
        return null; // Return null on failure
      }
    } on DioException catch (e) { // Catch Dio-specific errors (network issues, timeouts, etc.)
       print('Dio error during login: ${e.message}'); // Debug logging
       if (e.response != null) {
         print('Dio login error response data: ${e.response!.data}'); // Debug logging
         print('Dio login error response headers: ${e.response!.headers}'); // Debug logging
       }
       return null; // Return null on error
    } catch (e) {
      // Catch any other unexpected errors
      print('Error during login: $e'); // Debug logging
      return null; // Return null on error
    }
  }

  // --- Products ---
  // Fetches a list of products with optional pagination, search, and category filter
  Future<List<Product>?> getProducts({
    int skip = 0, // Number of items to skip (for pagination)
    int limit = Constants.productsLimit, // Number of items to fetch
    String? searchQuery, // Optional search query
    String? category, // Optional category filter
  }) async {
    String endpoint = '/products'; // Default endpoint for fetching all products

    // Build query parameters map
    Map<String, dynamic> queryParams = {
      'limit': limit,
      'skip': skip,
    };

    // Determine the correct endpoint and query parameters based on search/filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      endpoint = '/products/search';
      queryParams['q'] = searchQuery; // DummyJSON uses 'q' for search query
      // Note: DummyJSON search endpoint does NOT support category filtering directly.
      // If both are provided, search overrides category filter for this API.
      if (category != null && category.isNotEmpty) {
         print('Warning: DummyJSON search endpoint does not support category filter. Ignoring category filter.');
      }
       category = null; // Ignore category if search is active for this API
    } else if (category != null && category.isNotEmpty) {
       endpoint = '/products/category/$category'; // Endpoint for category filter
       // DummyJSON category endpoint supports skip and limit.
    }

     // *** ADDED: More specific logging for the API call ***
     print('ApiService: Attempting to fetch products.');
     print('ApiService: Endpoint: $endpoint');
     print('ApiService: Query Params: $queryParams');


    try {
      final response = await _dio.get(
        endpoint, // The determined API endpoint
        queryParameters: queryParams, // The constructed query parameters
      );

      // *** ADDED: More specific logging for the API response ***
      print('ApiService: Products response received.');
      print('ApiService: Status Code: ${response.statusCode}');
      print('ApiService: Response Data Type: ${response.data.runtimeType}');
      // print('ApiService: Response Data: ${response.data}'); // Uncomment for full response data


      if (response.statusCode == 200) {
        // DummyJSON responses for /products, /products/search, and /products/category
        // all return a Map with a 'products' key containing a List of product data.
        if (response.data is Map<String, dynamic> && response.data.containsKey('products') && response.data['products'] is List) {
           final List<dynamic> productListJson = response.data['products'];
           print('ApiService: Successfully parsed product list (${productListJson.length} items).'); // Debug logging
           // Map the list of JSON maps to a list of Product objects
           return productListJson.map((json) => Product.fromJson(json)).toList();
        } else {
           // Log if the API response structure is not as expected
           print('ApiService: Products API response format unexpected'); // Debug logging
           return null; // Return null if format is wrong
        }
      } else {
        // Log if the API call failed with a non-200 status code
        print('ApiService: Failed to load products with status: ${response.statusCode}'); // Debug logging
         print('ApiService: Products error response: ${response.data}'); // Debug logging
        return null; // Return null on failure
      }
    } on DioException catch (e) { // Catch Dio-specific errors
       print('ApiService: Dio error fetching products: ${e.message}'); // Debug logging
       if (e.response != null) {
         print('ApiService: Dio products error response data: ${e.response!.data}'); // Debug logging
         print('ApiService: Dio products error response headers: ${e.response!.headers}'); // Debug logging
       }
       return null; // Return null on error
    } catch (e) {
      // Catch any other unexpected errors
      print('ApiService: Error fetching products: $e'); // Debug logging
      return null; // Return null on error
    }
  }

  // --- Get Single Product Details (Needed for Product Detail Page) ---
  // Fetches details for a single product by its ID
  Future<Product?> getProductDetails(int productId) async {
    try {
      final response = await _dio.get('/products/$productId'); // DummyJSON single product endpoint

      print('Product details response status code: ${response.statusCode}'); // Debug logging
      print('Product details response data type: ${response.data.runtimeType}'); // Debug logging
      // print('Product details response data: ${response.data}');

      if (response.statusCode == 200) {
        // DummyJSON single product response is a Map
        if (response.data is Map<String, dynamic>) {
           print('ApiService: Successfully parsed product details'); // Debug logging
           // Parse the JSON map into a Product object
           return Product.fromJson(response.data);
        } else {
           // Log if the API response structure is not as expected
           print('ApiService: Product details API response format unexpected'); // Debug logging
           return null; // Return null if format is wrong
        }
      } else {
        // Log if the API call failed with a non-200 status code
        print('ApiService: Failed to load product details with status: ${response.statusCode}'); // Debug logging
         print('ApiService: Product details error response: ${response.data}'); // Debug logging
        return null; // Return null on failure
      }
    } on DioException catch (e) { // Catch Dio-specific errors
       print('ApiService: Dio error fetching product details: ${e.message}'); // Debug logging
       if (e.response != null) {
         print('ApiService: Dio product details error response data: ${e.response!.data}'); // Debug logging
         print('ApiService: Dio product details error response headers: ${e.response!.headers}'); // Debug logging
       }
       return null; // Return null on error
    } catch (e) {
      // Catch any other unexpected errors
      print('ApiService: Error fetching product details: $e'); // Debug logging
      return null; // Return null on error
    }
  }
}
