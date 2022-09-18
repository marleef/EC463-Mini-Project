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
    'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
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
  final response =
    await http.get(Uri.parse(url),
    headers: headers,
  );
  if(response.statusCode == 200){
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Twitter Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";
  
  Future<void> readJson() async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
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
    }
    else {
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
        centerTitle: true,
        title: const Text(
          'Twitter App',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              child: const Text(
                'Query User by id',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                _sendDataToQueryUserbyIdScreen(context);
              },
            ),
            ElevatedButton(
              onPressed: readJson,
              child: const Text('Present Results'),
              
            ),
            Text('id: $_id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            Text('name: $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            Text('username: $_username',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            // Display the data loaded from sample.json
            // _items.isEmpty
            //     ? Expanded(
            //         child: ListView.builder(
            //           itemCount: _items.length,
            //           itemBuilder: (context, index) {
            //             return Card(
            //               margin: const EdgeInsets.all(10),
            //               child: ListTile(
            //                 leading: Text(_items),
            //                 title: Text(_items),
            //                 subtitle: Text(_items),
            //               ),
            //             );
            //           },
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
  void _sendDataToQueryUserbyIdScreen(BuildContext context) {
    String textToSend = textEditingController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueryUserbyIdScreen(text: textToSend,),
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
      appBar: AppBar(title: Text('Second screen')),
      body: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
  
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Fetch Data Example',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Fetch Data Example'),
  //       ),
  //       body: Center(
  //         child: FutureBuilder(
  //           future: fetchPostman(),
  //           builder: (BuildContext ctx, AsyncSnapshot snapshot) {
  //             if (snapshot.data == null) {
  //               return Container(
  //                 child: Center(
  //                   child: CircularProgressIndicator(),
  //                 ),
  //               );
  //             } else {
  //               return ListView.builder(
  //                 itemCount: snapshot.data.length,
  //                 itemBuilder: (ctx, index) => ListTile(
  //                   title: Text(snapshot.data[index].name),
  //                   subtitle: Text(snapshot.data[index].username),
  //                   contentPadding: EdgeInsets.only(bottom: 20.0),
  //                 ),
  //               );
  //             }
  //           },
  //         ),
          
          // child: ListView.builder(
          //   itemCount: _posts.length,
          //   itemBuilder: (context, i) {
          //     final post = _posts[i];
          //     return Text("id: ${post["id"]}\n Name: ${post["name"]} \n username: ${post["username"]}}\n\n");
          //   }
          // ),
          
          // child: FutureBuilder(
          //   future: Response,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return ListView.builder(
          //         itemCount: _posts.length,
          //         itemBuilder: (context, i) {
          //           final post = _posts[i];
          //           return Text("id: ${post["id"]}\n Name: ${post["name"]} \n username: ${post["username"]}}\n\n");
          //         }
          //       );
          //     } else if (snapshot.hasError) {
          //       return Text('hello, ${snapshot.error}');
          //     }

          //     // By default, show a loading spinner.
          //     return const CircularProgressIndicator();
          //   },
          // ),
  //       ),
  //     ),
  //   );
  // }

