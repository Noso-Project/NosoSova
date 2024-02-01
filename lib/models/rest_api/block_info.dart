import 'dart:convert';

import 'package:noso_dart/models/noso/seed.dart';

class Masternode {
  final String ipv4;
  final int port;
  final String address;

  Masternode({
    this.ipv4 = "",
    this.port = 0,
    this.address = "",
  });

  factory Masternode.fromJson(Map<String, dynamic> json) {
    return Masternode(
      ipv4: json['ipv4'] ?? '',
      port: json['port'] ?? 0,
      address: json['address'] ?? '',
    );
  }

  List<Masternode> copyFromSeed(List<Seed> seeds) {
    if (seeds.isEmpty) {
      return [];
    }

    List<Masternode> masterNode = [];

    for (Seed mSeed in seeds) {
      masterNode.add(Masternode(
          ipv4: mSeed.ip, port: mSeed.port, address: mSeed.address));
    }
    return masterNode;
  }
}

class BlockInfo {
  final int blockId;
  final double reward;
  final int count;
  final List<Masternode> masternodes;

  BlockInfo({
    required this.blockId,
    required this.reward,
    required this.count,
    required this.masternodes,
  });

  factory BlockInfo.fromJson(Map<String, dynamic> json) {
    List<Masternode> masternodesList = [];
    if (json['masternodes'] != null) {
      for (var node in json['masternodes']) {
        masternodesList.add(Masternode.fromJson(node));
      }
    }

    return BlockInfo(
      blockId: json['block_id'] ?? 0,
      reward: json['reward'] ?? 0.0,
      count: json['count'] ?? 0,
      masternodes: masternodesList,
    );
  }

  static BlockInfo parse(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return BlockInfo.fromJson(jsonMap);
  }

  String getMasternodesString() {
    return masternodes
        .map((node) => '${node.ipv4}:${node.port}|${node.address}')
        .join(',');
  }

  BlockInfo copyWith({
    int? blockId,
    double? reward,
    int? count,
    List<Masternode>? masternodes,
  }) {
    return BlockInfo(
      blockId: blockId ?? this.blockId,
      reward: reward ?? this.reward,
      count: count ?? this.count,
      masternodes: masternodes ?? this.masternodes,
    );
  }
}
