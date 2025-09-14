import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSetup {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Default admin credentials
  static const String defaultAdminEmail = 'admin@gmail.com';
  static const String defaultAdminPassword = 'admin12345678';

  // Initialize default admin on app startup
  static Future<void> initializeDefaultAdmin() async {
    try {
      // Check if default admin already exists
      final adminExists = await _checkAdminExists(defaultAdminEmail);
      
      if (!adminExists) {
        await _createDefaultAdmin();
        print('✅ Default admin created successfully');
      } else {
        print('ℹ️ Default admin already exists');
      }
    } catch (e) {
      print('❌ Error initializing default admin: $e');
    }
  }

  // Check if admin exists in Firestore
  static Future<bool> _checkAdminExists(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: 'admin')
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Create default admin account
  static Future<void> _createDefaultAdmin() async {
    try {
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: defaultAdminEmail,
        password: defaultAdminPassword,
      );

      // Create admin profile in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': defaultAdminEmail,
        'role': 'admin',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isActive': true,
        'isDefaultAdmin': true,
        'createdBy': 'system',
      });

      // Sign out after creation
      await _auth.signOut();
    } catch (e) {
      print('Error creating default admin: $e');
      rethrow;
    }
  }

  // Create new admin account (only for existing admins)
  static Future<String> createNewAdmin({
    required String email,
    required String password,
    required String currentAdminId,
  }) async {
    try {
      // Verify current user is admin
      final isCurrentUserAdmin = await _isUserAdmin(currentAdminId);
      if (!isCurrentUserAdmin) {
        throw Exception('Only admins can create new admin accounts');
      }

      // Check if user already exists
      final userExists = await _checkUserExists(email);
      if (userExists) {
        throw Exception('User with this email already exists');
      }

      // Save current user session
      final currentUser = _auth.currentUser;
      
      // Create new admin user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create admin profile
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': 'admin',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'isActive': true,
        'isDefaultAdmin': false,
        'createdBy': currentAdminId,
      });

      // Sign out the newly created user and restore previous session
      await _auth.signOut();
      
      // Note: You might need to handle re-authentication of the original admin here
      
      return 'Admin account created successfully for $email';
    } catch (e) {
      return 'Error creating admin: ${e.toString()}';
    }
  }

  // Check if user exists
  static Future<bool> _checkUserExists(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check if user is admin
  static Future<bool> _isUserAdmin(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role'] == 'admin';
      }
    } catch (e) {
      print('Error checking admin status: $e');
    }
    return false;
  }

  // Get all admin users (for management)
  static Stream<List<Map<String, dynamic>>> getAllAdmins() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // Remove admin role (only for non-default admins)
  static Future<String> removeAdminRole(String adminId, String currentAdminId) async {
    try {
      // Check if target is default admin
      final doc = await _firestore.collection('users').doc(adminId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['isDefaultAdmin'] == true) {
          throw Exception('Cannot remove default admin');
        }
      }

      // Verify current user is admin
      final isCurrentUserAdmin = await _isUserAdmin(currentAdminId);
      if (!isCurrentUserAdmin) {
        throw Exception('Only admins can remove admin roles');
      }

      // Update role to user
      await _firestore.collection('users').doc(adminId).update({
        'role': 'user',
        'modifiedAt': DateTime.now().millisecondsSinceEpoch,
        'modifiedBy': currentAdminId,
      });

      return 'Admin role removed successfully';
    } catch (e) {
      return 'Error removing admin role: ${e.toString()}';
    }
  }
}