import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'exchange.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class Exchange {
  final String exchange;
  final dynamic bestCaseFee;
  final dynamic worstCaseFee;
  final String icon;

  Exchange({this.exchange, this.bestCaseFee, this.worstCaseFee, this.icon});

  factory Exchange.fromJson(Map<String, dynamic> json) => Exchange(
        exchange: json['exchange'] as String,
        bestCaseFee: json['bestCaseFee'] as dynamic,
        worstCaseFee: json['worstCaseFee'] as dynamic,
        icon: json['icon'] as String,
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "bestCaseFee": bestCaseFee,
        "worstCaseFee": worstCaseFee,
        "icon": icon
      };
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'CryptoAid';
      return MaterialApp(
        title: appTitle,
        theme: ThemeData.dark(),
        home: MyHomePage(title: appTitle),
      );

  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      body: FutureBuilder<List<Exchange>>(
        future: fetchExchanges(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ExchangeList(exchanges: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ExchangeList extends StatefulWidget {
  final List<Exchange> exchanges;

  ExchangeList({Key key, this.exchanges}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      ExchangeListState(exchanges: exchanges);
}

class ExchangeListState extends State<ExchangeList> {
  final List<Exchange> exchanges;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  ExchangeListState({this.exchanges});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(6.0),
        itemCount: exchanges.length ,
        itemBuilder: (context, i) {

          return Card(child: ListTile(
            title: Text(
              exchanges.elementAt(i).exchange.replaceFirst(
                  exchanges.elementAt(i).exchange[0],
                  exchanges.elementAt(i).exchange[0].toUpperCase()),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ), //pfusch
            leading: Image.network(exchanges.elementAt(i).icon),
            onTap: () => openExchange(context, i),
          ));
        });
  }

  Future<void> _authorizeNow(context, i) async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (isAuthorized) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExchangeWidget(exchanges[i]),
          ));
    }
  }

  openExchange(context, int i) {
    _authorizeNow(context, i);
  }
}

Future<List<Exchange>> fetchExchanges(http.Client client) async {
  final response = await client.get('https://bachelorprojekt.com/exchanges');
  return compute(parseExchanges, response.body);
}

List<Exchange> parseExchanges(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Exchange>((json) => Exchange.fromJson(json)).toList();
}
