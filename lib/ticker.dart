import 'data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsejson/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Ticker>> fetchTickers(http.Client client, exchange) async {
  final response = await client
      .get('https://bachelorprojekt.com/' + exchange.exchange + "/ticker");
  return compute(parseTickers, response.body);
}

List<Ticker> parseTickers(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Ticker>((json) => Ticker.fromJson(json)).toList();
}

class Ticker {
  final String name;
  final String symbol;
  final String priceUSD;
  final String priceBTC;
  final dynamic percentChange24h;
  final String lastUpdated;

  Ticker(
      {this.name,
      this.symbol,
      this.priceUSD,
      this.priceBTC,
      this.percentChange24h,
      this.lastUpdated});

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
        name: json['name'] as String,
        symbol: json['symbol'] as String,
        priceUSD: json['priceUsd'] as String,
        priceBTC: json['priceBtc'] as String,
        percentChange24h: json['percentChange24hUsd'] as String,
        lastUpdated: json['lastUpdated'] as String,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "priceUsd": priceUSD,
        "priceBtc": priceBTC,
        "percentChange24hUsd": percentChange24h,
        "lastUpdated": lastUpdated
      };
}

class TickerList extends StatefulWidget {
  final Exchange exchange;
  final List<Ticker> tickers;

  TickerList({Key key, this.exchange, this.tickers}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TickerListState(exchange: exchange, tickers: tickers);
}

class TickerListState extends State<TickerList> {
  final List<Ticker> tickers;
  final Exchange exchange;

  TickerListState({this.exchange, this.tickers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: tickers.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          i = i ~/ 2;
          String price = tickers[i].priceUSD + " USD  ";
          if (tickers[i].priceUSD.length > 6)
            price = tickers[i].priceUSD.substring(0, 5) + " USD  ";
          String name = tickers[i].name;
          String change = tickers[i].percentChange24h + " %";
          if (tickers[i].percentChange24h.length > 6)
            change = tickers[i].percentChange24h.substring(0, 5) + " %";
          Color color = Colors.green;
          if (change[0] == "-") {
            color = Colors.red;
          }
          return ListTile(
            trailing: Text(
              change,
              style: TextStyle(color: color),
            ),
            leading: Text(
              name,
              style: TextStyle(fontSize: 20.0),
            ),
            title: Text(
              price,
              textAlign: TextAlign.right,
            ),
          );
        });
  }
}
