import 'package:flutter/material.dart';
import 'package:flutter_final_project/pages/home_page.dart';
import 'package:flutter_final_project/states/username_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({Key? key}) : super(key: key);

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  var usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsernameCubit(),
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
              BlocConsumer<UsernameCubit, String>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () {
                        context
                            .read<UsernameCubit>()
                            .setUsername(usernameController.text);
                        print(state);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      child: const Text('Enter The Application'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
