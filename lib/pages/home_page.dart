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
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username = 'Joshuaa';
  List posts = [];

  void getPosts() {
    var channel = BlocProvider.of<WebSocketChannelCubit>(context);

    channel.state.stream.listen((event) {
      var decodedMessage = jsonDecode(event.toString());

      setState(() {
        posts = decodedMessage['data']['posts'];
        posts = posts.reversed.toList();
      });
      print(posts);
      print(posts.length);
      channel.state.sink.close();
    });

    channel.state.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebSocketChannelCubit(),
      child: Scaffold(
        backgroundColor: Colors.purple[50],
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => WebSocketChannelCubit(),
                            child: CreatePostsPage(),
                          )));
            },
            child: const Icon(Icons.create_sharp)),
        body: Center(
          child: Column(
            children: <Widget>[
              //banner container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //right banner
                    Container(
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                posts = posts.reversed.toList();
                              },
                              child: Icon(Icons.sort)),
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

              Container(
                height: 600.0,
                child: BlocBuilder<WebSocketChannelCubit, WebSocketChannel>(
                  builder: (context, state) {
                    return StreamBuilder(
                        stream: state.stream,
                        builder: (context, snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                var dateTime = DateTime.parse(
                                    posts[index]['date'].toString());
                                final timeFormat = DateFormat('hh:mm a');
                                final dateFormat = DateFormat('d/M/y');
                                String date = dateFormat.format(dateTime);
                                String time = timeFormat.format(dateTime);

                                return InkWell(
                                  onDoubleTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailsPage(
                                                  title: posts[index]['title'],
                                                  image: posts[index]
                                                          ['image'] ??
                                                      "no image",
                                                  time: time,
                                                  date: date,
                                                  author: posts[index]
                                                      ['author'],
                                                  description: posts[index]
                                                      ['description'],
                                                )));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 5),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            Text(
                                              posts[index]['author'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              posts[index]['title'],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {},
                                                child: Icon(
                                                    Icons.favorite_outline)),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(time),
                                                  Text(date),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
