import 'dart:convert';

import 'package:bloodbank/functions/configs.dart';
import 'package:bloodbank/functions/font.dart';
import 'package:bloodbank/functions/loading_provider.dart';
import 'package:bloodbank/functions/printerror.dart';
import 'package:bloodbank/functions/bloodgroupprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodCountEditScreen extends StatefulWidget {
  const BloodCountEditScreen({Key? key}) : super(key: key);

  @override
  State<BloodCountEditScreen> createState() => _BloodCountEditScreenState();
}

class _BloodCountEditScreenState extends State<BloodCountEditScreen> {
  var fetchedata = {};
  var temploading = true;
  String? email, password;
  fetchdata() async {
    if (temploading == true) {
      temploading = false;
      await Future.delayed(const Duration(seconds: 1));
    }
    Provider.of<LoadingProvider>(context, listen: false).changeisloading(true);
    SharedPreferences sf = await SharedPreferences.getInstance();
    email = sf.getString("email");
    password = sf.getString("password");
    await http.post(Uri.parse(baseUrl + "/admin/get"), body: {
      "email": email,
      "password": password,
    }).then((value) {
      var res = json.decode(value.body);
      if (res["status"] == 0) {
        Provider.of<LoadingProvider>(context, listen: false)
            .changeisloading(false);
        throw res["message"];
      } else {
        fetchedata = res["data"]!;
        Provider.of<LoadingProvider>(context, listen: false)
            .changeisloading(false);
      }
    }).catchError((e) {
      Provider.of<LoadingProvider>(context, listen: false)
          .changeisloading(false);
      printerror(context, title: "Network Error", desc: e.toString());
    });
  }

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stocks:",
                  style: skfont(
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            fetchdata();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Refresh")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            if (!Provider.of<LoadingProvider>(context,
                                    listen: false)
                                .loading) {
                              showBottomSheet(
                                  enableDrag: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  builder: (context) {
                                    var tempdata = fetchedata["datas"];
                                    return Center(
                                      child: Card(
                                        elevation: 10,
                                        child: Container(
                                          color: Colors.white,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Edit Stocks:",
                                                      style: skfont(
                                                        style: const TextStyle(
                                                          fontSize: 25,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        icon: const Icon(
                                                            Icons.close)),
                                                  ],
                                                ),
                                              ),
                                              for (int i = 0;
                                                  i <
                                                      fetchedata["datas"]!
                                                          .length;
                                                  i++)
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 2),
                                                  child: Container(
                                                    color: Colors.grey.shade200,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 2),
                                                      child: TextField(
                                                        controller:
                                                            TextEditingController()
                                                              ..text = tempdata[
                                                                          i]
                                                                      ["count"]
                                                                  .toString(),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          label: Text(
                                                            tempdata[i][
                                                                    "blood_group"]
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        onChanged: (val) {
                                                          tempdata[i]["count"] =
                                                              int.parse(val);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              Consumer<LoadingProvider>(
                                                builder: (_, value, __) =>
                                                    value.loading
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: LoadingAnimationWidget
                                                                      .threeArchedCircle(
                                                                color:
                                                                    Colors.red,
                                                                size: 50,
                                                              )),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      value.changeisloading(
                                                                          true);

                                                                      try {
                                                                        Map sendbody =
                                                                            {
                                                                          "email":
                                                                              email!,
                                                                          "password":
                                                                              password!
                                                                        };
                                                                        for (int i =
                                                                                0;
                                                                            i < tempdata.length;
                                                                            i++) {
                                                                          sendbody.putIfAbsent(
                                                                              tempdata[i]["blood_group"],
                                                                              () => tempdata[i]["count"].toString());
                                                                        }
                                                                        var res = await http.post(
                                                                            Uri.parse(baseUrl +
                                                                                "/admin/update"),
                                                                            body:
                                                                                sendbody);
                                                                        if (res.statusCode ==
                                                                            200) {
                                                                          var body =
                                                                              jsonDecode(res.body);
                                                                          if (body["status"] ==
                                                                              1) {
                                                                            value.changeisloading(false);
                                                                            printerror(context,
                                                                                title: "Updated Successfully",
                                                                                desc: "Data is updated Succesfully.");
                                                                            fetchdata();
                                                                          } else {
                                                                            throw body["message"];
                                                                          }
                                                                        } else {
                                                                          throw "Internet Connection error";
                                                                        }
                                                                      } catch (e) {
                                                                        value.changeisloading(
                                                                            false);
                                                                        printerror(
                                                                            context,
                                                                            title:
                                                                                "Network Error",
                                                                            desc:
                                                                                e.toString());
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child: Text(
                                                                          "Save Changes"),
                                                                    )),
                                                          ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("edit")),
                    ),
                  ],
                ),
              ],
            ),
            Consumer<LoadingProvider>(
              builder: (_, value, __) => (value.loading)
                  ? SizedBox(
                      height: 500,
                      child: Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.red,
                        size: 50,
                      )),
                    )
                  : (fetchedata["datas"] == null)
                      ? const SizedBox.shrink()
                      : Wrap(
                          children: [
                            for (int i = 0; i < fetchedata["datas"].length; i++)
                              SizedBox(
                                width: 200,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Center(
                                        child: Text(
                                          fetchedata["datas"][i]["blood_group"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(fetchedata["datas"][i]
                                                    ["count"]
                                                .toString() +
                                            " UNITS"),
                                      ),
                                    ]),
                                  ),
                                ),
                              )
                          ],
                        ),
            ),
            const SizedBox(
              height: 50,
            ),
            Consumer<LoadingProvider>(builder: (___, loading, ______) {
              return loading.loading
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Request for Blood:",
                          style: skfont(
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              child: Consumer<BloodGroupProvider>(
                                builder: (_, value, __) => DropdownButton(
                                    focusColor: Colors.transparent,
                                    hint: const Text("Blood Group"),
                                    value: value.bloodgroupp,
                                    items: [
                                      for (var a in [
                                        "A+",
                                        "A-",
                                        "B+",
                                        "B-",
                                        "AB+",
                                        "AB-",
                                        "O+",
                                        "O-"
                                      ])
                                        DropdownMenuItem(
                                          child: Text(a.toString()),
                                          value: a.toString(),
                                        )
                                    ],
                                    onChanged: (val) {
                                      value.changebloodgroup(val.toString());
                                    }),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<LoadingProvider>(context,
                                        listen: false)
                                    .changeisloading(true);
                                String bloodgroup =
                                    Provider.of<BloodGroupProvider>(context,
                                            listen: false)
                                        .bloodgroupp;
                                http.post(Uri.parse(baseUrl + "/admin/request"),
                                    body: {
                                      "email": email,
                                      "password": password,
                                      "bloodgroup": bloodgroup,
                                    }).then((res) {
                                  var parsedbody = jsonDecode(res.body);
                                  Provider.of<LoadingProvider>(context,
                                          listen: false)
                                      .changeisloading(false);
                                  if (parsedbody["status"] == 1) {
                                    printerror(context,
                                        title: "Request Successful",
                                        desc: parsedbody["message"]);
                                  } else {
                                    throw parsedbody["message"];
                                  }
                                }).catchError((err) {
                                  Provider.of<LoadingProvider>(context,
                                          listen: false)
                                      .changeisloading(false);
                                  printerror(context,
                                      title: "Error", desc: err);
                                });
                              },
                              child: const Text("Request"),
                            ),
                          ],
                        ),
                      ],
                    );
            })
          ],
        ),
      ),
    );
  }
}
