import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'postModel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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

Future<Post> fetchPostman() async {
  var headers = {
    'Access-Control-Allow-Origin': '*',
    'Authorization':
        'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
    'Cookie': 'guest_id=v1%3A166335990863918549'
  };
  // var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
  // request.headers.addAll(headers);

  // http.StreamedResponse response = await request.send();

  // if (response.statusCode == 200) {
  //   final String rawResponse = await response.stream.bytesToString();
  //   final decodedResponse = jsonDecode(rawResponse);
  //   return decodedResponse;
  // }
  // else {
  //   print(response.reasonPhrase);
  //   throw Exception("nononn");
  // }
  // var response = await request.send();
  // final sendresponse = await http.Response.fromStream(response);
  // if (response.statusCode == 200) {
  //   var responseData = jsonDecode(sendresponse["Data"]);
  //   List<Post> users = [];
  //   for (var singleData in responseData) {
  //     Post user = Post(
  //         id: singleData["id"],
  //         name: singleData["name"],
  //         username: singleData["username"]);

  //     //Adding user to the list.
  //     users.add(user);
  //   }
  //   return users;
  // }
  // else {
  //   print(response.reasonPhrase);
  //   throw Exception('nonononono');
  // }

  String url = "https://api.twitter.com/2/users/23083404";
  //   // Map<String, String> headers = {
  //   //   "Content-Type": "application/json",
  //   //   "Application-Token": "1569025925387272193-eeB8czHPQ9SZAG3afgFftQg7FvnUGP"
  //   // };
  //   // String id = '1228393702244134912';

  //   //var responseJson = json.decode(response.body);
  //   // List<Post> posts = [];
  //   // for (var singleContent in responseJson) {
  //   //   Post post = Post(
  //   //     userId: singleContent["userId"],
  //   //     id: singleContent["id"],
  //   //     title: singleContent["title"],
  //   //     body: singleContent["body"]);
  //   //   posts.add(post);
  //   // }
  //       //print(_response);
  //       // return _response;
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch from twitter');
  }
  // int statusCode = response.statusCode;
  // print('This is the statuscode: $statusCode');

  //print('This is the API response: $responseJson');
}

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
  TextEditingController textEditingController = TextEditingController();
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";

  Future<void> readJson() async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization':
          'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request = http.Request(
        'GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var rawResponse = await response.stream.bytesToString();
      //var rawResponse = await http.Response.fromStream(response);
      var decodedResponse = json.decode(rawResponse);
      setState(() {
        _id = decodedResponse["data"]["id"];
        _name = decodedResponse["data"]["name"];
        _username = decodedResponse["data"]["username"];
      });
      print(decodedResponse["data"]);
    } else {
      print(response.reasonPhrase);
      throw Exception("nononn");
    }
  }
  // var _posts;
  // void initState(){
  //   super.initState();
  //   Response = fetchPostman();

  //   setState(() {
  //     _posts = Response;
  //   });
  // }
  // int _counter = 0;
  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twitter Monitor',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: textEditingController,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextButton(
            child: const Text('Query User by ID',
                style: TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 121, 177, 224))),
            onPressed: () {
              _sendDataToQueryUserbyIdScreen(context);
            },
          ),
          TextButton(
            onPressed: readJson,
            child: const Text('Present Results',
                style: TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 121, 177, 224))),
          ),

          Text(
            'id: $_id',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'name: $_name',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'username: $_username',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ]),
      ),
    );
  }

  void _sendDataToQueryUserbyIdScreen(BuildContext context) {
    String textToSend = textEditingController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueryUserbyIdScreen(
            text: textToSend,
          ),
        ));
  }
}

class QueryUserbyIdScreen extends StatelessWidget {
  final String text;

  // receive data from the FirstScreen as a parameter
  const QueryUserbyIdScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second screen',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
  