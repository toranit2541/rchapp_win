import 'package:flutter/material.dart';
import 'package:rchapp_v2/data/apiservice.dart';
import 'package:rchapp_v2/sreens/authen/login.dart';

class Profilepage extends StatelessWidget {
  Profilepage({super.key});
  final String firstName = 'John';
  final String lastName = 'Doe';
  final String tel = '123-456-7890';
  final String idCard = '123456789';
  final String age = '30';
  final String gender = 'Male';

  final ApiService _apiService = ApiService();

  Future<void> _logout(BuildContext context) async {
  try {
    await _apiService.logout(context); // Call the logout method
    if (!context.mounted) return; // Check if the widget is still mounted
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(title: 'Rch Plus'),
      ),
    );
  } catch (error) {
    // Handle any errors during logout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout failed: $error')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header Section
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFb1d8b7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    'assets/images/male.png', // Replace with your image URL or asset
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'TORANIT WONGKHAMSA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'toranit.wo.41@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // User Info Section
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อมูลส่วนตัว',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.phone, color: Color(0xFF2f5233)),
                  title: Text('เบอร์โทรศัพท์'),
                  subtitle: Text('090 263 9777'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.location_on, color: Color(0xFF2f5233)),
                  title: Text('ที่อยู่'),
                  subtitle: Text('438/17 Bang Bo Bang Bo Samutprakran'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.cake, color: Color(0xFF2f5233)),
                  title: Text('วันเกิด'),
                  subtitle: Text('April 15, 1998'),
                ),
              ],
            ),
          ),

          // Action Buttons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Edit Profile Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF76b947),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    _logout(context); // Logout and navigate to login
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF76b947)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: Color(0xFF76b947)),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Color(0xFF76b947)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
