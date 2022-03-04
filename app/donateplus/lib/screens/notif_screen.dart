import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotifScreen extends StatefulWidget {
  final message;
  const NotifScreen({Key? key, this.message}) : super(key: key);

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RemoteMessage message = widget.message;
    debugPrint(widget.message.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Text(
                message.data["type"] == "client"
                    ? message.data["name"][0]
                    : message.data["location"][0],
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              radius: 50,
            ),
          ),
          Center(
            child: Text(
              message.data["type"] == "client"
                  ? message.data["name"]
                  : "BLOODBANK : " + message.data["location"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                iconColor: Colors.blue,
                leading: const Icon(Icons.phone),
                title: const Text(
                  "Contact",
                ),
                subtitle: Text(message.data["contact"]),
                onTap: () {
                  launch("tel://" + message.data["contact"]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                iconColor: Colors.red,
                leading: const Icon(Icons.location_on),
                title: const Text(
                  "Location",
                ),
                subtitle: Text(
                  message.data["location"],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                iconColor: Colors.red,
                leading: const Icon(Icons.location_on),
                title: const Text(
                  "Required Blood Type",
                ),
                subtitle: Text(
                  message.data["blood_group"],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Please call the person on his mobile number to contact him directly to help."),
          )
        ],
      ),
    );
  }
}
