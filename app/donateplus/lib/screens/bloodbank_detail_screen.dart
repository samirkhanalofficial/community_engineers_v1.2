import 'package:donateplus/functions/font.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankDetailScreen extends StatefulWidget {
  final datas;
  const BloodBankDetailScreen({Key? key, this.datas}) : super(key: key);

  @override
  State<BloodBankDetailScreen> createState() => _BloodBankDetailScreenState();
}

class _BloodBankDetailScreenState extends State<BloodBankDetailScreen> {
  var bloodgroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios)),
            const Text("Back"),
          ],
        ),
        Hero(
          tag: widget.datas[0] + "logo",
          child: CircleAvatar(
            child: Text(
              widget.datas[0][0],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            radius: 50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              widget.datas[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: TextButton.icon(
              icon: const Icon(
                Icons.phone,
                color: Colors.blue,
              ),
              label: Text(
                widget.datas[1],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                launch("tel://" + widget.datas[1]);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Blood in Stocks:",
            style: skfont(
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            for (int j = 0; j < bloodgroups.length; j++)
              SizedBox(
                width: 150,
                height: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bloodgroups[j],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                          widget.datas[j + 2].toString() + " UNITS",
                        ),
                      ]),
                ),
              )
          ],
        )
      ]),
    );
  }
}
