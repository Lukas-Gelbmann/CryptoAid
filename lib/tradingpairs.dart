import 'data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsejson/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part "tradingpairs.g.dart";

Future<List<TradingPair>> fetchTradingPairs(http.Client client,
    exchange) async {
  final response = await client
      .get('https://bachelorprojekt.com/' + exchange.exchange + "/orderbooks");
  return compute(parseTickers, response.body);
}

List<TradingPair> parseTickers(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TradingPair>((json) => TradingPair.fromJson(json)).toList();
}

@JsonSerializable(explicitToJson: true)
class TradingPair {
  final String quoteSymbol;
  final String baseSymbol;
  final List<OrderBooks> orderBooks;

  TradingPair(
      {this.quoteSymbol, this.baseSymbol, this.orderBooks});

  factory TradingPair.fromJson(Map<String, dynamic> json) =>
      _$TradingPairFromJson(json);

  Map<String, dynamic> toJson() => _$TradingPairToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OrderBooks {
  final List<OrderBook> orderBook;

  OrderBooks({this.orderBook});

  factory OrderBooks.fromJson(Map<String, dynamic> json) =>
      _$OrderBooksFromJson(json);

  Map<String, dynamic> toJson() => _$OrderBooksToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OrderBook {
  final List<TradingEntry> asks;
  final List<TradingEntry> bids;

  OrderBook({this.asks, this.bids});

  factory OrderBook.fromJson(Map<String, dynamic> json) =>
      _$OrderBookFromJson(json);

  Map<String, dynamic> toJson() => _$OrderBookToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TradingEntry {
  final String price;
  final String quantity;

  TradingEntry({this.price, this.quantity});

  factory TradingEntry.fromJson(Map<String, dynamic> json) =>
      _$TradingEntryFromJson(json);

  Map<String, dynamic> toJson() => _$TradingEntryToJson(this);
}

class TradingPairList extends StatefulWidget {
  final Exchange exchange;
  final List<TradingPair> tradingpairs;

  TradingPairList({Key key, this.exchange, this.tradingpairs})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TradingPairListState(exchange: exchange, tradingpairs: tradingpairs);
}

class TradingPairListState extends State<TradingPairList> {
  final List<TradingPair> tradingpairs;
  final Exchange exchange;

  TradingPairListState({this.exchange, this.tradingpairs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: tradingpairs.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          i = i ~/ 2;
          String tradingpair = tradingpairs[i].baseSymbol;
          return ListTile(
            title: Text(
              tradingpair,
            ),
          );
        });
  }
}
