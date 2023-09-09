import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sat_project/chat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConversationPage(),
    );
  }
}

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _usernameController = TextEditingController();
  String responseText = "";
  String errorMessage = "";

  Future<void> startConversation() async {
    final username = _usernameController.text;

    if (username.isEmpty || username.length < 4) {
      setState(() {
        errorMessage =
            "نام کاربری نمی‌تواند خالی باشد و باید حداقل ۴ کاراکتر داشته باشد";
      });
      return;
    }

    // If the input is valid, reset the error message
    setState(() {
      errorMessage = "";
    });

    final Uri uri = Uri.parse('http://127.0.0.1:8000/api/');

    try {
      final response = await http.post(uri, body: {"username": username});
      print(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatApp(username: username),
        ),
      );
    } catch (error) {
      print('Error making POST request: $error');
    }
    // Replace with your backend API endpoint
    // final url = 'YOUR_BACKEND_API_ENDPOINT';

    // final response = await http.post(
    //   Uri.parse(url),
    //   body: jsonEncode({'username': username}),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    // );

    // if (response.statusCode == 200) {
    //   final jsonResponse = jsonDecode(response.body);
    //   final responseData = jsonResponse['data'];

    //   // Handle the response data as needed
    //   setState(() {
    //     responseText = responseData;
    //   });

    //   // Navigate to another page here, for example:
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => ChatApp(),
    //     ),
    //   );
    // } else {
    //   // Handle error responses
    //   setState(() {
    //     responseText = "Error: ${response.statusCode}";
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Chat App'),
        // ),
        body: Column(children: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        color: Colors.blue,
        child: Text(
          'بات دلبستگی به خود',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 500, // Set the desired width
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'نام کاربری مد نظرت رو وارد کن',
                      hintTextDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  onPressed: startConversation,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Set the background color to orange
                  ),
                  child: Text(
                    'شروع کنیم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16), // Add spacing

              // Display the error message
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      )
    ]));
  }
}
