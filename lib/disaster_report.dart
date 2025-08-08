class DisasterReport {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime timestamp;
  final String imageUrl;
  final String userId;
  final String userEmail;
  final String status; // 'pending', 'approved', 'rejected'
  final double? latitude;
  final double? longitude;
  final String disasterType;

  DisasterReport({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.imageUrl,
    required this.userId,
    required this.userEmail,
    required this.status,
    this.latitude,
    this.longitude,
    required this.disasterType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'userId': userId,
      'userEmail': userEmail,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'disasterType': disasterType,
    };
  }

  factory DisasterReport.fromMap(Map<String, dynamic> map) {
    return DisasterReport(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      status: map['status'] ?? 'pending',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      disasterType: map['disasterType'] ?? '',
    );
  }
}