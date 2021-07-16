import 'dart:async';

class AppListener {
  static StreamController<Map> _appManageListener =
      StreamController.broadcast();
  static Map<Function, StreamSubscription> listeners = {};

  static void login(Map<String, Object> map) {
    _appManageListener.add(map);
  }

  static void addLoginListener(void onLogin(Map notification)) {
    listeners[onLogin] = _appManageListener.stream.listen(onLogin);
  }
  

  static void removeListener(void onData(dynamic data)){
    StreamSubscription? listener = listeners[onData];
    if(listener == null) return;
    listener.cancel();
    listeners.remove(onData);
  }


}
