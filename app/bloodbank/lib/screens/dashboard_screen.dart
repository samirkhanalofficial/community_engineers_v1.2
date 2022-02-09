import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/logo.png"),
                ),
                ListTile(
                  title: const Text("Dashboard"),
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text("Blood Bank Detail"),
                  leading: const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.black,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text("Settings"),
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
