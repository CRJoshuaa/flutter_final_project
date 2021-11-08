import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketChannelCubit extends Cubit<WebSocketChannel> {
  WebSocketChannelCubit()
      : super(IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com'));

  void getPosts() {
    state.sink.add('{"type": "get_posts","data": {"limit": 10}}');
  }

  void dispose() {
    state.sink.close();
  }
}
