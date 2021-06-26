import 'dart:convert';

import 'package:doctor/pages/mainscreen.dart';
import 'package:doctor/src/theme/light_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditPage extends StatefulWidget {
  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  List data = [];
  bool empty = true;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = prefs.getStringList('credits');
      data.isEmpty ? empty = true : empty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Transaction Details',
          style: GoogleFonts.merriweather(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('credits');
            },
          )
        ],
      ),
      body: empty
          ? Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 100),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/img/nodata.svg',
                    height: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, top: 25.0),
                    child: Text(
                      "No Transactions",
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  )
                ],
              ),
            )
          : Column(
              children: [
                SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, int) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                color: LightColor.grey.withOpacity(.2),
                              ),
                              BoxShadow(
                                offset: Offset(-3, 0),
                                blurRadius: 15,
                                color: LightColor.grey.withOpacity(.1),
                              )
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(json.decode(data[int])["name"],
                                  style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                  )),
                              trailing: Text(
                                  "₹ ${num.parse(json.decode(data[int])["cost"])/10}",
                                  style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
