import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  late WebSocketChannel channel;
  List<int> latencies = [];
  String receivedMessage = '';
  String lastLatency = '0 ms';
  String averageLatency = '0 ms';

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('wss://ws-go-flutter-latency.erix.dev/ws');
    // Listen to the WebSocket stream once.
    channel.stream.listen((response) {
      final endTime = DateTime.now();
      final latency = endTime.difference(_lastSentTime).inMilliseconds;
      setState(() {
        receivedMessage = response;
        latencies.add(latency);
        lastLatency = '$latency ms';
        averageLatency = '${latencies.reduce((a, b) => a + b) ~/ latencies.length} ms';
      });
    });
  }

  late DateTime _lastSentTime;

  void sendMessage() {
    final message = 'ZXVzb3B0dmJrZXNoanPDtmJpaHN0dm7DtnNvZHRiacO2aGR0dm9pdXN0Z2hqw7ZzasO2Z29zaXVodGdow7Zzb2l1c8O2aGdzdGdpdW9oc2tyw7ZsdGdoaXVzb2xocmdpdXNodGdpb3Now7ZnaXNoasO2b2l0Z2hqc8O2aWtsZ3Roc29ww7Zpcmd0aHNvaXJ1Z3Roc29waWhydGc=';
    _lastSentTime = DateTime.now();
    channel.sink.add(message);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send Message'),
            ),
            SizedBox(height: 20),
            Text('Received Message: $receivedMessage'),
            SizedBox(height: 20),
            Text('Last Latency: $lastLatency'),
            SizedBox(height: 20),
            Text('Average Latency: $averageLatency'),
          ],
        ),
      ),
    );
  }
}
