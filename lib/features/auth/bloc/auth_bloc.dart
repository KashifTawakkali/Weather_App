import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    // Authentication session
    on<AuthStarted>(_onAuthStarted);

    // Login
    on<AuthLoginRequested>(_onLoginRequested);

    // Registration
    on<AuthRegisterRequested>(_onRegisterRequested);

    // Logout
    on<AuthLogoutRequested>(_onLogoutRequested);

    // Firebase session changes
    on<_AuthenticatedUserDetected>(
      _onAuthenticatedUserDetected,
    );

    on<_UnauthenticatedUserDetected>(
      _onUnauthenticatedUserDetected,
    );
  }

  final AuthRepository _authRepository;

  StreamSubscription<User?>? _authSubscription;

  // ---------------------------------------------------------------------------
  // AUTH SESSION
  // ---------------------------------------------------------------------------

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    await _authSubscription?.cancel();

    _authSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          add(
            _AuthenticatedUserDetected(user),
          );
        } else {
          add(
            const _UnauthenticatedUserDetected(),
          );
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final credential = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );

      final user = credential.user;

      if (user == null) {
        emit(
          const AuthFailure(
            'Unable to sign in. Please try again.',
          ),
        );

        return;
      }

      emit(
        AuthAuthenticated(
          user,
          message: 'Login successful! Welcome back.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        AuthFailure(
          _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const AuthFailure(
          'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------------------------

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final credential = await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );

      final user = credential.user;

      if (user == null) {
        emit(
          const AuthFailure(
            'Unable to create your account.',
          ),
        );

        return;
      }

      emit(
        AuthAuthenticated(
          user,
          message: 'Account created successfully! Welcome to Weather Explorer.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        AuthFailure(
          _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const AuthFailure(
          'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.signOut();

      emit(
        const AuthUnauthenticated(),
      );
    } catch (_) {
      emit(
        const AuthFailure(
          'Unable to sign out. Please try again.',
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // FIREBASE AUTHENTICATED SESSION
  // ---------------------------------------------------------------------------

  void _onAuthenticatedUserDetected(
    _AuthenticatedUserDetected event,
    Emitter<AuthState> emit,
  ) {
    emit(
      AuthAuthenticated(event.user),
    );
  }

  // ---------------------------------------------------------------------------
  // FIREBASE UNAUTHENTICATED SESSION
  // ---------------------------------------------------------------------------

  void _onUnauthenticatedUserDetected(
    _UnauthenticatedUserDetected event,
    Emitter<AuthState> emit,
  ) {
    emit(
      const AuthUnauthenticated(),
    );
  }

  // ---------------------------------------------------------------------------
  // FIREBASE ERROR MESSAGES
  // ---------------------------------------------------------------------------

  String _firebaseErrorMessage(
    FirebaseAuthException exception,
  ) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled.';

      default:
        return exception.message ?? 'Authentication failed.';
    }
  }

  // ---------------------------------------------------------------------------
  // CLOSE
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();

    return super.close();
  }
}

// =============================================================================
// PRIVATE AUTH EVENTS
// =============================================================================

final class _AuthenticatedUserDetected extends AuthEvent {
  const _AuthenticatedUserDetected(
    this.user,
  );

  final User user;

  @override
  List<Object?> get props => [
        user.uid,
      ];
}

final class _UnauthenticatedUserDetected extends AuthEvent {
  const _UnauthenticatedUserDetected();
}
