import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/authentication/createAcc.dart';
import 'package:doctor/pages/profile.dart';
import 'package:doctor/src/model/dactor_model.dart';
import 'package:doctor/src/model/data.dart';
import 'package:doctor/src/theme/extention.dart';
import 'package:doctor/src/theme/light_color.dart';
import 'package:doctor/src/theme/text_styles.dart';
import 'package:doctor/src/theme/theme.dart';
import 'package:doctor/widgets/UserInfo.dart';
import 'package:doctor/widgets/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username;
  String imgUrl;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List data = [];
  String completed = '';
  String customBio = "Staying doctory!";
  final fieldText = TextEditingController();
  List<DoctorModel> doctorDataList;
  PageController _pageController;
  int _page = 0;
  @override
  void initState() {
    getUserInfo();
    getData();
    _pageController = PageController(initialPage: 0);
    doctorDataList = doctorMapList.map((x) => DoctorModel.fromJson(x)).toList();

    super.initState();
  }

  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  getData() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('Dr. Bruce Banner');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      data = allData;
    });
    print('--------------------alldata');
    print(allData);
    int num = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i]['status'] == 'accepted') {
        num++;
      }
    }
    setState(() {
      completed = num.toString();
    });
  }

  getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.get('username');
    imgUrl = preferences.get('imgUrl');
    if (preferences.containsKey('bio')) {
      customBio = preferences.get('bio');
    }
    setState(() {
      username = preferences.get('username');
      imgUrl = preferences.get('imgUrl');
      UserInformation().imgUrl = imgUrl;
      UserInformation().username = username;
    });

    UserInformation().imgUrl = imgUrl;
    UserInformation().username = username;
    if (username == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CreateAccount();
      }));
    }
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Icon(
        Icons.short_text,
        size: 30,
        color: Colors.black,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
              radius: 25,
              backgroundImage: imgUrl.toString().contains('com.rachinc.respic')
                  ? FileImage(
                      File(imgUrl.toString()),
                    )
                  : CachedNetworkImageProvider(
                      imgUrl == null ? username.toString()[0] : imgUrl),
              child: imgUrl == null ? Text("${username.toString()[0]}") : null),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello Doctor,", style: GoogleFonts.ubuntu(color: Colors.grey)),
        Text(username == null ? "" : username,
            style: GoogleFonts.merriweather(fontSize: 30)),
      ],
    ).p16;
  }

  Widget _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: _categoryCard(
                    "Patients", '${data.length}', //TODO add the number
                    color: LightColor.skyBlue,
                    lightColor: LightColor.lightBlue),
              ),
              _categoryCard("Treated", completed, //TODO add the number
                  color: LightColor.green,
                  lightColor: LightColor.lightGreen),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title,
                            style: GoogleFonts.nunito(
                                fontSize: 15, fontWeight: FontWeight.bold))
                        .hP8,
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        subtitle,
                        style: GoogleFonts.merriweather(
                            fontSize: 25, color: Colors.white),
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget _doctorsList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "Patients",
              style: GoogleFonts.merriweather(fontSize: 20),
            ),
          ),
          getdoctorWidgetList()
        ],
      ),
    );
  }

  Widget getdoctorWidgetList() {
    return Column(children: [
      _doctorTile(),
    ]);
  }

  Widget _doctorTile() {
    return ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // DateTime dateTime = data[index]['time'].toDate();
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: randomColor(),
                        ),
                        child: Image.network(
                          data[index]['img'] == null
                              ? data[index]['msg'][0]
                              : data[index]['img'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(data[index]['msg'],
                        style: GoogleFonts.marmelad(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[index]['name'],
                        style: TextStyles.bodySm.subTitleColor.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 70),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹",
                          style: GoogleFonts.merriweather(color: Colors.green),
                        ),
                        Text(
                          data[index]['cost'],
                          style: GoogleFonts.merriweather(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 70),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 12,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 2.0),
                          child: Text(
                            "${DateTime.parse(data[index]['time']).year}/${DateTime.parse(data[index]['time']).month}/${DateTime.parse(data[index]['time']).day}, ${DateTime.parse(data[index]['time']).hour}:${DateTime.parse(data[index]['time']).minute} ${DateTime.parse(data[index]['time']).timeZoneName}",
                            style:
                                GoogleFonts.merriweather(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ).ripple(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Accept appointment?',
                        style: GoogleFonts.merriweather(
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'The approval will be sent to patient and appointment at ${DateTime.parse(data[index]['time']).year}/${DateTime.parse(data[index]['time']).month}/${DateTime.parse(data[index]['time']).day}, ${DateTime.parse(data[index]['time']).hour}:${DateTime.parse(data[index]['time']).minute} ${DateTime.parse(data[index]['time']).timeZoneName} will be fixed.',
                        style: GoogleFonts.raleway(),
                      ),
                      actions: [
                        FlatButton(
                            child: Text('Accept'),
                            onPressed: () async {
                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('Dr. Bruce Banner');
                              users
                                  .doc(data[index]['doc_id'])
                                  .update({'status': 'accepted'});
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String credit =
                                  """{"name":"${data[index]['name']}", "cost":"${data[index]['cost']}"}""";
                              List<String> cred =
                                  prefs.getStringList('credits');
                              if (cred == null) {
                                cred = [];
                              }
                              cred.add(credit);
                              await prefs.setStringList('credits', cred);
                              Navigator.pushNamed(context, '/credit');
                            }),
                        FlatButton(
                          child: Text('Deny'),
                          onPressed: () async {
                            CollectionReference users = FirebaseFirestore
                                .instance
                                .collection('Dr. Bruce Banner');
                            users.doc(data[index]['doc_id']).delete();
                            Navigator.pop(context);
                            getData();
                          },
                        ),
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  });
            }, borderRadius: BorderRadius.all(Radius.circular(20))),
          );
        });
  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _header(),
                _category(),
              ],
            ),
          ),
          _doctorsList()
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.lightBlue[300],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 250.0),
                    child: Icon(
                      Icons.format_quote_outlined,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: customBio == ""
                        ? Text("Staying doctory!",
                            style: GoogleFonts.quicksand(
                                fontSize: 25, fontWeight: FontWeight.w600))
                        : Text("$customBio",
                            style: GoogleFonts.quicksand(
                                fontSize: 25, fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 250.0),
                    child: Icon(
                      Icons.format_quote_outlined,
                      size: 20,
                    ),
                  ),
                  Container(
                    color: Colors.lightBlue[300],
                    padding: EdgeInsets.only(top: 10, bottom: 15, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditProfile();
                            }));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 25,
                                  backgroundImage: imgUrl
                                          .toString()
                                          .contains('com.rachinc.respic')
                                      ? FileImage(
                                          File(imgUrl.toString()),
                                        )
                                      : CachedNetworkImageProvider(
                                          imgUrl == null
                                              ? username.toString()[0]
                                              : imgUrl),
                                  child: imgUrl == null
                                      ? Text("${username.toString()[0]}")
                                      : null),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 200,
                                      child: Text('${username}',
                                          style: GoogleFonts.merriweather(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                height: customBio.length < 60
                    ? MediaQuery.of(context).size.height * .70
                    : MediaQuery.of(context).size.height * .59,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditProfile();
                              }));
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                CircleAvatar(
                                    radius: 17,
                                    backgroundImage: imgUrl
                                            .toString()
                                            .contains('com.rachinc.respic')
                                        ? FileImage(
                                            File(imgUrl.toString()),
                                          )
                                        : CachedNetworkImageProvider(
                                            imgUrl == null
                                                ? username.toString()[0]
                                                : imgUrl),
                                    child: imgUrl == null
                                        ? Text("${username.toString()[0]}")
                                        : null),
                                SizedBox(
                                  width: 50,
                                ),
                                Text('Profile',
                                    style: GoogleFonts.ubuntu(fontSize: 20))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Utils.openEmail(
                                toEmail: 'contact@respic.ml',
                                subject: 'Subject',
                                body: 'Enter your requests, queries here!\n',
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.contact_mail_outlined,
                                    size: 28,
                                    color: Colors.blueGrey.shade600,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text('Contact us',
                                    style: GoogleFonts.ubuntu(fontSize: 20)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('lauch link');
                              Utils.openLink(
                                  url:
                                      'https://play.google.com/store/apps/details?id=com.rachinc.respic');
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.star_rate_rounded,
                                    size: 32,
                                    color: const Color(0xffFFD700),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text('Rate the app',
                                    style: GoogleFonts.ubuntu(fontSize: 20)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: customBio.length < 60
                          ? const EdgeInsets.only(
                              top: 210.0, left: 50, right: 50)
                          : const EdgeInsets.only(
                              top: 210.0, left: 50, right: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              IconButton(
                                  icon: Icon(
                                    FontAwesome.globe,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Utils.openLink(url: 'https://respic.ml');
                                  }),
                              IconButton(
                                  icon: Icon(
                                    FontAwesome.instagram,
                                    color: Colors.pink,
                                  ),
                                  onPressed: () {
                                    Utils.openLink(
                                        url:
                                            'https://instagram.com/respic.ml?igshid=ae7jq1hbzz35');
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {
                                    Utils.openEmail(
                                      toEmail: 'contact@respic.ml',
                                      subject: 'Subject',
                                      body:
                                          'Enter your requests, queries here!\n',
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                //TODO: privacy policy

                                if (await canLaunch(
                                    'https://respic.ml/#/privacy-policy')) {
                                  launch(
                                    'https://respic.ml/#/privacy-policy', //change it to diff url
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Oops! Something seems wrong",
                                      textColor: Colors.white,
                                      backgroundColor: Colors.black);
                                }
                              },
                              child: Text(
                                'Privacy Policy',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (await canLaunch(
                                    'https://respic.ml/#/privacy-policy')) {
                                  launch(
                                    'https://respic.ml/#/terms-and-conditions',
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Oops! Something seems wrong",
                                      textColor: Colors.white,
                                      backgroundColor: Colors.black);
                                }
                              },
                              child: Text(
                                'Terms and Conditions',
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
