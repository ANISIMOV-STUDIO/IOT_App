import 'package:json_annotation/json_annotation.dart';
import 'user_response.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? token;
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  final UserResponse? user;

  AuthResponse({
    this.token,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  String? get actualToken => token ?? accessToken;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
