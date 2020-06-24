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
    orderBook: (json['orderBook'] as List)
        ?.map((e) =>
            e == null ? null : OrderBook.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderBooksToJson(OrderBooks instance) =>
    <String, dynamic>{
      'orderBook': instance.orderBook?.map((e) => e?.toJson())?.toList(),
    };

OrderBook _$OrderBookFromJson(Map<String, dynamic> json) {
  return OrderBook(
    asks: (json['asks'] as List)
        ?.map((e) =>
            e == null ? null : TradingEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    bids: (json['bids'] as List)
        ?.map((e) =>
            e == null ? null : TradingEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderBookToJson(OrderBook instance) => <String, dynamic>{
      'asks': instance.asks?.map((e) => e?.toJson())?.toList(),
      'bids': instance.bids?.map((e) => e?.toJson())?.toList(),
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
