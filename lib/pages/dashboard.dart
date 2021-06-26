import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List data = [];
  String completed = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HeltCare Doctor\'s'),
        actions: [
          IconButton(
              icon: Icon(Icons.rotate_right_rounded),
              onPressed: () => getData())
        ],
      ),
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 10,
                    color: Colors.green[200],
                    child: Column(
                      children: [
                        Text(
                          'Patients',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            //TODO: get number lists under doc key in firebase,
                            '${data.length}')
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 10,
                    color: Colors.green[200],
                    child: Column(
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            //TODO: get number lists under doc key in firebase,
                            completed)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                      //TODO: setup ui with data from RTDB
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                  child: Image.network(data[index]['img']),
                                ),
                              ),
                              Text(data[index]['name'])
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            child: Text(
                              data[index]['msg'],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundColor: data[index]['status'] == 'accepted'
                                ? Colors.green
                                : Colors.yellow,
                          )
                        ],
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Accept appointment?'),
                              content: Text(
                                  'The message will transferred to patient and appointment at ${data[index]['time']} will be fixed'),
                              actions: [
                                FlatButton(
                                    child: Text('Accept'),
                                    onPressed: () async {
                                      CollectionReference users =
                                          FirebaseFirestore.instance
                                              .collection('Dr. Bruce Banner');
                                      users
                                          .doc(data[index]['doc_id'])
                                          .update({'status': 'accepted'});
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String credit =
                                          """{"name":"${data[index]['name']}", "cost":"${num.parse(data[index]['cost'])/10}"}""";
                                      List<String> cred =
                                          prefs.getStringList('credits');
                                      if (cred == null) {
                                        cred = [];
                                      }
                                      cred.add(credit);
                                      await prefs.setStringList(
                                          'credits', cred);
                                      Navigator.pushNamed(context, '/credit');
                                    }),
                                FlatButton(
                                  child: Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  child: Text('Close appointment'),
                                  onPressed: () async {
                                    CollectionReference users =
                                        FirebaseFirestore.instance
                                            .collection('Dr. Bruce Banner');
                                    users.doc(data[index]['doc_id']).delete();
                                    Navigator.pop(context);
                                    getData();
                                  },
                                )
                              ],
                            );
                          });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
