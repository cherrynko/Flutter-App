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
            "صارف کا نام خالی نہیں ہو سکتا اور کم از کم ۴ حروف کا ہونا لازمی ہے";
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
          'خود سے لگاؤ',
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
                  'ہیلو! میں ایک چیٹ بٹ ہوں جو آپ کی مدد کرنے کے لئے بنایا گیا ہے تاکہ آپ کا مزاج بہتر ہو۔\n\n میں خود کو محبت کی نظریہ پر مبنی بٹ مانتا ہوں جو افراد کی روحانی حالت کو بہتر بنانے کے لئے ایک نظریہ ہے جو کئے جانے والے سالوں سے استعمال ہو رہا ہے اور تجربات کے ذریعے افراد کی حالت کو بہتر بنانے میں مدد فراہم کرتا ہے۔\n آئیے، آپ سوالات کو واضح طریقے سے جواب دیں اور مجھ سے بات چیت کریں تاکہ میں آپ کو ایک موزوں مشق کی سرگرمی دوں جو آپ کے لئے موزوں ہوسکتی ہے۔\n اگر آپ کو نظریے کے بارے میں کوئی سوال ہے تو آپ میرے چیٹ بٹ میں روشنی کے آئیکن پر کلک کرکے مجھ سے سوال کر سکتے ہیں۔',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight < 600
                        ? 13.5
                        : screenWidth < 600
                            ? 15
                            : 18,
                  ),
                  textAlign: TextAlign.center, // متن کو وسط میں الائن کریں
                  textDirection:
                      TextDirection.rtl, // متن کی سمت دائیں سے بائیں کی طرف
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 500, // مطلوبہ چوڑائی مقرر کریں
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'آپ کا مطلوبہ صارف کا نام درج کریں',
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
                    backgroundColor: Colors.blue, // Set the background color to orange
                  ),
                  child: Text(
                    'شروع کریں',
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

