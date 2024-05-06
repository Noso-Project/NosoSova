import 'package:json_annotation/json_annotation.dart';

part 'api_status.g.dart';

@JsonSerializable()
class ApiStatus {
  @JsonKey(name: 'API')
  final String? api;
  final String? nosoDB;

  ApiStatus({
    required this.api,
    required this.nosoDB,
  });

  factory ApiStatus.fromJson(Map<String, dynamic> json) => _$ApiStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ApiStatusToJson(this);
}