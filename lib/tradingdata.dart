import 'package:parsejson/tradingpairs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsejson/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'tradingdata.g.dart';

class TradingDataWidget extends StatefulWidget {
  final Exchange exchange;
  final TradingPair tradingPair;

  TradingDataWidget({Key key, this.exchange, this.tradingPair})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TradingDataWidgetState(exchange: exchange, tradingPair: tradingPair);
}

class TradingDataWidgetState extends State<TradingDataWidget> {
  final Exchange exchange;
  final TradingPair tradingPair;

  TradingDataWidgetState({this.exchange, this.tradingPair});

  @override
  Widget build(BuildContext context) {
    String pairString = tradingPair.quoteSymbol + "/" + tradingPair.baseSymbol;
    return Scaffold(
        appBar: AppBar(
          title: Text("Trading View"),
        ),
        body: FutureBuilder<List<History>>(
          future:
              fetchHistory(http.Client(), exchange, tradingPair: tradingPair),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? TradingDataView(
                    exchange: exchange,
                    tradingPair: tradingPair,
                    history: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ));
  }
}

@JsonSerializable(explicitToJson: true)
class History {
  final List<OHLCVData> history;

  History({this.history});

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OHLCVData {
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;
  final String time;

  OHLCVData(
      {this.open, this.high, this.low, this.close, this.volume, this.time});

  factory OHLCVData.fromJson(Map<String, dynamic> json) =>
      _$OHLCVDataFromJson(json);

  Map<String, dynamic> toJson() => _$OHLCVDataToJson(this);
}

Future<List<History>> fetchHistory(http.Client client, exchange,
    {TradingPair tradingPair}) async {
  final response = await client.get('https://bachelorprojekt.com/' +
      exchange.exchange +
      "/history?base=" +
      tradingPair.baseSymbol +
      "&quote=" +
      tradingPair.quoteSymbol);
  return compute(parseHistory, response.body);
}

List<History> parseHistory(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TradingPair>((json) => TradingPair.fromJson(json)).toList();
}

class TradingDataView extends StatefulWidget {
  final Exchange exchange;
  final List<History> history;
  final TradingPair tradingPair;

  TradingDataView({this.exchange, this.tradingPair, this.history});

  @override
  State<StatefulWidget> createState() => TradingDataViewState(
      exchange: exchange, history: history, tradingPair: tradingPair);
}

class TradingDataViewState extends State<TradingDataView> {
  final Exchange exchange;
  final List<History> history;
  final TradingPair tradingPair;

  TradingDataViewState({this.exchange, this.tradingPair, this.history});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(history[0].history[0].open));
  }
}