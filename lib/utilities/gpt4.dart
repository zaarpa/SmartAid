import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gptkey.dart' as Env;
String openaiKey = Env.api_key;

Future<String> promptTesting(var disease, var existingConditions ,int water_max,int protein_max ) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $openaiKey',
  };

  String context = "You are a nutritionist.A client has asked you for a diet plan.Please only return a list of foods along with the amount and when they will be taken.Also add the protein value for each food and total protein count.Only return what is asked nothing more";
  context+="The patient has been diagnosed with $disease";
  context+="These are the patient’s pre existing conditions : $existingConditions";
  context+="Patient can take maximum $protein_max gm of protein per day.Make sure they don't take more than $protein_max gm of protein in total.";
  context+="Patient can drink maximum $water_max ml of water.Make sure they don't drink more than $water_max ml of water in total.";

  var body = jsonEncode({
    "model": "gpt-4",
    "messages": [
      {
        "role": "user",
        "content": context
      }
    ],
    "temperature": 1,
    "top_p": 1,
    "n": 1,
    "stream": false,
    "max_tokens": 350,
    "presence_penalty": 0,
    "frequency_penalty": 0
  });

  var response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data['choices'][0]['message']['content']);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to make POST request');
  }
}