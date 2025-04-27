
import 'package:equatable/equatable.dart';
import '../../models/product.dart';

class ProductState extends Equatable {
  final List<Product> allProducts; 
  final List<Product> displayedProducts; 
  final bool isLoading; 
  final bool isLoadingMore; 
  final bool hasMore; 
  final String? errorMessage; 
  final String searchQuery; 
  final String? filterCategory; 


  const ProductState({
    this.allProducts = const [],
    this.displayedProducts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.searchQuery = '', 
    this.filterCategory, 
  });

  
  int get currentProductCount => allProducts.length;

  
  ProductState copyWith({
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    String? searchQuery, 
    String? filterCategory, 
  }) {
    return ProductState(
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery, 
      filterCategory: filterCategory ?? this.filterCategory, 
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        displayedProducts,
        isLoading,
        isLoadingMore,
        hasMore,
        errorMessage,
        searchQuery,
        filterCategory,
      ];
}
