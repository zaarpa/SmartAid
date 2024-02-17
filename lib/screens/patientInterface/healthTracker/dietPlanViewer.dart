import 'package:flutter/material.dart';
class DietPlanViewer extends StatefulWidget {
  const DietPlanViewer({super.key, required this.prompt});
  final String prompt;
  @override
  State<DietPlanViewer> createState() => _dietPlanViewerState();
}

class _dietPlanViewerState extends State<DietPlanViewer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plan'),
      ),
      body: Container(
        child: Column(
          children: [
            Text('Diet Plan'),
            Text(widget.prompt),
          ],
        ),
      ),
    );
  }
}
