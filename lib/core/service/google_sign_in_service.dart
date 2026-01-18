import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.readonly',
    ],
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('Google Sign-In error: $error');
      return null;
    }
  }

  Future<String?> getToken(GoogleSignInAccount? account) async {
    if (account == null) {
      debugPrint('No Google account signed in');
      return null;
    }
    final auth = await account.authentication;
    if (auth.accessToken == null) {
      debugPrint('Failed to retrieve access token');
      return null;
    }
    return auth.accessToken;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
  }
}