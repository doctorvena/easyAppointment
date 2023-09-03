import 'package:easyappointment_mobile/screens/profile_page.dart';
import 'package:easyappointment_mobile/screens/reservations/reservation_page.dart';
import 'package:easyappointment_mobile/screens/salon_list.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

class NavigationBarPage extends StatefulWidget {
  final int index;
  const NavigationBarPage({required this.index, super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: widget.index, length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      labels: const ["Pocetna", "Narudzbe", "Profil"],
      initialSelectedTab: widget.index == 0
          ? "Pocetna"
          : widget.index == 1
              ? "Narudzbe"
              : "Profil",
      tabIconColor: Colors.black,
      tabSelectedColor: Colors.deepOrange,
      onTabItemSelected: (int value) {
        setState(() {
          _tabController.index = value;
          if (_tabController.index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SalonListScreen(),
              ),
            );
          } else if (_tabController.index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ReservationsPage(),
              ),
            );
          } else if (_tabController.index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          }
        });
      },
      icons: const [Icons.home, Icons.assignment, Icons.account_box],
      textStyle: const TextStyle(color: Color.fromARGB(255, 85, 83, 83)),
    );
  }
}
