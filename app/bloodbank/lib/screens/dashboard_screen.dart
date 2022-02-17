import 'package:bloodbank/screens/bloodbanksdetails_screen.dart';
import 'package:bloodbank/screens/bloodcounteditscreen.dart';
import 'package:bloodbank/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String email, password;
  SharedPreferences? sf;
  List sidebar = <Map<String, dynamic>>[
    {
      "title": "Dashboard",
      "icon": Icons.home,
    },
    {
      "title": "Blood Bank Details",
      "icon": Icons.account_circle_sharp,
    },
    {
      "title": "Settings",
      "icon": Icons.settings,
    },
    {
      "title": "Logout",
      "icon": Icons.logout_outlined,
    },
  ];
  int active = 0;
  initializeshared() async {
    sf = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializeshared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Row(children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: 300,
          child: Material(
              child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/logo.png"),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  for (int i = 0; i < sidebar.length; i++)
                    ListTile(
                      title: Text(sidebar[i]["title"]),
                      leading: Icon(sidebar[i]["icon"]),
                      selected: i == active,
                      onTap: () async {
                        if (sidebar[i]["title"] == "Logout") {
                          await sf!.clear();
                          Navigator.of(context).pushReplacementNamed('/');
                        } else {
                          setState(() {
                            active = i;
                          });
                        }
                      },
                    )
                ]),
              ),
            ],
          )),
        ),
        Expanded(
          child: IndexedStack(
            index: active,
            children: const [
              BloodCountEditScreen(),
              BloodBankDetailsScreen(),
              SettingsScreen(),
            ],
          ),
        )
      ]),
    );
  }
}
