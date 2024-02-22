import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unt_biometric_auth/env/env.dart';

class AuthService {
  final _client = Supabase.instance.client;

  final _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    clientId: Env.webClientId,
    scopes: [
      'email',
    ],
  );
  Session? getCurrentSession() {
    return _client.auth.currentSession;
  }

  Future<void> deleteSessionIfExits() async {
    final session = getCurrentSession();
    if (session != null) {
      await _client.auth.signOut();
    }
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<void> logOut() async {
    // await _googleSignIn.signOut();
    return await _client.auth.signOut();
  }

  Future<AuthResponse> signInWithGoogle() async {
    try {
      _googleSignIn.isSignedIn().then((value) => {
            if (value) {_googleSignIn.disconnect()}
          });
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final res = await _client.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: googleAuth.idToken!,
      );
      return res;
    } catch (e) {
      return AuthResponse(session: null);
    }
  }

  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  Future<AuthResponse> signInWithGoogleV0() async {
    try {
      // Just a random string
      final rawNonce = _generateRandomString();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      /// Client ID that you registered with Google Cloud.
      /// You will have two different values for iOS and Android.
      final clientId =
          Platform.isAndroid ? Env.androidClientId : Env.iosClientId;

      /// reverse DNS form of the client ID + `:/` is set as the redirect URL
      // final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

      const redirectUrl = 'com.unitru.biometric:/google_auth';

      /// Fixed value for google login
      const discoveryUrl =
          'https://accounts.google.com/.well-known/openid-configuration';

      const appAuth = FlutterAppAuth();


      // authorize the user by opening the concent page
      final result = await appAuth.authorize(
        AuthorizationRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          nonce: hashedNonce,
          scopes: ['email', 'profile'],
        ),
      );


      if (result == null) {
        throw 'Could not find AuthorizationResponse after authorizing';
      }

      // Request the access and id token to google
      final tokenResult = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          authorizationCode: result.authorizationCode,
          discoveryUrl: discoveryUrl,
          codeVerifier: result.codeVerifier,
          nonce: result.nonce,
          scopes: [
            'openid',
            'email',
          ],
        ),
      );


      final idToken = tokenResult?.idToken;

      if (idToken == null) {
        throw 'Could not find idToken from the token response';
      }

      final res = await _client.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        accessToken: tokenResult?.accessToken,
        nonce: rawNonce,
      );
      return res;
    } catch (e) {
      return AuthResponse(session: null);
    }
  }
}
