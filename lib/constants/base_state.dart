import 'package:flutter/material.dart';
import 'app_route_observer.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    implements RouteAware {
  @override
  void initState() {
    super.initState();
    onInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    onDispose();
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  void didPop() {}

  @override
  void didPushNext() {}

  @override
  void didPopNext() {
    onResume();
  }

  /// Called once from initState()
  @protected
  void onInit() {}

  /// Called whenever this screen becomes visible again
  @protected
  void onResume() {}

  /// Called before dispose()
  @protected
  void onDispose() {}
}
