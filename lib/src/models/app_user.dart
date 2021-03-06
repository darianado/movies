part of 'index.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String email,
    required String uid,
    required String username,
    @Default(<int>[]) List<int> favoriteMovies,
  }) = AppUser$;

  factory AppUser.fromJson(Map<dynamic, dynamic> json) => _$AppUserFromJson(Map<String, dynamic>.from(json));
}
