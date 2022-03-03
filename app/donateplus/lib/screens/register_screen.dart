import 'dart:convert';

import 'package:donateplus/functions/bdayprovider.dart';
import 'package:donateplus/functions/bloodgroupprovider.dart';
import 'package:donateplus/functions/configs.dart';
import 'package:donateplus/functions/loading_provider.dart';
import 'package:donateplus/functions/printerror.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../functions/font.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final DateTime _today = DateTime.now();
  String _token = "";
  final TextEditingController _name = TextEditingController(),
      _weight = TextEditingController(),
      _location = TextEditingController(),
      _disease = TextEditingController();
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
  settoken() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var user = _auth.currentUser;
    if (user != null) {
      _token = await user.getIdToken();
    }
  }

  @override
  void initState() {
    settoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BdayProvider(),
        ),
        ChangeNotifierProvider(create: (context) => BloodGroupProvider()),
        ChangeNotifierProvider(create: ((context) => LoadingProvider())),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset("assets/logo.png"),
                ),
                Hero(
                  tag: "title",
                  child: Material(
                    child: Text(
                      "Registration",
                      style: skfont(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: "subtitle",
                  child: Material(
                    child: Text(
                      "Please fill these details to get started.",
                      style: skfont(),
                    ),
                  ),
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                    ),
                    width: double.infinity,
                    child: TextField(
                      controller: _name,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        label: Text("Full Name"),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                    ),
                    width: double.infinity,
                    child: TextField(
                      controller: _weight,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Ionicons.barbell),
                        label: Text("Weight(kg)"),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade200,
                    ),
                    width: double.infinity,
                    child: TextField(
                      controller: _location,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Ionicons.location),
                        label: Text("Location"),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.all(0),
                  child: Consumer<BdayProvider>(
                    builder: (context, providerdata, child) {
                      DateTime _dob = providerdata.getbday();
                      return Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.grey.shade200,
                          ),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime(
                                          _dob.year, _dob.month, _dob.day),
                                      firstDate: DateTime(1930, 1, 1),
                                      lastDate: DateTime(_today.year,
                                          _today.month, _today.day),
                                      helpText: "Please select your birthdate")
                                  .then((DateTime? value) {
                                providerdata.changebday(value!);
                              });
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Birthdate : ${_dob.year} / ${_dob.month} / ${_dob.day}",
                                  style: skfont(
                                      style: const TextStyle(
                                    fontSize: 15,
                                  )),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Blood Group:"),
                      Row(
                        children: [
                          const Icon(
                            Icons.bloodtype,
                            color: Colors.black38,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Consumer<BloodGroupProvider>(
                              builder: (context, value, _) {
                            return DropdownButton(
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
                                });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                  ),
                  width: double.infinity,
                  child: TextField(
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 5,
                    controller: _disease,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Ionicons.heart_half_sharp),
                      label: Text("Diseases"),
                      hintText: "eg. Asthama, Cancer , Diabities etc",
                      helperMaxLines: 2,
                      contentPadding: EdgeInsets.all(0),
                      helperText:
                          "Please Mention any diseases you have, if you don't have any leave this empty",
                      border: InputBorder.none,
                      alignLabelWithHint: false,
                      hintMaxLines: 4,
                    ),
                  ),
                ),
                Consumer<LoadingProvider>(builder: (context, value, _) {
                  return value.loading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Hero(
                          tag: "button",
                          child: Material(
                            child: Container(
                              decoration: const BoxDecoration(),
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  value.changeisloading(true);
                                  if (_token == "") {
                                    await settoken();
                                  }
                                  DateTime _bday = Provider.of<BdayProvider>(
                                          context,
                                          listen: false)
                                      .getbday();
                                  await http.post(
                                      Uri.parse(baseUrl + "/register"),
                                      body: {
                                        "token": _token,
                                        "name": _name.text,
                                        "weight": _weight.text,
                                        "location": _location.text,
                                        "dob":
                                            "${_bday.day}/${_bday.month}/${_bday.year}",
                                        "bloodgroup":
                                            Provider.of<BloodGroupProvider>(
                                                    context,
                                                    listen: false)
                                                .value,
                                        "disease": "" + _disease.text,
                                      }).then((res) async {
                                    if (res.statusCode == 200) {
                                      var body = jsonDecode(res.body);
                                      debugPrint(body.toString());
                                      if (body["status"] == 1) {
                                        value.changeisloading(false);

                                        SharedPreferences sf =
                                            await SharedPreferences
                                                .getInstance();
                                        await sf.setBool("isloginned", true);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          "/home",
                                          (route) => true,
                                        );
                                      } else {
                                        value.changeisloading(false);
                                        printerror(context,
                                            title: "Response",
                                            desc: body["message"]);
                                      }
                                    } else {
                                      value.changeisloading(false);
                                      printerror(context,
                                          title: "Network Error",
                                          desc:
                                              "There might be some problem with the internet or the server.");
                                    }
                                  }).catchError((err) {
                                    printerror(context,
                                        title: "Network Error",
                                        desc: "No Internet Conection.");
                                    value.changeisloading(false);
                                  });
                                },
                                child: const Text("Complete Registration"),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                )),
                              ),
                            ),
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
