// ignore_for_file: unused_element

import 'package:flutter/widgets.dart' hide Action;

import '../redux/index.dart';
import 'basic.dart';

typedef InitState<T, P> = T Function(P params);

/*
 * Page Container
 * <T>: Page State 
 * <p>: Page Params
 */
abstract class Page<T, P> extends ReduxComponent<T> {
  final InitState<T, P> initState;

  Page({
    required this.initState,
    required Reducer<T> reducer,
    required ViewBuilder<T> view, ShouldUpdate<T>? shouldUpdate,
    Effects<T>? effects
  })
      : super(reducer: reducer, view: view, effects:effects,  shouldUpdate: shouldUpdate);

  Widget buildPage(P param) =>
      _PageWidget<T, P>(
        param: param,
        page: this,
      );
}

class _PageWidget<T, P> extends StatefulWidget {
  final P param;
  final Page<T, P> page;

  const _PageWidget({key, required this.param, required this.page})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageState<T, P>();
}

class _PageState<T, P> extends State<_PageWidget<T, P>> {
  late Store<T> _store;
  late T state;

  @override
  void initState() {
    super.initState();
    state = widget.page.initState(widget.param);
    _store = createStore(state, widget.page.createReducer());
  }

  @override
  Widget build(BuildContext context) =>
      widget.page.build(_store as Store<Object>, _store.getState);
}

