import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.all(0),
                accountName: Text("samir"),
                accountEmail: Text("+977 9804681405"),
                currentAccountPicture: CircleAvatar(
                  child: Text("S"),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              selected: true,
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Edit Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Donate Us"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                SharedPreferences sf = await SharedPreferences.getInstance();
                sf.setBool("isloginned", false);
                FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed("/login");
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {},
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), label: "Request Blood"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bloodtype), label: "Donate Blood"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city), label: "Blood Banks"),
        ],
      ),
    );
  }
}
