import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'main.dart';
import 'package:barcode_scan/barcode_scan.dart';

part 'profile.g.dart';

class ExchangeKey {
  ExchangeKey(this.key, this.public, this.private);

  final String key;
  final String public;
  final String private;
}

class Profile extends StatefulWidget {
  final Exchange exchange;

  Profile({this.exchange});

  @override
  State<StatefulWidget> createState() {
    return ProfileState(exchange);
  }
}

class ProfileState extends State<Profile> {
  final Exchange exchange;
  final storage = new FlutterSecureStorage();
  ExchangeKey exchangeKey;

  ProfileState(this.exchange);

  @override
  void initState() {
    super.initState();
    initKey();
  }

  Future<Null> initKey() async {
    String value = await storage.read(key: exchange.exchange);
    setState(() {
      if (value == null) {
        return exchangeKey = ExchangeKey(exchange.exchange, "-", "-");
      } else {
        List<String> keys = value.split(":");
        return exchangeKey = ExchangeKey(exchange.exchange, keys[0], keys[1]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (exchangeKey == null) return Center(child: CircularProgressIndicator());
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Public"),
        ),
        ListTile(
          title: Text(exchangeKey.public),
        ),
        Divider(),
        ListTile(
          title: Text("Private"),
        ),
        ListTile(
          title: Text(exchangeKey.private),
        ),
        RaisedButton(
          child: Text("Edit"),
          onPressed: () => change(),
        ),
        RaisedButton(
          child: Text("Scan QRCode"),
          onPressed: () => scan(),
        )
      ],
    );
  }

  change() async {
    final result = await showDialog<String>(
        context: context,
        builder: (context) => _EditItemWidget(
            TextEditingController(text: exchangeKey.public),
            TextEditingController(text: exchangeKey.private)));
    if (result != null) {
      storage.write(key: exchange.exchange, value: result);
      initKey();
    }
  }

  scan() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      String data = "[" + result.rawContent + "]";
      Barcode barcode = parseBarcode(data)[0];
      storage.write(
          key: exchange.exchange,
          value: barcode.apiKey + ":" + barcode.secretKey);
    }
    initKey();
  }
}

List<Barcode> parseBarcode(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Barcode>((json) => Barcode.fromJson(json)).toList();
}

@JsonSerializable(explicitToJson: true)
class Barcode {
  final String apiKey;
  final String secretKey;

  Barcode(this.apiKey, this.secretKey);

  factory Barcode.fromJson(Map<String, dynamic> json) =>
      _$BarcodeFromJson(json);

  Map<String, dynamic> toJson() => _$BarcodeToJson(this);
}

class _EditItemWidget extends StatelessWidget {
  _EditItemWidget(this.publicKey, this.privateKey);

  final TextEditingController publicKey;
  final TextEditingController privateKey;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text("Public Key"),
            TextField(
              controller: publicKey,
              autofocus: true,
            ),
            Text("Private Key"),
            TextField(
              controller: privateKey,
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel')),
        FlatButton(
            onPressed: () => Navigator.of(context)
                .pop(publicKey.text + ":" + privateKey.text),
            child: Text('Save')),
      ],
    );
  }
}
