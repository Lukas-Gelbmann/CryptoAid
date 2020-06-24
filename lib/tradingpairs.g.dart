// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tradingpairs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradingPair _$TradingPairFromJson(Map<String, dynamic> json) {
  return TradingPair(
    quoteSymbol: json['quoteSymbol'] as String,
    baseSymbol: json['baseSymbol'] as String,
    orderBooks: (json['orderBooks'] as List)
        ?.map((e) =>
            e == null ? null : OrderBooks.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TradingPairToJson(TradingPair instance) =>
    <String, dynamic>{
      'quoteSymbol': instance.quoteSymbol,
      'baseSymbol': instance.baseSymbol,
      'orderBooks': instance.orderBooks?.map((e) => e?.toJson())?.toList(),
    };

OrderBooks _$OrderBooksFromJson(Map<String, dynamic> json) {
  return OrderBooks(
    exchange: json['exchange'] as String,
    orderBook: (json['orderBook'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : TradingEntry.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    ),
  );
}

Map<String, dynamic> _$OrderBooksToJson(OrderBooks instance) =>
    <String, dynamic>{
      'exchange': instance.exchange,
      'orderBook': instance.orderBook
          ?.map((k, e) => MapEntry(k, e?.map((e) => e?.toJson())?.toList())),
    };

TradingEntry _$TradingEntryFromJson(Map<String, dynamic> json) {
  return TradingEntry(
    price: json['price'] as String,
    quantity: json['quantity'] as String,
  );
}

Map<String, dynamic> _$TradingEntryToJson(TradingEntry instance) =>
    <String, dynamic>{
      'price': instance.price,
      'quantity': instance.quantity,
    };
