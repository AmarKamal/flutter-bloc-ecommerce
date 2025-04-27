// lib/bloc/auth/auth_bloc.dart
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todak_commerce/api/api_service.dart'; // Assuming your project name is todak_commerce
import 'package:todak_commerce/bloc/auth/auth_event.dart';
import 'package:todak_commerce/bloc/auth/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc({required this.apiService}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await apiService.login(event.username, event.password);
      if (user != null) {
        // Save token or user info for persistence (optional)
        final prefs = await SharedPreferences.getInstance();
        // *** CHANGED: Use null-aware operator ?? to handle potential null token ***
        await prefs.setString('userToken', user.token ?? ''); // Save token, provide empty string if null

        emit(Authenticated(user: user));
      } else {
        // This case is for invalid credentials as handled in ApiService
        emit(const AuthError(message: 'Invalid credentials'));
      }
    } catch (e) {
      // Safely handle potential null from e.toString()
      final errorMessage = e.toString();
      emit(AuthError(message: 'Login failed: $errorMessage'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    // Clear saved data (optional)
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken'); // Example: remove token

    emit(Unauthenticated());
  }

  // Optional: Check saved login state on app start
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('userToken');

    if (userToken != null && userToken.isNotEmpty) {
       // In a real app, you would validate the token with the API here
       // For this simple example, we'll just assume a token means authenticated
       // and emit Unauthenticated, requiring login again.
       // A better approach would be to store minimal user info or refetch user details.
       emit(Unauthenticated()); // Start as unauthenticated, login required
    } else {
      emit(Unauthenticated());
    }
  }
}
