import 'package:flutter/material.dart';


abstract class BaseViewModel<T> with ChangeNotifier {

  BuildContext _context;

  bool _isLoading = false;

  set isLoading(bool isLoading) {
    if(_isLoading != isLoading){
      _isLoading = isLoading;
      this.notifyListeners();
    }
  }

  bool get isLoading => _isLoading;


  BaseViewModel(this._context);

  @protected
  Future loadData({ bool isShowLoading = true });

}