import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; // Add this package
import '../../disaster_report.dart'; 

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Submit a new disaster report with compressed image
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

      if (!await imageFile.exists()) {
        print('Image file does not exist');
        return null;
      }

      print('Processing image...');
      
      // Compress the image
      final compressedImageBytes = await _compressImage(imageFile);
      if (compressedImageBytes == null) {
        print('Failed to compress image');
        return null;
      }
      
      final base64Image = base64Encode(compressedImageBytes);
      print('Image compressed successfully. Size: ${compressedImageBytes.length} bytes');

      // Check if still too large (leave some buffer for other document data)
      if (compressedImageBytes.length > 800000) { // 800KB limit
        print('Error: Compressed image is still too large');
        return null;
      }

      // Create report document
      final reportId = _firestore.collection('disaster_reports').doc().id;
      final report = DisasterReport(
        id: reportId,
        title: title,
        description: description,
        location: location,
        timestamp: DateTime.now(),
        imageUrl: base64Image,
        userId: user.uid,
        userEmail: user.email ?? '',
        status: 'pending',
        latitude: latitude,
        longitude: longitude,
        disasterType: disasterType,
      );

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

  // Compress image to reduce size
  static Future<Uint8List?> _compressImage(File imageFile) async {
    try {
      // Read the image
      final imageBytes = await imageFile.readAsBytes();
      
      // Decode the image
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Calculate new dimensions (max 800x600 while maintaining aspect ratio)
      int maxWidth = 800;
      int maxHeight = 600;
      
      int newWidth = image.width;
      int newHeight = image.height;
      
      if (newWidth > maxWidth || newHeight > maxHeight) {
        double widthRatio = maxWidth / newWidth;
        double heightRatio = maxHeight / newHeight;
        double ratio = widthRatio < heightRatio ? widthRatio : heightRatio;
        
        newWidth = (newWidth * ratio).round();
        newHeight = (newHeight * ratio).round();
      }

      // Resize the image
      final resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Compress as JPEG with quality 85
      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
      
      print('Original size: ${imageBytes.length} bytes');
      print('Compressed size: ${compressedBytes.length} bytes');
      
      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      print('Error compressing image: $e');
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