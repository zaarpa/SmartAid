import 'package:flutter/material.dart';
import 'package:design_project_1/services/trackerServices/healthTrackerService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'kidneyDiseaseTracker/kidneyTracker.dart';
class WaterTrackerPage extends StatefulWidget {
  @override
  _WaterTrackerPageState createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  int totalGlasses = 0;
  int totalMl = 0;
  int mlPerGlass = 250;
  double maxWater = 0;

  Future? loadwater;

  @override
  void initState() {
    super.initState();
    loadwater = loadWaterData();
  }

  Future<void> loadWaterData() async {
    try{
      int waterData = await healthTrackerService(uid: FirebaseAuth.instance.currentUser!.uid).getWaterData();
      setState(() {
        totalMl = waterData;
        totalGlasses = (totalMl / mlPerGlass).round();
      });
      double maxWaterLimit = await healthTrackerService(uid: FirebaseAuth.instance.currentUser!.uid).getMaxWaterLimit();
      setState(() {
        maxWater = maxWaterLimit;
      });
      // if (totalMl > maxWaterLimit) {
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text('Warning'),
      //         content: Text('You have exceeded your daily water limit'),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: Text('OK'),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // }
    }
    catch(e){
      print(e);
    }
  }

  void addGlass() async {
    if(totalMl + mlPerGlass > maxWater){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('You have exceeded your daily water limit'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
    setState(() {
      totalGlasses++;
      totalMl += mlPerGlass;
    });
    await healthTrackerService(uid: FirebaseAuth.instance.currentUser!.uid)
        .updateWaterData(totalMl);
  }

  void removeGlass() async {
    if (totalGlasses > 0) {
      setState(() {
        totalGlasses--;
        totalMl -= mlPerGlass;
      });
      await healthTrackerService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateWaterData(totalMl);

    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: loadwater, builder: (context,snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return const CircularProgressIndicator();
      }
      else if(snapshot.hasError){
        return Text('Error: ${snapshot.error}');
      }
      else{
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade900,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KidneyTracker() ));
              },
            ),
            title: Text('Water Tracker'),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background image with blur
              Image.asset(
                'assets/images/waterBackground.jpg',
                fit: BoxFit.cover,
              ),
              // Blurred overlay

              Container(
                color: Colors.white.withOpacity(0.5),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Max Water Limit: ${maxWater.toStringAsFixed(2)} ml',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Track today's water intake", style: TextStyle(fontSize: 20,color: Colors.grey.shade800)),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Text(
                        'Note: 1 glass = 250 ml',
                        style: TextStyle(fontSize: 30, color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 20), // Added padding
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Total Glasses Consumed:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 10), // Added padding
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              key: ValueKey<int>(totalGlasses),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade600,
                              ),
                              child: Center(
                                child: Text(
                                  totalGlasses.toString(),
                                  style: TextStyle(fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Added padding
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: removeGlass,
                          child: Icon(Icons.remove),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Set background color to red
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: addGlass,
                          child: Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Set background color to green
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(height: 20),
                    ), // Added top margin
                    Text(
                      'Total Water Consumed: $totalMl ml',
                      style: TextStyle(fontSize: 25,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });

  }
}

