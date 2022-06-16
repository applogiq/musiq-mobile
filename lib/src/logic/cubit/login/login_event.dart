abstract class LoginEvent{}
class UserNameChanged extends LoginEvent{
  final String username;

  UserNameChanged(this.username);
}
class PasswordChanged extends LoginEvent{
  final String password;

  PasswordChanged(this.password);

}
class LoginSubmit extends LoginEvent{
  

  }