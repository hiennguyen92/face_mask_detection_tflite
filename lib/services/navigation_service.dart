import 'package:flutter/cupertino.dart';

class NavigationService {
  // Global navigation key for whole application
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  /// Pushing new page into navigation stack
  ///
  /// `routeName` is page's route name defined in [AppRoute]
  /// `args` is optional data to be sent to new page
  Future<T?> pushNamed<T extends Object>(String routeName,
      {Object? args}) async {
    return navigationKey.currentState?.pushNamed<T>(
      routeName,
      arguments: args,
    );
  }

  /// Pushing new page into navigation stack
  ///
  /// `route` is route generator
  Future<T?> push<T extends Object>(Route<T> route) async {
    return navigationKey.currentState?.push<T>(route);
  }


  /// Replace the current route of the navigator by pushing the given route and
  /// then disposing the previous route once the new route has finished
  /// animating in.
  Future<T?> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object? args}) async {
    return navigationKey.currentState?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: args,
    );
  }

  /// Push the route with the given name onto the navigator, and then remove all
  /// the previous routes until the `predicate` returns true.
  Future<T?> pushNamedAndRemoveUntil<T extends Object>(
      String routeName, {
        Object? args,
        bool Function(Route<dynamic>)? predicate,
      }) async {
    return navigationKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (_) => false,
      arguments: args,
    );
  }

  /// Push the given route onto the navigator, and then remove all the previous
  /// routes until the `predicate` returns true.
  Future<T?> pushAndRemoveUntil<T extends Object>(
      Route<T> route, {
        bool Function(Route<dynamic>)? predicate,
      }) async {
    return navigationKey.currentState?.pushAndRemoveUntil<T>(
      route,
      predicate ?? (_) => false,
    );
  }

  /// Consults the current route's [Route.willPop] method, and acts accordingly,
  /// potentially popping the route as a result; returns whether the pop request
  /// should be considered handled.
  Future<bool> maybePop<T extends Object>([Object? args]) async {
    return navigationKey.currentState!.maybePop<T>(args as T);
  }

  /// Whether the navigator can be popped.
  bool canPop() => navigationKey.currentState!.canPop();

  /// Pop the top-most route off the navigator.
  void goBack<T extends Object>({T? result}) {
    navigationKey.currentState?.pop<T>(result);
  }

  /// Calls [pop] repeatedly until the predicate returns true.
  void popUntil(String route) {
    navigationKey.currentState!.popUntil(ModalRoute.withName(route));
  }

}