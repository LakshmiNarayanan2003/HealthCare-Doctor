import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doctor/src/model/dactor_model.dart';
import 'package:doctor/src/theme/extention.dart';
import 'package:doctor/src/theme/light_color.dart';
import 'package:doctor/src/theme/text_styles.dart';
import 'package:doctor/src/theme/theme.dart';
import 'package:doctor/src/widgets/rating_start.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.model}) : super(key: key);
  final DoctorModel model;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DoctorModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
        IconButton(
            icon: Icon(
              model.isfavourite ? Icons.favorite : Icons.favorite_border,
              color: model.isfavourite ? Colors.red : LightColor.grey,
            ),
            onPressed: () {
              setState(() {
                model.isfavourite = !model.isfavourite;
              });
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Image.asset(model.image),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                return Container(
                  height: AppTheme.fullHeight(context) * .5,
                  padding: EdgeInsets.only(
                      left: 19,
                      right: 19,
                      top: 16), //symmetric(horizontal: 19, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(model.name,
                                  style: GoogleFonts.marmelad(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check_circle,
                                  size: 20,
                                  color: Theme.of(context).primaryColor),
                              Spacer(),
                            ],
                          ),
                          subtitle: Text(
                            model.type,
                            style: TextStyles.bodySm.subTitleColor.bold,
                          ),
                        ),
                        Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RatingStar(
                              rating: model.rating,
                            )
                          ],
                        ),
                        Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Text("About", style: titleStyle).vP16,
                        Text(
                          model.description,
                          style: TextStyles.body.subTitleColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: LightColor.grey.withAlpha(150)),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ).ripple(
                                () {},
                                borderRadius: BorderRadius.circular(10),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: LightColor.grey.withAlpha(150)),
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Colors.white,
                                ),
                              ).ripple(
                                () {},
                                borderRadius: BorderRadius.circular(10),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {},
                                child: Text(
                                  "Make an appointment",
                                  style: TextStyles.titleNormal.white,
                                ).p(10),
                              ),
                            ],
                          ).vP16,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
    );
  }
}
