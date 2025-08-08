import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'disaster_report.dart'; 

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Submit a new disaster report with image stored in Firestore (FREE)
  static Future<String?> submitReport({
    required String title,
    required String description,
    required String location,
    required File imageFile,
    required String disasterType,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not authenticated');
        return null;
      }

      // Check if file exists
      if (!await imageFile.exists()) {
        print('Image file does not exist');
        return null;
      }

      print('Processing image...');
      
      // Convert image to base64 string (completely free)
      final Uint8List imageBytes = await imageFile.readAsBytes();
      
      // Compress image if too large (keep under 1MB for Firestore)
      String base64Image;
      if (imageBytes.length > 800000) { // ~800KB limit
        print('Warning: Image is large. Consider compressing.');
      }
      
      base64Image = base64Encode(imageBytes);
      
      print('Image processed successfully');

      // Create report document with embedded image
      final reportId = _firestore.collection('disaster_reports').doc().id;
      final report = DisasterReport(
        id: reportId,
        title: title,
        description: description,
        location: location,
        timestamp: DateTime.now(),
        imageUrl: base64Image, // Store base64 instead of URL
        userId: user.uid,
        userEmail: user.email ?? '',
        status: 'pending',
        latitude: latitude,
        longitude: longitude,
        disasterType: disasterType,
      );

      // Save to Firestore (completely free up to quotas)
      await _firestore.collection('disaster_reports').doc(reportId).set(report.toMap());
      
      print('Report saved successfully with ID: $reportId');
      return reportId;
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error submitting report: $e');
      return null;
    }
  }

  // Helper method to convert base64 back to image widget
  static Widget getImageFromBase64(String base64String) {
    try {
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          );
        },
      );
    } catch (e) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      );
    }
  }

  // Get all approved reports (simplified query - no ordering initially)
  static Stream<List<DisasterReport>> getApprovedReports() {
    return _firestore
        .collection('disaster_reports')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) {
          var reports = snapshot.docs
              .map((doc) => DisasterReport.fromMap(doc.data()))
              .toList();
          // Sort in memory instead of using Firestore ordering
          reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return reports;
        });
  }

  // Get pending reports for admin (simplified query)
  static Stream<List<DisasterReport>> getPendingReports() {
    return _firestore
        .collection('disaster_reports')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          var reports = snapshot.docs
              .map((doc) => DisasterReport.fromMap(doc.data()))
              .toList();
          // Sort in memory instead of using Firestore ordering
          reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return reports;
        });
  }

  // Get rejected reports for admin (simplified query)
  static Stream<List<DisasterReport>> getRejectedReports() {
    return _firestore
        .collection('disaster_reports')
        .where('status', isEqualTo: 'rejected')
        .snapshots()
        .map((snapshot) {
          var reports = snapshot.docs
              .map((doc) => DisasterReport.fromMap(doc.data()))
              .toList();
          // Sort in memory instead of using Firestore ordering
          reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return reports;
        });
  }

  // Update report status (admin function)
  static Future<bool> updateReportStatus(String reportId, String status) async {
    try {
      await _firestore.collection('disaster_reports').doc(reportId).update({
        'status': status,
      });
      return true;
    } catch (e) {
      print('Error updating report status: $e');
      return false;
    }
  }
}