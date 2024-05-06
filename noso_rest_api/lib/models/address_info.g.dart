// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressInfo _$AddressInfoFromJson(Map<String, dynamic> json) => AddressInfo(
      address: json['address'] as String,
      alias: json['alias'] as String?,
      block: (json['block'] as num).toInt(),
      balance: (json['balance'] as num).toDouble(),
      incoming: (json['incoming'] as num).toInt(),
      outgoing: (json['outgoing'] as num).toInt(),
      locked: (json['locked'] as num).toInt(),
      blocksLocked: json['blocks_locked'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AddressInfoToJson(AddressInfo instance) =>
    <String, dynamic>{
      'address': instance.address,
      'alias': instance.alias,
      'block': instance.block,
      'balance': instance.balance,
      'incoming': instance.incoming,
      'outgoing': instance.outgoing,
      'locked': instance.locked,
      'blocks_locked': instance.blocksLocked,
    };
