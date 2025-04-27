// lib/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_commerce/bloc/cart/cart_state.dart';
import 'package:todak_commerce/pages/order/order_history_page.dart';

import '../../bloc/product/product_bloc.dart';
import '../../bloc/product/product_event.dart';
import '../../bloc/product/product_state.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../widgets/product_grid_item.dart';
import '../../widgets/shimmer_grid_loading.dart';
import '../cart/cart_page.dart';
import '../profile/profile_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProductListPage(),
    OrderHistoryPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Initial product fetch is handled by ProductListPage's initState
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple E-commerce',
         style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  ),
                  if (state.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.totalItems}',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onError, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['All', 'smartphones', 'laptops', 'fragrances', 'skincare', 'groceries', 'home-decoration', 'furniture', 'tops', 'womens-dresses', 'womens-shoes', 'mens-shirts', 'mens-shoes', 'mens-watches', 'womens-watches', 'womens-bags', 'womens-jewellery', 'sunglasses', 'automotive', 'motorcycle', 'lighting'];


  @override
  void initState() {
    super.initState();
    // Initial product fetch is handled here
    // It's dispatched when this widget is first created
    BlocProvider.of<ProductBloc>(context).add(FetchProducts());
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Listener for scroll events to trigger loading more products
  void _onScroll() {
    // Check if the user has scrolled close to the bottom (e.g., within 80% of the max scroll extent)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final productBloc = BlocProvider.of<ProductBloc>(context);
      // Dispatch FetchMoreProducts event if not already loading more and there are more products available
      if (!productBloc.state.isLoadingMore && productBloc.state.hasMore) {
         productBloc.add(FetchMoreProducts());
      }
    }
  }

  // Listener for search text changes to trigger a new product fetch
  void _onSearchChanged() {
    // Dispatch SearchProducts event with the current text field value
    // This event handler in the Bloc will trigger a new FetchProducts event
    BlocProvider.of<ProductBloc>(context).add(
      SearchProducts(query: _searchController.text),
    );
  }

  // Function to handle category filter selection to trigger a new product fetch
  void _onCategoryFilterSelected(String? category) {
    setState(() {
      // If 'All' is selected, set filterCategory to null
      _selectedCategory = (category == 'All' || category == null) ? null : category;
    });
    // Dispatch ApplyFilter event with the selected category
    // This event handler in the Bloc will trigger a new FetchProducts event
    BlocProvider.of<ProductBloc>(context).add(
      ApplyFilter(category: _selectedCategory),
    );
  }

  // *** ADDED: Function to handle pull-to-refresh ***
  Future<void> _onRefresh() async {
    // Dispatch the FetchProducts event to reload the first page
    // The Bloc will handle clearing the list and fetching based on current search/filter
    BlocProvider.of<ProductBloc>(context).add(FetchProducts());

    // Wait for the bloc to finish loading the first page
    // We can listen for the state change to know when it's done
    // This is a simplified approach; in a real app, you might await a specific state
    // or use a Completer. For now, we'll just wait a short duration or until not loading.
    // A more robust way is to use BlocListener or BlocConsumer within the build method
    // and signal completion when the state is no longer loading.
    // For demonstration, we'll await the bloc's state change.
    // This requires accessing the bloc and waiting for the loading state to become false.
    // This is slightly tricky in a simple Future<void> callback.
    // A common pattern is to use a Completer or simply rely on the Bloc's state stream.
    // Given the Bloc dispatches FetchProducts which sets isLoading, we can wait for isLoading to become false.

    final productBloc = BlocProvider.of<ProductBloc>(context);
    // Wait until the state is no longer loading
    await productBloc.stream.firstWhere((state) => !state.isLoading);

    // Alternatively, a simple delay:
    // await Future.delayed(const Duration(milliseconds: 500)); // Adjust delay as needed

  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Products...',
              prefixIcon: Icon(Icons.search, color: colorScheme.secondary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: colorScheme.secondary),
                      onPressed: () {
                        _searchController.clear();
                        BlocProvider.of<ProductBloc>(context).add(
                          const SearchProducts(query: ''),
                        );
                      },
                    )
                  : null,
            ),
            style: textTheme.bodyMedium,
          ),
        ),

        // Filter (Dropdown for Category)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Filter by Category',
              prefixIcon: Icon(Icons.filter_list, color: colorScheme.secondary),
            ),
            value: _selectedCategory ?? 'All',
            style: textTheme.bodyMedium,
            dropdownColor: colorScheme.surface,
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: textTheme.bodyMedium),
              );
            }).toList(),
            onChanged: _onCategoryFilterSelected,
          ),
        ),
        const SizedBox(height: 8.0),

        Expanded(
          // *** ADDED: Wrap the BlocBuilder with RefreshIndicator ***
          child: RefreshIndicator(
            onRefresh: _onRefresh, // Assign the pull-to-refresh callback
            color: colorScheme.primary, // Color of the refresh indicator
            backgroundColor: colorScheme.surface, // Background color of the indicator
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                // Display messages for empty results after search/filter
                if (!state.isLoading && state.displayedProducts.isEmpty && (state.searchQuery.isNotEmpty || state.filterCategory != null)) {
                  return Center(
                    child: Text(
                      state.searchQuery.isNotEmpty
                          ? 'No products found for "${state.searchQuery}"'
                          : 'No products found in category "${state.filterCategory}"',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground),
                    ),
                  );
                }
                 // Display message for no products available initially
                if (!state.isLoading && state.displayedProducts.isEmpty && state.searchQuery.isEmpty && state.filterCategory == null) {
                  return Center(
                    child: Text('No products available.',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground),
                    ),
                  );
                }


                // Show shimmer effect for grid during initial load
                if (state.isLoading && state.displayedProducts.isEmpty) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const ShimmerGridLoading();
                    },
                  );
                }
                // Show error message if initial load failed
                else if (state.errorMessage != null && state.displayedProducts.isEmpty) {
                  return Center(
                    child: Text('Error: ${state.errorMessage}',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                    ),
                  );
                }
                // Display the list of products in a grid
                else {
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.displayedProducts.length + (state.isLoadingMore ? 2 : 0),
                    itemBuilder: (context, index) {
                      // If it's the last item(s) and we are loading more, show a loading indicator
                      if (index >= state.displayedProducts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // Otherwise, show a product grid item
                      final product = state.displayedProducts[index];
                      return ProductGridItem(product: product);
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
