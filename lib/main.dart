import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:developer';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'postModel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_login/twitter_login.dart';
import 'firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// void getapi() async {
//   var headers = {
//     'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
//     'Cookie': 'guest_id=v1%3A166335990863918549'
//   };
//   var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/34/following'));

//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   }
//   else {
//     print(response.reasonPhrase);
//   }

// }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EC463 Mini Project',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black87,
        fontFamily: 'JetBrainsMono',
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 72.0, fontWeight: FontWeight.w700, color: Colors.white),
          headline2: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.w700, color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 14.0,
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        )),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'JetBrainsMono',
              fontSize: 24.0,
              fontWeight: FontWeight.w700),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      home: const HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _c;
  var _text = "initial";

  
  @override
  void initState() {
    _c = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'twitter',
      (int uid) {
        IFrameElement _iFrame = IFrameElement()..src = "web/twitter.html";
        _iFrame.style.border = "none";
        return _iFrame;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Twitter Monitor',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      backgroundColor: Colors.black87,
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  child: TextField(
                controller: _c,
                decoration: const InputDecoration(hintText: "Search by ID"),
                style: Theme.of(context).textTheme.bodyText1,
              )),
              Container(
                  child: const SizedBox(
                height: 20.0,
              )),
              Container(
                  child: TextButton(
                child: const Text('Query User by ID',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  setState(() {
                    _text = _c.text;
                  });
                  // Navigator.pop(context);
                  _sendDataToQueryUserbyIdScreen(context, _text);
                },
              )),
              Container(
                  child: const SizedBox(
                height: 20.0,
              )),
              Container(
                  child: TextButton(
                child: const Text('Check User/Bot Function',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  setState(() {
                    _text = _c.text;
                  });
                  // Navigator.pop(context);
                  _sendDataToCheckBotScreen(context, _text);
                },
              )),
              Container(
                  child: const SizedBox(
                height: 20.0,
              )),
              Container(
                  child: TextButton(
                child: const Text('Sentiment Analysis',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  setState(() {
                    _text = _c.text;
                  });
                  // Navigator.pop(context);
                  _sendDataToSentimentAnalysisScreen(context, _text);
                },
              )),
              Container(
                  child: const SizedBox(
                height: 20.0,
              )),
              Container(
                  child: TextButton(
                // child: const Text('Present Results',
                //     style: TextStyle(
                //         fontSize: 14.0,
                //         color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () async {
                  const url = 'https://twitter.com/i/flow/login';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('Open Twitter URL',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
              )),
              // Html(data: _htmlContent, style: {
              //   'h1': Style(color: Colors.red),
              //   'p': Style(color: Colors.black87, fontSize: FontSize.medium),
              //   'ul': Style(margin: const EdgeInsets.symmetric(vertical: 20)),
              //   'a': Style(color: Colors.black87, fontSize: FontSize.medium),
              // }),
              Container(
                height: 920,
                width: 500,
                child: const HtmlElementView(
                  viewType: "twitter",
                ),
              ),
              Container(
                  child: const SizedBox(
                height: 20.0,
              )),
            ]),
          )),
    );
  }
}

void _sendDataToQueryUserbyIdScreen(BuildContext context, String text) {
  String textToSend = text;
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueryUserbyIdScreen(
          text: textToSend,
        ),
      ));
}

void _sendDataToCheckBotScreen(BuildContext context, String text) {
  String textToSend = text;
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckBotScreen(
          text: textToSend,
        ),
      ));
}

void _sendDataToSentimentAnalysisScreen(BuildContext context, String text) {
  String textToSend = text;
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SentimentAnalysisScreen(
          text: textToSend,
        ),
      ));
}

class SentimentAnalysisScreen extends StatefulWidget {
  final String text;

  // receive data from the FirstScreen as a parameter
  const SentimentAnalysisScreen({super.key, required this.text});
  @override
  _SentimentAnalysisScreenState createState() {
    return _SentimentAnalysisScreenState();
  }
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  TextEditingController _keyword = TextEditingController();
  TextEditingController _numOfTweets = TextEditingController();
  var Data;
  String url = '';
  String total = '';
  String pos = '';
  String neg = '';
  String neu = '';
  dynamic _error_flag;
  dynamic _error_visibility = false;
  Future ConvertUrl(String key, String num) async {
    var request = http.Request('PUT', Uri.parse('http://127.0.0.1:5000/sentimentpost'));
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Headers":
          "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
      'Referrer-Policy': 'no-referrer-when-downgrade',
    };
    var body = jsonEncode("{'Key': '$key', 'Num': '$num'}");
    // http.Response responseP = await http.put(
    //   Uri.parse('http://127.0.0.1:5000/sentimentpost'),
    //   headers: headers,
    //   body: body,
    // );
    request.headers.addAll(headers);
    request.body = body;
    http.StreamedResponse responseP= await request.send();
    var rawResponseP = await http.Response.fromStream(responseP);
    print(rawResponseP.body);
    if (responseP.statusCode == 200) { // Status check for put request
      
      var request = http.Request('GET', Uri.parse('http://127.0.0.1:5000/sentiment'));
      var headers = {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Headers":
          "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
        'Referrer-Policy': 'no-referrer-when-downgrade',
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200){
        var rawResponse = await http.Response.fromStream(response);
        if (rawResponse.body[0] == 0){
          return "e";
        }
        return rawResponse.body;
      } else {
        return "e"; //"User Not found, cannot perform bot check.";
      }
      
    } else {
      return "e"; //"PUT request was unsuccessful, try again.";
    }
    
  }
  Future<void> SentimentAnalysis(String key, String num) async {
    var inputUrl = 'http://127.0.0.1:5000/sentiment';
    Data = await ConvertUrl(key,num);
    if(Data != "e") {
      setState(() {
        total = Data[0].toString();
        pos = Data[1].toString();
        neg = Data[2].toString();
        neu = Data[3].toString();
        url = inputUrl;
        _error_flag = '';
        _error_visibility = false;
    });
    } else {
      setState(() {
        total = '';
        pos = '';
        neg = '';
        neu = '';
        url = inputUrl;
        _error_flag = "User/hastag Not found, cannot perform sentiment analysis.";
        _error_visibility = true;
      });
    }
    Data = json.decode(Data);
    setState(() {
      total = Data[0].toString();
      pos = Data[1].toString();
      neg = Data[2].toString();
      neu = Data[3].toString();
      url = inputUrl;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sentiment Analysis Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _keyword,
              decoration: const InputDecoration(
                hintText: "Input a hashtag or keyword to perform sentiment analysis",
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _numOfTweets,
              decoration: const InputDecoration(
                hintText: "Input the number of tweets you want to analyze",
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () async {
                await SentimentAnalysis(_keyword.text, _numOfTweets.text);
              },
              child: const Text('Click to perform sentiment analysis',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 121, 177, 224))),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Total number of Tweets: $total\n\nPositive Tweets: $pos\n\nNegative Tweets: $neg\n\nNeutrual Tweets: $neu\n\nQueried url: $url',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Visibility(
              visible: _error_visibility,
              child: Text(
                'Error Message: $_error_flag',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class CheckBotScreen extends StatefulWidget {
  final String text;

  // receive data from the FirstScreen as a parameter
  const CheckBotScreen({super.key, required this.text});
  @override
  _CheckBotScreenState createState() {
    return _CheckBotScreenState();
  }
}

class _CheckBotScreenState extends State<CheckBotScreen> {
  TextEditingController _c = TextEditingController();
  var Data;
  String url = '';
  String _text = '';
  String isbot = '';
  dynamic _error_flag;
  dynamic _error_visibility = false;
  Future ConvertUrl(String userid) async {
    var request = http.Request('PUT', Uri.parse('http://127.0.0.1:5000/botometerpost'));
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Headers":
          "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
      'Referrer-Policy': 'no-referrer-when-downgrade',
    };
    var body = '{"userId" : $userid}';
    body = json.encode(body);
    request.headers.addAll(headers);
    request.body = body;
    http.StreamedResponse responseP= await request.send();
    if (responseP.statusCode == 200) { // Status check for put request
      var rawResponseP = await http.Response.fromStream(responseP);
      print(rawResponseP.body);
      var request = http.Request('GET', Uri.parse('http://127.0.0.1:5000/botometer'));
      var headers = {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Headers":
          "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
        'Referrer-Policy': 'no-referrer-when-downgrade',
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200){
        var rawResponse = await http.Response.fromStream(response);
        return rawResponse.body;
      } else {
        return "e"; //"User Not found, cannot perform bot check.";
      }
      
    } else {
      return "e"; //"PUT request was unsuccessful, try again.";
    }
  }

  Future<void> CheckBot(String inputText) async {
    var inputUrl = 'http://127.0.0.1:5000/botometer/';
    Data = await ConvertUrl(inputText);
    if(Data != "e") {
      setState(() {
      _text = Data;
      url = inputUrl;
      if (double.parse(_text) <= 2){
        isbot = 'This account is very likely to be a human. (0<score<2)';
      } else if (double.parse(_text) > 2 && double.parse(_text) < 3){
        isbot = 'Botometer is not very certain about this user. (2<score<3)';
      } else {
        isbot = 'This account is very like to be a robot. (3<user<5)';
      }
      _error_flag = '';
      _error_visibility = false;
    });
    } else {
      setState(() {
        _text = '';
        url = '';
        isbot = '';
        _error_flag = "User Not found, cannot perform bot check.";
        _error_visibility = true;
      });
    }
    
  }

  @override
  void initState() {
    CheckBot(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bot Account Checker Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                hintText: "Input id to check if user is real",
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () async {
                await CheckBot(_c.text);
              },
              child: const Text('Click to check bot user',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 121, 177, 224))),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Bot Score: $_text\n\nBot Result: $isbot\n\nQueried URL: $url',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Visibility(
              visible: _error_visibility,
              child: Text(
                'Error Message: $_error_flag',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QueryUserbyIdScreen extends StatefulWidget {
  final String text;

  // receive data from the FirstScreen as a parameter
  const QueryUserbyIdScreen({super.key, required this.text});
  @override
  _QueryUserbyIdScreenState createState() {
    return _QueryUserbyIdScreenState();
  }
}

class _QueryUserbyIdScreenState extends State<QueryUserbyIdScreen> {
  TextEditingController _c = TextEditingController();
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";
  dynamic _error_flag;
  dynamic _error_visibility = false;

  Future<void> ConvertUrl(String text) async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization':
          'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request =
        http.Request('GET', Uri.parse('https://api.twitter.com/2/users/$text'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var rawResponse = await response.stream.bytesToString();
      //var rawResponse = await http.Response.fromStream(response);
      var decodedResponse = json.decode(rawResponse);
      try {
        setState(() {
          _id = decodedResponse["data"]["id"];
          _name = decodedResponse["data"]["name"];
          _username = decodedResponse["data"]["username"];
          _error_flag = "";
          _error_visibility = false;
        });
      } catch (error) {
        setState(() {
          _id = "";
          _name = "";
          _username = "";
          _error_flag = decodedResponse["errors"][0]["detail"];
          _error_visibility = true;
        });
      }

      // if (error_visibility){
      //   setState(() {
      //     _error_flag = "Cannot find User with Userid $text.";
      //     error_visibility = true;
      //   });
      // }
    } else {
      throw Exception("Check user by Id request failed.");
    }
  }

  @override
  void initState() {
    ConvertUrl(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query User by id Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                hintText: "Input id to check if user is real",
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () async {
                await ConvertUrl(_c.text);
              },
              child: const Text('Click to check another user by Id',
                textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 121, 177, 224))
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Id: $_id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Name: $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Username: $_username',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 10.0,
            ),
            Visibility(
              visible: _error_visibility,
              child: Text(
                'Error Message: $_error_flag',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
