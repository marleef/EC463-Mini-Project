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
  late TextEditingController _c;
  var _text = "initial";

  Future login() async {
    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: 'DVpGuGbEsvWptOobV8jofoh5W',

      /// Consumer API Secret keys
      apiSecretKey: '9Xf6rStivVmhnoiX39gUwTzu82kmcNZWutKvtKSKReMNwdvy7f',

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: 'http://127.0.0.1:5000/login',
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        print('====== Login success ======');
        print(authResult.authToken);
        print(authResult.authTokenSecret);
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
      case null:
        // error
        print('====== Login error ======');
        break;
    }
  }
  // TextEditingController textEditingController = TextEditingController();
  // dynamic _id = "";
  // dynamic _name = "";
  // dynamic _username = "";

  // Future<void> readJson() async {
  //   var headers = {
  //     'Access-Control-Allow-Origin': '*',
  //     'Authorization':
  //         'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
  //     'Cookie': 'guest_id=v1%3A166335990863918549'
  //   };
  //   var request = http.Request(
  //       'GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var rawResponse = await response.stream.bytesToString();
  //     //var rawResponse = await http.Response.fromStream(response);
  //     var decodedResponse = json.decode(rawResponse);
  //     setState(() {
  //       _id = decodedResponse["data"]["id"];
  //       _name = decodedResponse["data"]["name"];
  //       _username = decodedResponse["data"]["username"];
  //     });
  //     print(decodedResponse["data"]);
  //   } else {
  //     print(response.reasonPhrase);
  //     throw Exception("nononn");
  //   }
  // }
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
  void initState() {
    _c = TextEditingController();
    super.initState();
  }

  // final _htmlContent = """
  //   <div>
  //   <h1>This is a title</h1>
  //   <p>This is a <strong>paragraph</strong>.</p>
  //   <p>I like <i>dogs</i></p>
  //   <p>Red text</p>
  //   <a class="twitter-timeline" href="https://twitter.com/celtics?ref_src=twsrc%5Etfw">Tweets by celtics</a>
  //   <script async src="https://platform.twitter.com/widgets.js" charset="utf-8">tweet script</script>
  //   </div>
  // """;

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
                child: Text('Login With Twitter',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () async {
                  await login();
                },
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
              // Text(
              //   'id: $_id',
              //   textAlign: TextAlign.center,
              //   overflow: TextOverflow.ellipsis,
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              // Text(
              //   'name: $_name',
              //   textAlign: TextAlign.center,
              //   overflow: TextOverflow.ellipsis,
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              // Text(
              //   'username: $_username',
              //   textAlign: TextAlign.center,
              //   overflow: TextOverflow.ellipsis,
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              // Container(
              //   height: 500,
              //   width: 500,
              //   //padding: const EdgeInsets.all(100.0),
              //   child: const HtmlElementView(
              //     viewType: "twitter",
              //   ),
              // ),
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
  Future ConvertUrl(String urL) async {
    var request = http.Request('GET', Uri.parse(urL));
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Headers":
          "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
      'Referrer-Policy': 'no-referrer-when-downgrade',
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var rawResponse = await http.Response.fromStream(response);
      return rawResponse.body;
    } else {
      return "User Not found, cannot perform bot check.";
    }
  }

  Future<void> CheckBot(String inputText) async {
    var inputUrl = 'http://127.0.0.1:5000/$inputText';
    Data = await ConvertUrl(inputUrl);
    setState(() {
      _text = Data;
      url = inputUrl;
    });
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
              height: 10.0,
            ),
            Text(
              'Bot score: $_text\n\nQueried url: $url',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
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

  Future<void> readJson(String text) async {
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
    readJson(widget.text);
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
                await readJson(_c.text);
              },
              child: const Text('Click to check another user by Id'),
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
                    fontSize: 28,
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
