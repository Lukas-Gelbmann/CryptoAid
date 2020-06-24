import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsejson/main.dart';
import 'package:http/http.dart' as http;
import 'package:parsejson/tradingpairs.dart';
import 'dart:async';
import 'dart:convert';
import 'ticker.dart';

class DataWidget extends StatefulWidget {
  final Exchange exchange;

  DataWidget(this.exchange);

  @override
  State<StatefulWidget> createState() {
    return DataWidgetState(exchange);
  }
}

class DataWidgetState extends State<DataWidget> {
  final Exchange exchange;
  int _selectedIndex = 0;

  DataWidgetState(this.exchange);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(exchange.exchange.toUpperCase()),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text("USD Ticker Prices"),
              icon: Icon(Icons.access_time),
            ),
            BottomNavigationBarItem(
              title: Text("Trading Pairs"),
              icon: Icon(Icons.history),
            )
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: _createBody());
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  Widget _createBody() {
    if (_selectedIndex == 0) {
      return FutureBuilder<List<Ticker>>(
        future: fetchTickers(http.Client(), exchange),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? TickerList(exchange: exchange, tickers: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return FutureBuilder<List<TradingPair>>(
        future: fetchTradingPairs(http.Client(), exchange),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? TradingPairList(exchange: exchange, tradingpairs: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
