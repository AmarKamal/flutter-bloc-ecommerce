import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class FetchMoreProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object> get props => [query];
}

class ApplyFilter extends ProductEvent {
  final String? category;

  const ApplyFilter({this.category});

  @override
  List<Object> get props => [category ?? ''];
}
