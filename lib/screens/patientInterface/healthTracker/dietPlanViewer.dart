import 'package:flutter/material.dart';
import '../../../utilities/gpt4.dart';

class DietPlanViewer extends StatefulWidget {
  const DietPlanViewer({super.key, required this.prompt,required this.maxWaterLimit,required this.maxProteinLimit});
  final String prompt;
  final double maxProteinLimit;
  final double maxWaterLimit;
  @override
  State<DietPlanViewer> createState() => _dietPlanViewerState();
}

class _dietPlanViewerState extends State<DietPlanViewer> {
  bool isLoading = false; // Flag to control the visibility of the spinner

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Suggestion For Today'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding( // Add padding around the body
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Diet Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Make the title bigger and bolder
            ),
            SizedBox(height: 16.0), // Add some space below the title
            Text(widget.prompt),
            SizedBox(height: 16.0), // Add some space above the button
            isLoading // Show a spinner when isLoading is true
                ? CircularProgressIndicator()
                : TextButton(
                onPressed:  () async {
                  setState(() {
                    isLoading = true; // Show the spinner
                  });
                  String newPrompt = await generateDietPlan('kidney disease',[], widget.maxWaterLimit , widget.maxProteinLimit);
                  setState(() {
                    isLoading = false; // Hide the spinner
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  DietPlanViewer(prompt: newPrompt, maxWaterLimit: widget.maxWaterLimit,maxProteinLimit: widget.maxProteinLimit)));
                },
                child: Text('Regenerate')
            )
          ],
        ),
      ),
    );
  }
}