// lib/pages/auth/login_page.dart
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todak_commerce/bloc/auth/auth_bloc.dart';
import 'package:todak_commerce/bloc/auth/auth_event.dart';
import 'package:todak_commerce/bloc/auth/auth_state.dart';
import 'package:todak_commerce/widgets/app_button.dart';
import 'package:lottie/lottie.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    // Dispatch LoginRequested event to AuthBloc
    BlocProvider.of<AuthBloc>(context).add(
      LoginRequested(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              // Listen for state changes and show messages or navigate
              if (state is AuthError) {
                floatingSnackBar(message: state.message, context: context);                
              }
              // Authenticated state is handled in main.dart's BlocBuilder
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/loftie/login.json',
                      height: MediaQuery.of(context).size.height * 0.3, // 40% of the screen height
                      width: MediaQuery.of(context).size.width * 0.9, // 80% of the screen width
                    ),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24.0),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24.0),
                    AppButton(text: 'Login', onPressed: _onLoginButtonPressed,isLoading: state is AuthLoading,),                    
                         // Show loading indicator
                         
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
