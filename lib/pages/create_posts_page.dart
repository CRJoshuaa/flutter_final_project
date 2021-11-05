import 'package:flutter/material.dart';

class CreatePostsPage extends StatefulWidget {
  const CreatePostsPage({Key? key}) : super(key: key);

  @override
  _CreatePostsPageState createState() => _CreatePostsPageState();
}

class _CreatePostsPageState extends State<CreatePostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        centerTitle: true,
      ),
      body: Container(
        child: Wrap(runSpacing: 20, children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What is the heading of the post?',
              labelText: 'Title',
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What is the heading of the post?',
              labelText: 'Description',
            ),
            maxLines: 7,
            minLines: 5,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.web_asset),
              labelText: 'Image URL',
            ),
          ),
        ]),
      ),
    );
  }
}
