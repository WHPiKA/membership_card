import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:provider/provider.dart';
import 'package:membership_card/model/card_count.dart';
import 'package:membership_card/model/card_model.dart';
import 'package:membership_card/model/user_model.dart';

//import 'package:membership_card/pages/edit_card.dart';
/// This is the Card_Info Page showing one card's information with barcode.
class CardInfo2Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CardInfo2State();
  }
}

class CardInfo2State extends State<CardInfo2Page>{
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    CardInfo card = Provider.of<CardCounter>(context,listen:false).getCard(args["card"]);
    return SafeArea(
      child: Scaffold(
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
          actions: <Widget>[
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Edit",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 25.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: (){
                Navigator.of(context).pushNamed("/edit",arguments: {
                  "card": args["card"],
                });
              },
            ),
          ],
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: card.cardColor,
              ),
              height: 180.0,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[

                  Positioned(
                    left: 10.0,
                    top: 10.0,
                    child: Text(
                      "MenberShip",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 120.0,
                    right: 20.0,
                    left: 20.0,
                    child:Center(
                      child: BarCodeImage(
                        data: card.cardId,
                        codeType: BarCodeType.Code128,
                        lineWidth: 2.0,
                        barHeight: 140.0,
                        //hasText: true,
                        onError: (error){
                          print('error=$error');
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    right: 20.0,
                    left: 20.0,
                    child: Center(
                      child: Text(
                        card.cardId,
                        style: TextStyle(fontSize: 36, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}