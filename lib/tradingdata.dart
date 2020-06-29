import 'dart:math';

import 'package:parsejson/tradingpairs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsejson/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';

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
    String pairString = tradingPair.baseSymbol + "/" + tradingPair.quoteSymbol;
    return Scaffold(
        appBar: AppBar(
          title: Text(pairString),
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
  final double btcVolume;
  final String time;

  OHLCVData(
      {this.open, this.high, this.low, this.close, this.btcVolume, this.time});

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
  return parsed.map<History>((json) => History.fromJson(json)).toList();
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
  List data;
  int entries;

  TradingDataViewState(
      {this.exchange, this.tradingPair, this.history, this.data}) {
    if(history.isEmpty)
      return;
    final x = history[0].history;
    data = new List();
    for (int i = 0; i < x.length; i++) {
      Map singleMap = Map<String, double>();
      singleMap["open"] = double.parse(x[i].open);
      singleMap["high"] = double.parse(x[i].high);
      singleMap["low"] = double.parse(x[i].low);
      singleMap["close"] = double.parse(x[i].close);
      singleMap["volumeto"] = x[i].btcVolume;
      data.add(singleMap);
    }
    entries = 30;
  }

  @override
  Widget build(BuildContext context) {
    if(history.isEmpty)
      return Center(child: Text("Data not found"),);
    List visibleData = data.sublist(data.length-entries, data.length);
    return ListView(children: <Widget>[
      Container(
        height: 500.0,
        child: OHLCVGraph(
          data: visibleData,
          volumeProp: 0.2,
          enableGridLines: true,
          labelPrefix: tradingPair.quoteSymbol,
          gridLineColor: Colors.white30,
          gridLineLabelColor: Colors.white30,
        ),
      ),
      ButtonBar(
        children: [
          RaisedButton(
            child: Text("All",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            color: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey)),
            onPressed: () => dataChange(0),
          ),
          RaisedButton(
            child: Text("Year",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            color: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey)),
            onPressed: () => dataChange(1),
          ),
          RaisedButton(
            child: Text("Month",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            color: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey)),
            onPressed: () => dataChange(2),
          ),
          RaisedButton(
            child: Text("Week",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            color: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.grey)),
            onPressed: () => dataChange(3),
          ),
        ],
      )
    ]);
    //Center(child: Text(history[0].history[0].open));
  }

  dataChange(int i) {
    setState(() {
      if (i == 0)
        entries = data.length;
      else if (i == 1 && data.length > 365)
        entries = 365;
      else if (i == 2 && data.length > 30)
        entries = 30;
      else if (i == 3 && data.length > 7) entries = 7;
    });
  }
}
