import 'package:flutter/material.dart';


abstract class BaseViewModel<T> with ChangeNotifier {

  BuildContext _context;

  T _viewState;

  bool _isLoading = false;

  set isLoading(bool isLoading) {
    if(_isLoading != isLoading){
      _isLoading = isLoading;
      this.notifyListeners();
    }
  }

  bool get isLoading => _isLoading;

  T get viewState => _viewState;


  BaseViewModel(this._context, this._viewState);

  @protected
  Future showLoading({ bool isShowLoading = true });

}