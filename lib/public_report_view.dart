import 'package:app/disaster_report.dart';
import 'package:app/firebase/firebase_service.dart';
import 'package:flutter/material.dart';

class ApprovedReports extends StatelessWidget {
  const ApprovedReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Disaster Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh the stream
            },
            tooltip: 'Refresh Reports',
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      body: StreamBuilder<List<DisasterReport>>(
        stream: FirebaseService.getApprovedReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading reports...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 16, color: Colors.red.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Retry logic
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline, 
                      size: 64, 
                      color: Colors.blue.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Verified Reports',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No approved disaster reports are available at this time.',
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/report');
                    },
                    icon: const Icon(Icons.add_alert),
                    label: const Text('Report Disaster'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24, 
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Summary Header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verified Reports',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${reports.length} reports available',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Reports List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return _buildReportCard(context, report);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, DisasterReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Hero(
          tag: 'disaster_${report.id}',
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getDisasterColor(report.disasterType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getDisasterIcon(report.disasterType),
              color: _getDisasterColor(report.disasterType),
              size: 24,
            ),
          ),
        ),
        title: Text(
          report.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                Icons.category_outlined,
                'Type',
                report.disasterType,
                _getDisasterColor(report.disasterType),
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Location',
                report.location,
                Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                Icons.schedule_outlined,
                'Date',
                _formatDate(report.timestamp),
                Colors.grey.shade600,
              ),
            ],
          ),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              
              // Image Section
              if (report.imageUrl.isNotEmpty)
                Container(
                  height: 220,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: report.imageUrl.startsWith('http')
                        ? Image.network(
                            report.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image not available',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : FirebaseService.getImageFromBase64(report.imageUrl),
                  ),
                ),

              // Description Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'VERIFIED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Share functionality
                        },
                        icon: const Icon(Icons.share),
                        tooltip: 'Share Report',
                      ),
                      IconButton(
                        onPressed: () {
                          // Save/Bookmark functionality
                        },
                        icon: const Icon(Icons.bookmark_border),
                        tooltip: 'Bookmark',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getDisasterColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red.shade600;
      case 'flood':
        return Colors.blue.shade600;
      case 'earthquake':
        return Colors.brown.shade600;
      case 'tornado':
        return Colors.purple.shade600;
      case 'landslide':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getDisasterIcon(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'flood':
        return Icons.water_damage;
      case 'earthquake':
        return Icons.terrain;
      case 'tornado':
        return Icons.cyclone;
      case 'landslide':
        return Icons.landscape;
      default:
        return Icons.warning;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}