import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

// Create a ProductController class
class ProductController {
  // Define a list to store the products
  List<Product> products = [];

  // Define a method to fetch the products asynchronously
  Future fetchProducts() async {
    // Send an HTTP GET request to the API endpoint
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the JSON response and extract the 'products' data
      final List<dynamic> data = jsonDecode(response.body)['products'];

      // Convert the JSON data to a list of Product objects and assign it to the products list
      products = data.map((json) => Product.fromJson(json)).toList();
    } else {
      // Throw an exception if the request fails
      throw Exception('Failed to fetch products');
    }
  }
}
