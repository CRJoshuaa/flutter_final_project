import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_final_project/pages/about_page.dart';
import 'package:flutter_final_project/pages/create_posts_page.dart';
import 'package:flutter_final_project/pages/post_details_page.dart';
import 'package:flutter_final_project/states/username_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/states/websocket_channel_cubit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username = 'Joshuaa';
  List posts = [];

  @override
  void initState() {
    super.initState();
    var channel = BlocProvider.of<WebSocketChannelCubit>(context);

    channel.state.stream.listen((event) {
      var decodedMessage = jsonDecode(event.toString());

      setState(() {
        posts = decodedMessage['data']['posts'];
      });
      print(posts);
      print(posts.length);

      channel.state.sink.close();
    });

    channel.state.sink.add('{"type": "get_posts","data": {"limit": 10}}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebSocketChannelCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome $username'),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutPage()));
            },
            child: const Icon(Icons.settings),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatePostsPage()));
            },
            child: const Icon(Icons.create_sharp)),
        body: Center(
          child: Column(
            children: <Widget>[
              //banner container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(onPressed: () {}, child: Text('Settings')),
                    //right banner
                    Container(
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () {}, child: Icon(Icons.sort)),
                          SizedBox(width: 5),
                          BlocBuilder<WebSocketChannelCubit, WebSocketChannel>(
                            builder: (context, state) {
                              return ElevatedButton(
                                  onPressed: () {},
                                  child: Icon(Icons.favorite));
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text('Hello Worlds'),
              Container(
                height: 600.0,
                child: FutureBuilder(builder: (context, snapshot) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetailsPage(
                                          title: posts[index]['title'],
                                          image: posts[index]['image'],
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Text(
                                      posts[index]['author'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      posts[index]['title'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
