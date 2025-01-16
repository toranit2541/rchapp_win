import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int? selectedIndex; // Nullable
  final ValueChanged<int> onItemTapped;

  const Footer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return FlashyTabBar(
      
      selectedIndex: selectedIndex ?? 0, // Default to 0 if null
      showElevation: true,
      onItemSelected: onItemTapped,
      items: [
        FlashyTabBarItem(
          icon: const Icon(Icons.home),
          title: const Text('หน้าหลัก'),
          activeColor: const Color(0xFF76b947),
          inactiveColor: const Color(0xFFb1d8b7),
        ),
        
        FlashyTabBarItem(
          icon: const Icon(Icons.book_online_rounded),
          title: const Text('คิว'),
          activeColor: const Color(0xFF76b947),
          inactiveColor: const Color(0xFFb1d8b7),
        ),
        FlashyTabBarItem(
          icon: const Icon(Icons.calendar_month_rounded),
          title: const Text('หมอนัด'),
          activeColor: const Color(0xFF76b947),
          inactiveColor: const Color(0xFFb1d8b7),
        ),
        // FlashyTabBarItem(
        //   icon: const Icon(Icons.shopping_cart_checkout_rounded),
        //   title: const Text('ประวัติบริการ'),
        //   activeColor: const Color(0xFF76b947),
        //   inactiveColor: const Color(0xFFb1d8b7),
        // ),
        FlashyTabBarItem(
          icon: const Icon(Icons.person_3),
          title: const Text('ข้อมูลส่วนตัว'),
          activeColor: const Color(0xFF76b947),
          inactiveColor: const Color(0xFFb1d8b7),
        ),
      ],
    );
  }
}
