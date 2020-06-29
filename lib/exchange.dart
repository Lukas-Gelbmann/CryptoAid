import 'package:flutter/material.dart';
import 'package:parsejson/main.dart';
import 'package:http/http.dart' as http;
import 'package:parsejson/tradingpairs.dart';
import 'ticker.dart';
import 'profile.dart';

class ExchangeWidget extends StatefulWidget {
  final Exchange exchange;

  ExchangeWidget(this.exchange);

  @override
  State<StatefulWidget> createState() {
    return ExchangeWidgetState(exchange);
  }
}

class ExchangeWidgetState extends State<ExchangeWidget> {
  final Exchange exchange;
  int _selectedIndex = 0;

  ExchangeWidgetState(this.exchange);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
            exchange.exchange.toUpperCase(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text("USD Ticker Prices", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              icon: Icon(Icons.access_time),
            ),
            BottomNavigationBarItem(
              title: Text("Trading", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              icon: Icon(Icons.history),
            ),
            BottomNavigationBarItem(
              title: Text("Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              icon: Icon(Icons.person),
            ),
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
    } else if (_selectedIndex == 1) {
      return FutureBuilder<List<TradingPair>>(
        future: fetchTradingPairs(http.Client(), exchange),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? TradingPairList(exchange: exchange, tradingpairs: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return Profile(exchange: exchange);
    }
  }
}
