part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const ACTIVATE = _Paths.ACTIVATE;
  static const TRANNSACTION_DETAILS = _Paths.TRANNSACTION_DETAILS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ACTIVATE = '/activate';
  static const TRANNSACTION_DETAILS = '/trannsaction-details';
}
