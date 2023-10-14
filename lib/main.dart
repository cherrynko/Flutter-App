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

    final Uri uri = Uri.parse('http://104.234.1.218:8000/api/');

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                padding: EdgeInsets.fromLTRB(screenWidth < 600 ? 30 : 120, 20,
                    screenWidth < 600 ? 30 : 120, screenWidth < 600 ? 30 : 50),
                child: Text(
                  'سلام! من یه چت بات هستم که قراره بهت کمک کنم تا حالت بهتر شه.\n\n من بر اساس نظریه‌ی دلبستگی به خود کار میکنم که یه نظریه برای بهتر شدن حالت روحی افراد هست که چندین ساله داره روش کار میشه و طی تمرین‌هایی به بهتر شدن حال افراد کمک میکنه.\n در ادامه سعی کن به سوالام به صورت شفاف جواب بدی و میتونی باهام صحبت کنی تا به تمرینی که میتونه برات مناسب باشه برسیم.\n هرجایی هم هر سوالی در مورد نظریه داشتی میتونی روی آیکون لامپ توی چت‌بات کلیک کنی و ازم سوالت رو بپرسی.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight < 600
                        ? 13.5
                        : screenWidth < 600
                            ? 15
                            : 18,
                  ),
                  textAlign: TextAlign.center, // Center-align the text
                  textDirection:
                      TextDirection.rtl, // Right-to-left text direction
                ),
              ),
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
                width: screenWidth < 600 ? 150 : 200,
                height: screenWidth < 600 ? 35 : 45,
                child: ElevatedButton(
                  onPressed: startConversation,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Set the background color to orange
                  ),
                  child: Text(
                    'شروع کنیم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth < 600 ? 15 : 18,
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
                  fontSize: screenWidth < 600 ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      )
    ]));
  }
}

