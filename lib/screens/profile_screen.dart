import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/5220411444.jpg'),
              ),
              SizedBox(height: 16),
              Text(
                profileProvider.profileData.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                profileProvider.profileData.university,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Divider(),
              _buildProfileOption(
                context,
                label: 'Kelola Akun',
                icon: Icons.account_circle,
                onTap: () => Navigator.pushNamed(context, '/edit-profile'),
              ),
              _buildProfileOption(
                context,
                label: 'Notifications',
                icon: Icons.notifications,
                onTap: () {},
              ),
              _buildProfileOption(
                context,
                label: 'Privacy Policy',
                icon: Icons.privacy_tip,
                onTap: () {},
              ),
              _buildProfileOption(
                context,
                label: 'Terms of Service',
                icon: Icons.article,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required String label, required IconData icon, required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(label, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
