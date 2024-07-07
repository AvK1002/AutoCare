// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:autocare_flutter/models/service.dart' as _i11;
import 'package:autocare_flutter/ui/views/add_vehicle/add_vehicle_view.dart'
    as _i5;
import 'package:autocare_flutter/ui/views/admin/admin_view.dart' as _i4;
import 'package:autocare_flutter/ui/views/admin_vehicle_service/admin_vehicle_service_view.dart'
    as _i6;
import 'package:autocare_flutter/ui/views/home/home_view.dart' as _i2;
import 'package:autocare_flutter/ui/views/login/login_view.dart' as _i8;
import 'package:autocare_flutter/ui/views/login_register/login_register_view.dart'
    as _i7;
import 'package:autocare_flutter/ui/views/register/register_view.dart' as _i9;
import 'package:autocare_flutter/ui/views/startup/startup_view.dart' as _i3;
import 'package:flutter/material.dart' as _i10;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const adminView = '/admin-view';

  static const addVehicleView = '/add-vehicle-view';

  static const adminVehicleServiceView = '/admin-vehicle-service-view';

  static const loginRegisterView = '/login-register-view';

  static const loginView = '/login-view';

  static const registerView = '/register-view';

  static const all = <String>{
    homeView,
    startupView,
    adminView,
    addVehicleView,
    adminVehicleServiceView,
    loginRegisterView,
    loginView,
    registerView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.adminView,
      page: _i4.AdminView,
    ),
    _i1.RouteDef(
      Routes.addVehicleView,
      page: _i5.AddVehicleView,
    ),
    _i1.RouteDef(
      Routes.adminVehicleServiceView,
      page: _i6.AdminVehicleServiceView,
    ),
    _i1.RouteDef(
      Routes.loginRegisterView,
      page: _i7.LoginRegisterView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i8.LoginView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i9.RegisterView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.AdminView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.AdminView(),
        settings: data,
      );
    },
    _i5.AddVehicleView: (data) {
      final args = data.getArgs<AddVehicleViewArguments>(nullOk: false);
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i5.AddVehicleView(key: args.key, isCar: args.isCar),
        settings: data,
      );
    },
    _i6.AdminVehicleServiceView: (data) {
      final args =
          data.getArgs<AdminVehicleServiceViewArguments>(nullOk: false);
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.AdminVehicleServiceView(
            key: args.key, service: args.service, isAdmin: args.isAdmin),
        settings: data,
      );
    },
    _i7.LoginRegisterView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.LoginRegisterView(),
        settings: data,
      );
    },
    _i8.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.LoginView(key: args.key),
        settings: data,
      );
    },
    _i9.RegisterView: (data) {
      final args = data.getArgs<RegisterViewArguments>(
        orElse: () => const RegisterViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.RegisterView(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class AddVehicleViewArguments {
  const AddVehicleViewArguments({
    this.key,
    required this.isCar,
  });

  final _i10.Key? key;

  final bool isCar;

  @override
  String toString() {
    return '{"key": "$key", "isCar": "$isCar"}';
  }

  @override
  bool operator ==(covariant AddVehicleViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.isCar == isCar;
  }

  @override
  int get hashCode {
    return key.hashCode ^ isCar.hashCode;
  }
}

class AdminVehicleServiceViewArguments {
  const AdminVehicleServiceViewArguments({
    this.key,
    required this.service,
    required this.isAdmin,
  });

  final _i10.Key? key;

  final _i11.VehicleService service;

  final bool isAdmin;

  @override
  String toString() {
    return '{"key": "$key", "service": "$service", "isAdmin": "$isAdmin"}';
  }

  @override
  bool operator ==(covariant AdminVehicleServiceViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.service == service &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode {
    return key.hashCode ^ service.hashCode ^ isAdmin.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RegisterViewArguments {
  const RegisterViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant RegisterViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAdminView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.adminView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddVehicleView({
    _i10.Key? key,
    required bool isCar,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addVehicleView,
        arguments: AddVehicleViewArguments(key: key, isCar: isCar),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAdminVehicleServiceView({
    _i10.Key? key,
    required _i11.VehicleService service,
    required bool isAdmin,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.adminVehicleServiceView,
        arguments: AdminVehicleServiceViewArguments(
            key: key, service: service, isAdmin: isAdmin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginRegisterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.registerView,
        arguments: RegisterViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAdminView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.adminView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddVehicleView({
    _i10.Key? key,
    required bool isCar,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addVehicleView,
        arguments: AddVehicleViewArguments(key: key, isCar: isCar),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAdminVehicleServiceView({
    _i10.Key? key,
    required _i11.VehicleService service,
    required bool isAdmin,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.adminVehicleServiceView,
        arguments: AdminVehicleServiceViewArguments(
            key: key, service: service, isAdmin: isAdmin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginRegisterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.registerView,
        arguments: RegisterViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
