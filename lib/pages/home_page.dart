import 'package:flutter/material.dart';
import 'package:flutter_final_project/pages/about_page.dart';
import 'package:flutter_final_project/pages/create_posts_page.dart';
import 'package:flutter_final_project/states/username_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsernameCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<UsernameCubit, String>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Text('Welcome $state');
            },
          ),
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
                          ElevatedButton(onPressed: () {}, child: Text('Sort')),
                          ElevatedButton(
                              onPressed: () {}, child: Text('Favourites'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text('Hello Worlds'),
            ],
          ),
        ),
      ),
    );
  }
}
