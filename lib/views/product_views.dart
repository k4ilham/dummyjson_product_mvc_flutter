// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_mvc_app/models/product_model.dart';
import '../controllers/product_controller.dart';

// Define a ProductView widget which is a StatefulWidget
// ignore: use_key_in_widget_constructors
class ProductView extends StatefulWidget {
  @override
  _ProductViewState createState() => _ProductViewState();
}

// Define the state of the ProductView widget
class _ProductViewState extends State<ProductView> {
  late Future<List<Product>>
      _futureProducts; // Declare a Future to store the list of products

  @override
  void initState() {
    super.initState();
    _futureProducts =
        _fetchProducts(); // Initialize the future with the result of _fetchProducts() method
  }

  // Define a method to fetch the products asynchronously
  Future<List<Product>> _fetchProducts() async {
    final productController =
        ProductController(); // Create an instance of the ProductController
    await productController
        .fetchProducts(); // Fetch the products using the controller
    return productController.products; // Return the fetched products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        future:
            _futureProducts, // Use the future to retrieve the list of products
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator if the future is not yet complete
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Show an error message if there was an error fetching the products
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            // Show the list of products if data is available
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover, // Set the fit property to BoxFit.cover
                    width: 80, // Set a fixed width for the image
                    height: 80, // Set a fixed height for the image
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.category),
                  trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                );
              },
            );
          } else {
            // Show a message if no data is available
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
