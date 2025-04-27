
import 'package:flutter_bloc/flutter_bloc.dart';
import './product_event.dart';
import './product_state.dart';
import '../../api/api_service.dart';
import '../../models/product.dart';
import '../../utils/constants.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc({required this.apiService}) : super(const ProductState()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchMoreProducts>(_onFetchMoreProducts);
    on<SearchProducts>(_onSearchProducts);
    on<ApplyFilter>(_onApplyFilter);
  }

  
  List<Product> _applySearchAndFilterLocally(List<Product> products, String query, String? category) {
    List<Product> filteredList = products;

    
    if (category != null && category.isNotEmpty) {
      filteredList = filteredList.where((product) => product.category == category).toList();
    }

    
    if (query.isNotEmpty) {
      filteredList = filteredList.where((product) {
        final lowerCaseQuery = query.toLowerCase();
        return (product.title?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
               (product.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
      }).toList();
    }

    return filteredList;
  }


  
  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    
    
    if (state.displayedProducts.isEmpty) {
        emit(state.copyWith(isLoading: true, errorMessage: null));
    } else {
        
         emit(state.copyWith(isLoading: true, errorMessage: null)); 
    }


    try {
      
      final productsResponse = await apiService.getProducts(
        skip: 0, 
        limit: Constants.productsLimit,
        searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        category: state.filterCategory,
      );

      if (productsResponse != null) {
        final products = productsResponse;

        
        
        final bool hasMore = products.length == Constants.productsLimit;

        
        
        emit(state.copyWith(
          allProducts: products, 
          displayedProducts: products, 
          isLoading: false,
          hasMore: hasMore, 
          errorMessage: null,
          
          searchQuery: state.searchQuery,
          filterCategory: state.filterCategory,
        ));
      } else {
        
        emit(state.copyWith(
          isLoading: false,
          hasMore: false, 
          errorMessage: 'Failed to load products',
           allProducts: [], 
           displayedProducts: [],
        ));
      }
    } catch (e) {
      
      final errorMessage = e.toString() ?? 'An unknown error occurred.';
      emit(state.copyWith(
        isLoading: false,
        hasMore: false, 
        errorMessage: 'Error fetching products: $errorMessage',
         allProducts: [], 
         displayedProducts: [],
      ));
    }
  }

  
  Future<void> _onFetchMoreProducts(FetchMoreProducts event, Emitter<ProductState> emit) async {
    
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, errorMessage: null)); 

    try {
      
      
      final int nextSkip = state.allProducts.length;

      
      final newProductsResponse = await apiService.getProducts(
        skip: nextSkip,
        limit: Constants.productsLimit,
        searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        category: state.filterCategory,
      );

      if (newProductsResponse != null) {
        final newProducts = newProductsResponse;

        
        
        final bool hasMore = newProducts.length == Constants.productsLimit;

        
        final updatedAllProducts = List<Product>.from(state.allProducts)..addAll(newProducts);

        
        
        final updatedDisplayedProducts = updatedAllProducts;


        emit(state.copyWith(
          allProducts: updatedAllProducts,
          displayedProducts: updatedDisplayedProducts, 
          isLoadingMore: false,
          hasMore: hasMore, 
          errorMessage: null,
        ));
      } else {
        
        emit(state.copyWith(
          isLoadingMore: false,
          hasMore: false, 
          errorMessage: 'Failed to load more products',
        ));
      }
    } catch (e) {
      
      final errorMessage = e.toString() ?? 'An unknown error occurred.';
       emit(state.copyWith(
          isLoadingMore: false,
          hasMore: false, 
          errorMessage: 'Error fetching more products: $errorMessage',
        ));
    }
  }

  
  
  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
     final String newSearchQuery = event.query.trim();

     
     if (state.searchQuery == newSearchQuery) return;

    
    
    emit(state.copyWith(
      searchQuery: newSearchQuery,
      filterCategory: state.filterCategory, 
      allProducts: [], 
      displayedProducts: [], 
      hasMore: true, 
      isLoading: true, 
      isLoadingMore: false, 
      errorMessage: null, 
    ));

    
    add(FetchProducts());
  }

  
  
  void _onApplyFilter(ApplyFilter event, Emitter<ProductState> emit) {
    final String? newFilterCategory = event.category;

     
     if (state.filterCategory == newFilterCategory) return;

    
    print('ProductBloc: _onApplyFilter - New Filter Category: $newFilterCategory');


    
    
    emit(state.copyWith(
      searchQuery: state.searchQuery, 
      filterCategory: newFilterCategory,
      allProducts: [], 
      displayedProducts: [], 
      hasMore: true, 
      isLoading: true, 
      isLoadingMore: false, 
      errorMessage: null, 
    ));

    
    print('ProductBloc: _onApplyFilter - State after emit: filterCategory=${state.filterCategory}, isLoading=${state.isLoading}');


    
    add(FetchProducts());
  }
}
