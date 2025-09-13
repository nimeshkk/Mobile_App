import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppHeader(),
              const SizedBox(height: 24),
              _buildDescriptionCard(),
              const SizedBox(height: 20),
              _buildFeaturesCard(),
              const SizedBox(height: 20),
              _buildMissionCard(),
              const SizedBox(height: 20),
              _buildVersionCard(),
              const SizedBox(height: 20),
              _buildDisclaimerCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/disaster1.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.emergency,
                      size: 60,
                      color: Colors.red.shade600,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Disaster Management App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Keeping Communities Safe & Informed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _buildInfoCard(
      title: 'About Our App',
      icon: Icons.info_outline,
      iconColor: Colors.blue.shade600,
      child: const Text(
        'Our Disaster Management App is designed to help communities prepare for, respond to, and recover from natural disasters and emergencies. We provide real-time reporting, weather updates, and emergency resources to keep you and your loved ones safe.',
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      {
        'icon': Icons.warning_rounded,
        'title': 'Disaster Reporting',
        'description': 'Report disasters and emergencies in real-time'
      },
      {
        'icon': Icons.wb_sunny_rounded,
        'title': 'Weather Updates',
        'description': 'Get current weather and severe weather alerts'
      },
      {
        'icon': Icons.list_alt_rounded,
        'title': 'Verified Reports',
        'description': 'View approved disaster reports from your area'
      },
      {
        'icon': Icons.admin_panel_settings,
        'title': 'Admin Management',
        'description': 'Administrative tools for report verification'
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Emergency Alerts',
        'description': 'Receive immediate notifications for emergencies'
      },
      {
        'icon': Icons.location_on,
        'title': 'Location Services',
        'description': 'GPS-based disaster reporting and alerts'
      },
    ];

    return _buildInfoCard(
      title: 'Key Features',
      icon: Icons.star_outline,
      iconColor: Colors.orange.shade600,
      child: Column(
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMissionCard() {
    return _buildInfoCard(
      title: 'Our Mission',
      icon: Icons.favorite_outline,
      iconColor: Colors.red.shade600,
      child: const Text(
        'To create a safer, more prepared community by providing accessible tools for disaster reporting, real-time weather monitoring, and emergency communication. We believe that informed communities are resilient communities.',
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTeamMember(String role, String expertise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.person_outline,
            color: Colors.green.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  expertise,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _buildContactItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionCard() {
    return _buildInfoCard(
      title: 'App Information',
      icon: Icons.info_outline,
      iconColor: Colors.teal.shade600,
      child: Column(
        children: [
          _buildInfoRow('Version', '1.0.0'),
          _buildInfoRow('Build Number', '1'),
          _buildInfoRow('Last Updated', 'September 2025'),
          _buildInfoRow('Platform', 'Android & iOS'),
          _buildInfoRow('Technology', 'Flutter & Firebase'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsCard() {
    return _buildInfoCard(
      title: 'Emergency Contacts',
      icon: Icons.emergency_outlined,
      iconColor: Colors.red.shade600,
      child: Column(
        children: [
          const Text(
            'In case of immediate emergency, contact:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildEmergencyContact('Police', '911', Icons.local_police),
          _buildEmergencyContact('Fire Department', '911', Icons.local_fire_department),
          _buildEmergencyContact('Medical Emergency', '911', Icons.local_hospital),
          _buildEmergencyContact('Disaster Management', '1-800-DISASTER', Icons.warning),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(String service, String number, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          InkWell(
            onTap: () => _launchPhone(number),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return _buildInfoCard(
      title: 'Important Disclaimer',
      icon: Icons.warning_outlined,
      iconColor: Colors.orange.shade600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This app is designed to assist in disaster preparedness and response. However, it should not be your only source of emergency information.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '• Always follow official emergency protocols\n'
            '• Contact emergency services directly for immediate help\n'
            '• Verify information through multiple sources\n'
            '• Keep traditional emergency supplies and plans ready',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}