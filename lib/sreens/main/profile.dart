import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:rchapp_v2/data/apiservice.dart';
import 'package:rchapp_v2/sreens/authen/login.dart';
import 'package:rchapp_v2/widget/holytreepainter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  late List<LightOrb> _lightOrbs;
  late Ticker _ticker;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _initializeLights();

    _ticker = createTicker((_) {
      setState(() {
        for (var orb in _lightOrbs) {
          orb.move();
        }
      });
    })..start();
  }

  void _initializeLights() {
    _lightOrbs = List.generate(5, (index) {
      return LightOrb(
        position: Offset(_random.nextDouble() * 400, _random.nextDouble() * 600),
        radius: _random.nextDouble() * 10 + 5,
        velocity: Offset(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1),
      );
    });
  }

  Future<void> _fetchProfileData() async {
    try {
      final data = await _apiService.fetchProfileData();
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching profile data: $error");
    }
  }

  Future<void> _logout() async {
    try {
      await _apiService.logout(context);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage(title: 'Rch Plus')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $error')),
      );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
      children: [
        // Holy Tree Background with Animated Light Orbs
        Positioned.fill(
          child: CustomPaint(painter: HolyTreePainter(_lightOrbs)),
        ),

        // Profile Info
        SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFb1d8b7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/male.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_profileData?['first_name'] ?? 'Unknown'} ${_profileData?['last_name'] ?? 'User'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _profileData?['email'] ?? 'No Email Available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // User Info Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อมูลส่วนตัว',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Color(0xFF2f5233)),
                      title: const Text('เบอร์โทรศัพท์'),
                      subtitle: Text(_profileData?['account']?['phonenumber'] ?? 'No Phone'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Color(0xFF2f5233)),
                      title: const Text('ที่อยู่'),
                      subtitle: Text(
                        '${_profileData?['patient_data']?['addressNo'] ?? ''} '
                            '${_profileData?['patient_data']?['street'] ?? ''} '
                            '${_profileData?['patient_data']?['moo'] ?? ''} '
                            '${_profileData?['patient_data']?['tambol'] ?? ''} '
                            '${_profileData?['patient_data']?['aumper'] ?? ''} '
                            '${_profileData?['patient_data']?['province'] ?? ''} '
                            '${_profileData?['patient_data']?['zipCode'] ?? ''}',
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cake, color: Color(0xFF2f5233)),
                      title: const Text('วันเกิด'),
                      subtitle: Text(
                        _formatDate(_profileData?['account']?['birthday']),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _logout,
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
        ),
      ],
    );
  }

  // Function to format date
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'No Birthday';
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
