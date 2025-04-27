import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_commerce/utils/app_theme.dart';
import './api/api_service.dart';
import './bloc/auth/auth_bloc.dart';
import './bloc/auth/auth_state.dart';
import './bloc/product/product_bloc.dart';
import './bloc/cart/cart_bloc.dart';
import './bloc/order/order_bloc.dart';

import './pages/auth/login_page.dart';
import './pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(apiService: apiService)..checkAuthStatus(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(apiService: apiService),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
         BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Simple E-commerce App',
        debugShowCheckedModeBanner: false,
        theme: getAppTheme(),        
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
