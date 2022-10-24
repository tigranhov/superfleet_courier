
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? status,
    List<String>? roles,
    bool? isAccountDisabled,
    String? createdAt,
    String? updatedAt,
    String? deletedAt
  }) = _User;
	
  factory User.fromJson(Map<String, dynamic> json) =>
			_$UserFromJson(json);
}
