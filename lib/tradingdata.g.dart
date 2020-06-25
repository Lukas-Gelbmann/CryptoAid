// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tradingdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) {
  return History(
    history: (json['history'] as List)
        ?.map((e) =>
            e == null ? null : OHLCVData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'history': instance.history?.map((e) => e?.toJson())?.toList(),
    };

OHLCVData _$OHLCVDataFromJson(Map<String, dynamic> json) {
  return OHLCVData(
    open: json['open'] as String,
    high: json['high'] as String,
    low: json['low'] as String,
    close: json['close'] as String,
    btcVolume: (json['btcVolume'] as num)?.toDouble(),
    time: json['time'] as String,
  );
}

Map<String, dynamic> _$OHLCVDataToJson(OHLCVData instance) => <String, dynamic>{
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'btcVolume': instance.btcVolume,
      'time': instance.time,
    };
