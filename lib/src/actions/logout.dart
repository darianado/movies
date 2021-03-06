part of 'index.dart';

@freezed
class Logout with _$Logout implements AppAction {
  const factory Logout() = LogoutStart;

  // @Implements<UserAction>()
  const factory Logout.successful() = LogoutSuccessful;

  @Implements<ErrorAction>()
  const factory Logout.error(Object error, StackTrace stackTrace) = LogoutError;
}
