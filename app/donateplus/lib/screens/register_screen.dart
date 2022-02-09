import 'package:donateplus/functions/bdayprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../functions/font.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime _today = DateTime.now();
  String _token = "";
  List<String> _bloodgroup = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
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
    return ChangeNotifierProvider(
      create: (context) => BdayProvider(),
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
                    child: const TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
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
                    child: const TextField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
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
                    child: const TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Ionicons.location),
                        label: Text("Location"),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                  child: Consumer<BdayProvider>(
                    builder: (context, providerdata, child) {
                      DateTime _dob = providerdata.getbday();
                      return Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
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
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                  ),
                  width: double.infinity,
                  child: DropdownButton(
                      hint: const Text("Blood Group"),
                      borderRadius: BorderRadius.circular(18),
                      items: _bloodgroup
                          .map((e) => DropdownMenuItem(
                                child: Text(e.toString()),
                                value: e.toString(),
                              ))
                          .toList(),
                      onChanged: (value) {}),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
