import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'disaster_report.dart';
import 'firebase_service.dart';
import 'user_role_service.dart';
import 'signIn.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAdminAccess();
  }

  void _checkAdminAccess() async {
    final isAdmin = await UserRoleService.isAdmin();
    if (!isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Pending Reports', icon: Icon(Icons.pending)),
            Tab(text: 'Approved Reports', icon: Icon(Icons.check_circle)),
            Tab(text: 'Rejected Reports', icon: Icon(Icons.cancel)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => Navigator.pushNamed(context, '/admin-management'),
            tooltip: 'Manage Admins',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportsList('pending'),
          _buildReportsList('approved'),
          _buildReportsList('rejected'),
        ],
      ),
    );
  }

  Widget _buildReportsList(String status) {
    return StreamBuilder<List<DisasterReport>>(
      stream: _getReportsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reports = snapshot.data ?? [];

        if (reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getStatusIcon(status),
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No $status reports',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return _buildReportCard(report, status);
          },
        );
      },
    );
  }

  Widget _buildReportCard(DisasterReport report, String currentStatus) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getDisasterColor(report.disasterType),
          child: Icon(
            _getDisasterIcon(report.disasterType),
            color: Colors.white,
          ),
        ),
        title: Text(
          report.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${report.disasterType}'),
            Text('Location: ${report.location}'),
            Text('Reported by: ${report.userEmail}'),
            Text('Date: ${_formatDate(report.timestamp)}'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report.imageUrl.isNotEmpty)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: report.imageUrl.startsWith('http')
                          ? Image.network(
                              report.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                );
                              },
                            )
                          : FirebaseService.getImageFromBase64(report.imageUrl),
                    ),
                  ),
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  report.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                if (report.latitude != null && report.longitude != null)
                  Text(
                    'Coordinates: ${report.latitude!.toStringAsFixed(6)}, ${report.longitude!.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 16),
                if (currentStatus == 'pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _updateReportStatus(report.id, 'approved'),
                        icon: const Icon(Icons.check),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _updateReportStatus(report.id, 'rejected'),
                        icon: const Icon(Icons.close),
                        label: const Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                if (currentStatus != 'pending')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: currentStatus == 'approved' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currentStatus.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<DisasterReport>> _getReportsByStatus(String status) {
    if (status == 'pending') {
      return FirebaseService.getPendingReports();
    } else if (status == 'approved') {
      return FirebaseService.getApprovedReports();
    } else {
      return FirebaseService.getRejectedReports();
    }
  }

  Future<void> _updateReportStatus(String reportId, String status) async {
    final success = await FirebaseService.updateReportStatus(reportId, status);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report ${status == 'approved' ? 'approved' : 'rejected'} successfully'),
          backgroundColor: status == 'approved' ? Colors.green : Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update report status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Color _getDisasterColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'flood':
        return Colors.blue;
      case 'earthquake':
        return Colors.brown;
      case 'tornado':
        return Colors.purple;
      case 'landslide':
        return Colors.orange;
      default:
        return Colors.grey;
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
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}