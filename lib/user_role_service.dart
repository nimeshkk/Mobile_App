import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRoleService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user profile with role
  static Future<void> createUserProfile(String email, {String role = 'user'}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': role,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'isActive': true,
        });
      }
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  // Check if current user is admin
  static Future<bool> isAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role'] == 'admin';
      }
    } catch (e) {
      print('Error checking admin status: $e');
    }
    return false;
  }

  // Get user role
  static Future<String> getUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'guest';

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role'] ?? 'user';
      }
    } catch (e) {
      print('Error getting user role: $e');
    }
    return 'user';
  }

  // Make user admin (only for testing - remove in production)
  static Future<void> makeUserAdmin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': 'admin',
      });
    } catch (e) {
      print('Error making user admin: $e');
    }
  }
}