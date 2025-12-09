import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../../../shared/models/user_model.dart';

class AuthService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  // Modo demo - usuario mock almacenado en memoria
  User? _demoUser;
  final _authStateController = StreamController<AuthState>.broadcast();
  bool _initialStateEmitted = false;

  bool get isDemoMode => _supabase == null;

  AuthService() {
    // Emitir estado inicial en modo demo
    if (isDemoMode && !_initialStateEmitted) {
      _initialStateEmitted = true;
      Future.microtask(() {
        _authStateController.add(const AuthState(
          AuthChangeEvent.signedOut,
          null,
        ));
      });
    }
  }

  // Obtener usuario actual
  User? get currentUser {
    if (isDemoMode) {
      return _demoUser;
    }
    return _supabase?.auth.currentUser;
  }

  // Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges {
    if (isDemoMode) {
      return _authStateController.stream;
    }
    return _supabase!.auth.onAuthStateChange;
  }

  // Iniciar sesión con teléfono (enviar OTP)
  Future<void> signInWithPhone(String phone) async {
    if (isDemoMode) {
      // En modo demo, simular envío de OTP (siempre acepta cualquier código)
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    try {
      await _supabase!.auth.signInWithOtp(
        phone: phone,
        data: {
          'phone': phone,
        },
      );
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Verificar código OTP
  Future<AuthResponse> verifyOTP({
    required String phone,
    required String token,
    String? type,
  }) async {
    if (isDemoMode) {
      // En modo demo, aceptar cualquier código y crear usuario mock
      await Future.delayed(const Duration(milliseconds: 500));

      // Crear usuario mock
      _demoUser = User(
        id: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
        appMetadata: {},
        userMetadata: {
          'phone': phone,
        },
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
      );

      // Emitir evento de autenticación
      _authStateController.add(AuthState(
        AuthChangeEvent.signedIn,
        Session(
          accessToken: 'demo-token',
          tokenType: 'bearer',
          expiresIn: 3600,
          refreshToken: 'demo-refresh',
          user: _demoUser!,
        ),
      ));

      return AuthResponse(
        session: Session(
          accessToken: 'demo-token',
          tokenType: 'bearer',
          expiresIn: 3600,
          refreshToken: 'demo-refresh',
          user: _demoUser!,
        ),
        user: _demoUser!,
      );
    }
    try {
      final response = await _supabase!.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );

      // Crear perfil si no existe
      final user = response.user;
      if (user != null) {
        await _createProfileIfNotExists(user);
      }

      return response;
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Iniciar sesión con email (enviar código)
  Future<void> signInWithEmail(String email) async {
    if (isDemoMode) {
      // En modo demo, simular envío de código
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    try {
      await _supabase!.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null,
      );
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Verificar código de email
  Future<AuthResponse> verifyEmailOTP({
    required String email,
    required String token,
  }) async {
    if (isDemoMode) {
      // En modo demo, aceptar cualquier código y crear usuario mock
      await Future.delayed(const Duration(milliseconds: 500));

      // Crear usuario mock
      _demoUser = User(
        id: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
        appMetadata: {},
        userMetadata: {
          'email': email,
        },
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
        email: email,
      );

      // Emitir evento de autenticación
      _authStateController.add(AuthState(
        AuthChangeEvent.signedIn,
        Session(
          accessToken: 'demo-token',
          tokenType: 'bearer',
          expiresIn: 3600,
          refreshToken: 'demo-refresh',
          user: _demoUser!,
        ),
      ));

      return AuthResponse(
        session: Session(
          accessToken: 'demo-token',
          tokenType: 'bearer',
          expiresIn: 3600,
          refreshToken: 'demo-refresh',
          user: _demoUser!,
        ),
        user: _demoUser!,
      );
    }
    try {
      final response = await _supabase!.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );

      // Crear perfil si no existe
      final user = response.user;
      if (user != null) {
        await _createProfileIfNotExists(user);
      }

      return response;
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Iniciar sesión con Apple
  Future<bool> signInWithApple() async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'boop://auth-callback',
      );
      return true;
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    if (isDemoMode) {
      _demoUser = null;
      _authStateController
          .add(const AuthState(AuthChangeEvent.signedOut, null));
      return;
    }
    try {
      await _supabase!.auth.signOut();
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Obtener perfil del usuario actual
  Future<UserModel?> getCurrentUserProfile() async {
    if (isDemoMode) {
      final user = currentUser;
      if (user == null) return null;

      // Retornar perfil mock
      return UserModel(
        id: user.id,
        email: user.email ?? user.userMetadata?['email'] as String?,
        phone: user.phone ?? user.userMetadata?['phone'] as String?,
        name: user.userMetadata?['name'] as String? ??
            user.email?.split('@')[0] ??
            'Usuario Demo',
        avatarUrl: null,
        bio: null,
        city: 'Ciudad Demo',
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
    }

    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase!
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Crear perfil si no existe
  Future<void> _createProfileIfNotExists(User user) async {
    if (_supabase == null) return;
    try {
      // Verificar si el perfil ya existe
      final existing = await _supabase!
          .from('profiles')
          .select('user_id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (existing == null) {
        // Crear nuevo perfil
        await _supabase!.from('profiles').insert({
          'user_id': user.id,
          'name': user.userMetadata?['name'] ?? user.email?.split('@')[0],
          'email': user.email,
          'phone': user.phone,
        });
      }
    } catch (e) {
      // Ignorar errores al crear perfil (puede que ya exista)
    }
  }

  // Manejo de errores de autenticación
  String _handleAuthError(AuthException e) {
    switch (e.statusCode) {
      case 'invalid_phone_number':
        return 'Número de teléfono inválido';
      case 'invalid_email':
        return 'Correo electrónico inválido';
      case 'invalid_otp':
        return 'Código OTP incorrecto';
      case 'expired_token':
        return 'El código ha expirado. Por favor, solicita uno nuevo';
      case 'token_not_found':
        return 'Código no encontrado. Por favor, solicita uno nuevo';
      case 'user_not_found':
        return 'Usuario no encontrado';
      case 'email_not_confirmed':
        return 'Correo electrónico no verificado';
      default:
        return e.message;
    }
  }
}
