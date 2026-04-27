class LoginAndRegisterState {}

class Loginandregisterinitial extends LoginAndRegisterState {}

class Loginandregisterloading extends LoginAndRegisterState {}

class Loginandregistersucces extends LoginAndRegisterState {}

class Loginandregisterfailure extends LoginAndRegisterState {
  final String msj;

  Loginandregisterfailure({required this.msj});
}
