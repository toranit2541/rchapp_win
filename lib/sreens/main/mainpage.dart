import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/main/appointmentscreen.dart';
import 'package:rchapp_v2/sreens/main/footer.dart';
import 'package:rchapp_v2/sreens/main/header.dart';
import 'package:rchapp_v2/sreens/main/homesreen.dart';
import 'package:rchapp_v2/sreens/main/profile.dart';
import 'package:rchapp_v2/sreens/main/queue.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const QueuePage(),
    const AppointmentScreen(title: 'Rch Plus',),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(), // No more type issues
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
