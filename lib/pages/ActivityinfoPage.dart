import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:membership_card/network/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:membership_card/model/card_count.dart';
import 'package:membership_card/model/card_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:membership_card/network/client.dart';
import 'package:membership_card/model/user_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:membership_card/network/cookie.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:membership_card/model/activity_model.dart';
import 'package:membership_card/model/activity_count.dart';
import 'package:membership_card/model/enterprise_model.dart';
import 'package:membership_card/model/enterprise_count.dart';

class ActivityinfoPage extends StatefulWidget {
  @override
  ActivityinfoState createState() {
    return ActivityinfoState();
  }
}

class ActivityinfoState extends State<ActivityinfoPage> {
  static List _imageUrls = [
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1892437343,3193213548&fm=26&gp=0.jpg'
  ];

  Response res;
  Dio dio = initDio();
  var my=[];
  int index;
  String cardtype;
  String ename;
  var args={};
  bool ischanged=false;
  Uint8List bytes;

  @override
  void initState() {
   /* setState(() {
      args=ModalRoute.of(context).settings.arguments;
    });
*/    super.initState();
  }

  getList() {
    Iterable<Widget> listTitles;
    int i = 0;

    listTitles = my.map((dynamic item) {
      i++;
      print(item);
      return new ListTile(
        isThreeLine: true,
        dense: false,
        leading: new CircleAvatar(child: new Text(i.toString())),
        title: new Text(item.type),
        subtitle: new Text(item.description),
        trailing: new Icon(Icons.arrow_right, color: Colors.green),
        onTap: () {
          Navigator.of(context).pushNamed('/discountDetail',arguments:{
            "CardType":item.type,"Enterprise":item.enterprise,
            "Coupons":item.coupons,"Describe":item.description,
            "ExpireTime":item.expireTime,"id":item.id,
            "BackgroundBase64":item.backgroundbase64
          });
        },
      );

    });
    return listTitles.toList();
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      args=ModalRoute.of(context).settings.arguments;
    });

    if(ischanged==false) {
      print(args["EName"]);
      dioGetEnterpriseActivity(dio, args['EName']).then((res) async {
        print(res.statusCode);
        print(res.data);
        List<dynamic> js = jsonDecode(res.data);
        List<ActivityInfo> list = ActivityCounter
            .fromJson(js)
            .activityList;
        print(list);

        setState(() {
          my = list;
          ischanged=true;
        });
      });

      String back_CaptchaCode;
      String dicountCard_CaptchaCode;
      EnterpriseInfo enterprise;
      dioGetEnterpriseInfo(dio, args["EId"]).then((res) async{
        print(res.statusCode);
        print(res.data);
        if(res.statusCode==200){
          Map<String, dynamic> js = jsonDecode(res.data);
          enterprise = EnterpriseInfo.fromJSON(js);
          back_CaptchaCode = enterprise.base64;
        }

        //商家店面背景
        if (back_CaptchaCode != null) {
          print(1);
          back_CaptchaCode = back_CaptchaCode.split(',')[1];
          bytes = Base64Decoder().convert(back_CaptchaCode);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          child: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                "< Back",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: ListView(
        children:<Widget>[
          Container(
              height: MediaQuery.of(context).size.height * 0.37,
              alignment: Alignment(0.5, 0),
              child: bytes!=null? Image.memory(bytes, fit: BoxFit.contain,):Image(
                image: AssetImage("assets/backgrounds/starbucksBackground.jpg"),
              )
          ),

          SizedBox(height: 30,),
          new ListView(
            children: this.getList(),
            shrinkWrap: true, // 添加
            physics: NeverScrollableScrollPhysics(),

          )
        ],
      ),

    );
  }






/*
  var _swiper=new Swiper
    (
    itemBuilder: (BuildContext context, int index) {
      return (
          Image.network(_imageUrls[index], fit: BoxFit.fill,)
      );
    },
    itemCount:_imageUrls.length ,
    pagination: new SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: Colors.black54,
          activeColor: Colors.deepOrange,
        )),
    viewportFraction: 0.8,
    scale: 0.9,
    control: new SwiperControl(),
    scrollDirection: Axis.horizontal,
    autoplay: true,
    onTap: (index) => print('点击了第$index个'),
  );
*/


}
