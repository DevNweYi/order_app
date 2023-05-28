import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/network_connectivity.dart';

class ConnectionCheckerPage extends StatefulWidget {
  const ConnectionCheckerPage({super.key});

  @override
  State<ConnectionCheckerPage> createState() => _ConnectionCheckerPageState();
}

class _ConnectionCheckerPageState extends State<ConnectionCheckerPage> {
  Map _event = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _networkConnectivity.initialize();
    _networkConnectivity.myStream.listen((event) {
      _event = event;
      print('event $_event');

      switch (_event.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _event.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string = _event.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        string,
        style: TextStyle(fontSize: 30),
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff6ae792),
      ),
      body: Center(
          child: Text(
        string,
        style: TextStyle(fontSize: 54),
      )),
    );
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }
}
