import 'package:flutter/material.dart';
import 'package:flutter_final_project/pages/home_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/states/websocket_channel_cubit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class UsernamePage extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  var usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebSocketChannelCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Username Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'What do people call you?',
                  labelText: 'Name',
                ),
              ),
              BlocBuilder<WebSocketChannelCubit, WebSocketChannel>(
                builder: (context, state) {
                  return StreamBuilder(
                      stream: state.stream,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                            onPressed: () {
                              if (usernameController.text.isNotEmpty) {
                                state.sink.add(
                                    '{"type": "sign_in", "data": {"name": "${usernameController.text}"}}');
                              }
                              var response =
                                  jsonDecode(snapshot.data.toString())?['data']
                                      ['response'];

                              print(response);
                              if (response == "OK") {
                                context
                                    .read<WebSocketChannelCubit>()
                                    .getPosts();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  WebSocketChannelCubit(),
                                              child: HomePage(),
                                            )));
                              }
                            },
                            child: const Text('Enter The Application'));
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}


//jsonDecode(snapshot.data.toString())['data'] ['response']