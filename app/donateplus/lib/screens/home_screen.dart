import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:donateplus/functions/bloodgroupprovider.dart';
import 'package:donateplus/functions/configs.dart';
import 'package:donateplus/functions/font.dart';
import 'package:donateplus/functions/loading_provider.dart';
import 'package:donateplus/functions/printerror.dart';
import 'package:donateplus/screens/bloodbank_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String tempbloodgroup = '';
  final List<String> _bloodgroup = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-"
  ];
  String _phone = "";
  String _location = "";
  int _active = 0;
  var bloodbankdetails = [];
  logout() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setBool("isloginned", false);
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseMessaging.instance.unsubscribeFromTopic(tempbloodgroup);
    await _auth.signOut();

    Navigator.of(context).pushReplacementNamed("/");
  }

  var tempdata = [
    "id",
    "phone",
    "name",
    "blood group",
    "weight",
    "Diseases",
    "birthdate",
    "location",
  ];
  var aboutme = [];

  firstget() {
    getbloodbanks();
  }

  Future getbloodbanks() async {
    await Future.delayed(const Duration(seconds: 1));
    await http.get(Uri.parse(baseUrl + "/bloodbanks")).then((res) {
      var pbody = jsonDecode(res.body);
      bloodbankdetails = pbody["datas"];
      setState(() {});
      debugPrint(pbody.toString());
    }).catchError((e) {
      printerror(context, title: "Error", desc: e.toString());
    });
    setState(() {});
  }

  Future getaboutme() async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    await Future.delayed(const Duration(seconds: 1));
    await http.post(Uri.parse(baseUrl + "/aboutme"), body: {
      "token": token.toString(),
    }).then((res) async {
      var pbody = jsonDecode(res.body);
      if (pbody["status"] == 1) {
        aboutme = pbody["datas"];
        tempbloodgroup = aboutme[3].toString().replaceAll('+', 'plus');
        tempbloodgroup = tempbloodgroup.toString().replaceAll('-', 'minus');
        await FirebaseMessaging.instance.subscribeToTopic(tempbloodgroup);
        setState(() {});
        debugPrint(pbody["datas"].toString());
      } else {
        throw pbody["message"];
      }
    }).catchError((e) {
      printerror(context, title: "Error", desc: e.toString());
    });
    setState(() {});
  }

  @override
  void initState() {
    firstget();
    getaboutme();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _active,
          children: [
            RefreshIndicator(
              onRefresh: getbloodbanks,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Blood Banks",
                          style: skfont(
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < bloodbankdetails.length; i++)
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BloodBankDetailScreen(
                                  datas: bloodbankdetails[i],
                                )));
                      },
                      title: Text(bloodbankdetails[i][0]),
                      subtitle: Text(bloodbankdetails[i][1]),
                      leading: Hero(
                        tag: bloodbankdetails[i][0] + "logo",
                        child: Material(
                          child: CircleAvatar(
                            child: Text(bloodbankdetails[i][0][0]),
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    )
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: getaboutme,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "About Me",
                          style: skfont(
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: logout,
                            icon: const Icon(Icons.login_outlined)),
                      )
                    ],
                  ),
                  (aboutme.isNotEmpty)
                      ? ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            for (int i = 1; i < aboutme.length; i++)
                              ListTile(
                                title: Text(tempdata[i].toString()),
                                subtitle: Text(aboutme[i].toString()),
                                leading: const Icon(Icons.info),
                              )
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var token = await FirebaseAuth.instance.currentUser!.getIdToken();
          showModalBottomSheet(
              context: context,
              enableDrag: true,
              builder: (context) {
                _location = aboutme[7];
                _phone = aboutme[1];
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => BloodGroupProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => LoadingProvider(),
                    ),
                  ],
                  child: Builder(builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              height: 5,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Request for blood",
                              style: skfont(
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = _phone,
                                onChanged: (val) {
                                  _phone = val;
                                },
                                decoration: const InputDecoration(
                                    label: Text("Phone"),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.phone)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = _location,
                                onChanged: (val) {
                                  _location = val;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.location_on),
                                  label: Text("Location"),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Consumer<BloodGroupProvider>(
                                  builder: (context, value, _) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                      underline: const SizedBox(),
                                      hint: const Text("Blood Group"),
                                      borderRadius: BorderRadius.circular(18),
                                      value: value.value,
                                      enableFeedback: true,
                                      items: _bloodgroup
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e.toString()),
                                                value: e.toString(),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        value.changevalue(val.toString());
                                      }),
                                );
                              }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Consumer<LoadingProvider>(
                                  builder: (___, loading, ____) {
                                return loading.loading
                                    ? const Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          loading.changeisloading(true);
                                          var bloodgroup =
                                              Provider.of<BloodGroupProvider>(
                                                      context,
                                                      listen: false)
                                                  .value;
                                          http.post(
                                              Uri.parse(baseUrl + "/request"),
                                              body: {
                                                "token": token,
                                                "phone": _phone,
                                                "location": _location,
                                                "bloodgroup": bloodgroup,
                                              }).then((res) {
                                            var pbody = jsonDecode(res.body);
                                            if (pbody["status"] == 1) {
                                              loading.changeisloading(false);
                                              Navigator.of(context).pop();
                                              printerror(context,
                                                  title: "Request Sent",
                                                  desc:
                                                      "Please don't just relay on this. People who want to donate will call you.");
                                            } else {
                                              throw pbody["message"];
                                            }
                                          }).catchError((e) {
                                            loading.changeisloading(false);
                                            printerror(context,
                                                title: "Error",
                                                desc: e.toString());
                                          });
                                        },
                                        child: const Text("Request"),
                                      );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Colors.red,
        backgroundColor: Colors.black,
        inactiveColor: Colors.white,
        icons: const [
          Icons.bloodtype,
          Icons.person,
        ],
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeIndex: _active,
        onTap: (a) {
          setState(() {
            _active = a;
          });
        },
      ),
    );
  }
}
