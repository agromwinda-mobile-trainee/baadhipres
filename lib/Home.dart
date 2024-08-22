
import 'dart:developer';

import 'package:baadhi_pres/widgets/date_and_time.dart';
import 'package:baadhi_pres/widgets/location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'Dynamic_data/users.dart';

class Home extends StatefulWidget{
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirestoreService firestoreService = FirestoreService();
  final LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 8,
        title: Image.asset("assets/images/logo.png",
        height: 160,
        width:290 ,),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,


      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(child:Card(
              color: Colors.lightBlue,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child:
              Container(
                width: 400,
                height: 200,
                padding: const EdgeInsets.all(16),
                child:
                Column(
                  children: [
                    Row(children: [
                      CircleAvatar(
                        child:
                        Image.asset("assets/images/logo.png"),
                      ),
                     const Spacer(),
                    const  Column(
                        children: [
                          Text("miche nkusu",
                            style:const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),),
                          Text("+2438000000",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                        ],
                      )

                    ],),
                 const  Divider(),
                    //date and time
                    DateTimeDisplay(),
                  const  Divider(),
                    Padding(padding: EdgeInsets.fromLTRB(0,5,0,0),
                    child: Row( children: [
                      OutlinedButton(
                          onPressed:() async {
                            print("pressed");
                    LocationData? currentLocation = await locationService.getCurrentLocation();
                    User? user = await firestoreService.getUser('exampleUserId');
                    if (currentLocation != null && user != null) {
                    if (locationService.isWithinRadius(user.positionCentrale, user.rayon, currentLocation)) {
                    // Log arrival time
                    await firestoreService.addTimesheet(Timesheet(
                    id: '',
                    userId: user.id,
                    arrivalTime: DateTime.now(),
                    ));
                    } else {
                    // Show error: out of radius
                    }
                    }
                    },
                          child: const Text("ARRIVE")
                      ),
                      const Spacer(),

                      OutlinedButton(
                          onPressed:() async {
                            LocationData? currentLocation = await locationService.getCurrentLocation();
                            User? user = await firestoreService.getUser('exampleUserId');
                            if (currentLocation != null && user != null) {
                              if (locationService.isWithinRadius(user.positionCentrale, user.rayon, currentLocation)) {
                                // Log arrival time
                                log("c bon ");
                                await firestoreService.addTimesheet(Timesheet(
                                  id: '',
                                  userId: user.id,
                                  arrivalTime: DateTime.now(),
                                ));
                              } else {
                                // Show error: out of radius
                              }
                            }
                          },
                          child: const Text("DEPART")
                      ),

                    ]

                    ),),


                  ],

                ),
              )
          ),),

      Expanded(child:Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        child:
      MapScreen()
      ,) )
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
