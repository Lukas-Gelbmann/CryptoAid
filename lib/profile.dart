import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';
import 'dart:math';

enum _ItemActions { delete, edit }

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}

class Profile extends StatefulWidget {
  Exchange exchange;

  Profile({this.exchange});

  @override
  State<StatefulWidget> createState() {
    return ProfileState(exchange);
  }
}

class ProfileState extends State<Profile> {
  final _storage = FlutterSecureStorage();
  List<_SecItem> _items = [];
  final Exchange exchange;

  ProfileState(this.exchange);

  @override
  void initState() {
    super.initState();

    _readAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _items.length * 2 + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index.isOdd) return Divider();
          index = index ~/ 2;
          if (index == _items.length) {
            return ListTile(
              onTap: _addNewItem,
              title: Text(
                "Add new API Keys",
                style: TextStyle(fontSize: 28),
              ),
            );
          }
          return ListTile(
            trailing: PopupMenuButton(
                key: Key('popup_row_$index'),
                onSelected: (_ItemActions action) =>
                    _performAction(action, _items[index]),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<_ItemActions>>[
                      PopupMenuItem(
                        value: _ItemActions.delete,
                        child: Text(
                          'Delete',
                          key: Key('delete_row_$index'),
                        ),
                      ),
                      PopupMenuItem(
                        value: _ItemActions.edit,
                        child: Text(
                          'Edit',
                          key: Key('edit_row_$index'),
                        ),
                      ),
                    ]),
            title: Text(
              _items[index].value,
              key: Key('title_row_$index'),
            ),
            subtitle: Text(
              _items[index].key,
              key: Key('subtitle_row_$index'),
            ),
          );
        });
  }

  Future<Null> _performAction(_ItemActions action, _SecItem item) async {
    switch (action) {
      case _ItemActions.delete:
        await _storage.delete(key: item.key);
        _readAll();

        break;
      case _ItemActions.edit:
        final result = await showDialog<String>(
            context: context,
            builder: (context) => _EditItemWidget(item.value));
        if (result != null) {
          _storage.write(key: item.key, value: result);
          _readAll();
        }
        break;
    }
  }

  void _addNewItem() async {
    final String key = exchange.exchange;
    final String value = "_randomValue()";

    await _storage.write(key: key, value: value);
    _readAll();
  }

  String _randomValue() {
    final rand = Random();
    final codeUnits = List.generate(20, (index) {
      return rand.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }

  Future<Null> _readAll() async {
    final all = await _storage.readAll();
    setState(() {
      return _items = all.keys
          .map((key) => _SecItem(key, all[key]))
          .toList(growable: false);
    });
  }
}

class _EditItemWidget extends StatelessWidget {
  _EditItemWidget(String text)
      : _controller = TextEditingController(text: text);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit item'),
      content: TextField(
        key: Key('title_field'),
        controller: _controller,
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
            key: Key('cancel'),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel')),
        FlatButton(
            key: Key('save'),
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: Text('Save')),
      ],
    );
  }
}
