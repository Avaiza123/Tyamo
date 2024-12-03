import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream to monitor authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToErrorMessage(e);
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToErrorMessage(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToErrorMessage(e);
    }
  }

  // Delete user account
  Future<void> deleteUser() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToErrorMessage(e);
    }
  }

  // Update user's email
  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToErrorMessage(e);
    }
  }

  // Update user's password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToErrorMessage(e);
    }
  }

  // Helper function to map FirebaseAuthException to readable error messages
  String _mapFirebaseAuthExceptionToErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email address is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'An undefined error occurred. Please try again later.';
    }
  }
}
