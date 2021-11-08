import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/states/websocket_channel_cubit.dart';

class CreatePostsPage extends StatefulWidget {
  const CreatePostsPage({Key? key}) : super(key: key);

  @override
  _CreatePostsPageState createState() => _CreatePostsPageState();
}

class _CreatePostsPageState extends State<CreatePostsPage> {
  var postTitleController = TextEditingController();
  var postDescriptionController = TextEditingController();
  var postImageURLController = TextEditingController();
  void createPost() {
    var channel = BlocProvider.of<WebSocketChannelCubit>(context);

    channel.state.stream.listen((event) {
      var response = jsonDecode(event.toString());
      print(response);
    });

    channel.state.sink.add(
        '{"type": "create_post","data": {"title": "${postTitleController.text}", "description": "${postDescriptionController.text}","image": "${postImageURLController.text}"}}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                runSpacing: 20,
                children: <Widget>[
                  TextFormField(
                    controller: postTitleController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'What is the heading of the post?',
                      labelText: 'Title',
                    ),
                  ),
                  TextFormField(
                    controller: postDescriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'What is the heading of the post?',
                      labelText: 'Description',
                    ),
                    maxLines: 7,
                    minLines: 5,
                  ),
                  TextFormField(
                    controller: postImageURLController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.web_asset),
                      labelText: 'Image URL',
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    createPost();
                  },
                  child: const Text('Post'))
            ]));
  }
}
