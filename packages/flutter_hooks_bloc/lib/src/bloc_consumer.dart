import 'bloc_builder.dart';
import 'bloc_listener.dart';
import 'flutter_bloc.dart';

import 'package:flutter/widgets.dart';

/// {@template bloc_consumer}
/// [BlocConsumer] exposes a [builder] and [listener] in order react to new
/// states.
/// [BlocConsumer] is analogous to a nested `BlocListener`
/// and `BlocBuilder` but reduces the amount of boilerplate needed.
/// [BlocConsumer] should only be used when it is necessary to both rebuild UI
/// and execute other reactions to state changes in the [cubit].
///
/// [BlocConsumer] takes a required `BlocWidgetBuilder`
/// and `BlocWidgetListener` and an optional [cubit],
/// `BlocBuilderCondition`, and `BlocListenerCondition`.
///
/// If the [cubit] parameter is omitted, [BlocConsumer] will automatically
/// perform a lookup using `BlocProvider` and the current `BuildContext`.
///
/// ```dart
/// BlocConsumer<BlocA, BlocAState>(
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   builder: (context, state) {
///     // return widget here based on BlocA's state
///   }
/// )
/// ```
///
/// An optional [listenWhen] and [buildWhen] can be implemented for more
/// granular control over when [listener] and [builder] are called.
/// The [listenWhen] and [buildWhen] will be invoked on each [cubit] `state`
/// change.
/// They each take the previous `state` and current `state` and must return
/// a [bool] which determines whether or not the [builder] and/or [listener]
/// function will be invoked.
/// The previous `state` will be initialized to the `state` of the [cubit] when
/// the [BlocConsumer] is initialized.
/// [listenWhen] and [buildWhen] are optional and if they aren't implemented,
/// they will default to `true`.
///
/// ```dart
/// BlocConsumer<BlocA, BlocAState>(
///   listenWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to invoke listener with state
///   },
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   buildWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to rebuild the widget with state
///   },
///   builder: (context, state) {
///     // return widget here based on BlocA's state
///   }
/// )
/// ```
/// {@endtemplate}
class BlocConsumer<C extends Cubit<S>, S> extends BlocListenerBase<S>
    with BuildWhenOnStateEmittedMixin<S> {
  const BlocConsumer({
    Key key,

    /// The [cubit] that the [BlocConsumer] will interact with.
    /// If omitted, [BlocConsumer] will automatically perform a lookup using
    /// `BlocProvider` and the current `BuildContext`.
    C cubit,
    BlocListenerCondition<S> listenWhen,
    @required BlocWidgetListener<S> listener,
    this.buildWhen,
    @required this.builder,
  })  : assert(listener != null),
        assert(builder != null),
        super(
          key: key,
          cubit: cubit,
          listenWhen: listenWhen,
          listener: listener,
        );

  /// Takes the previous `state` and the current `state` and is responsible for
  /// returning a [bool] which determines whether or not to call [listener] of
  /// [BlocConsumer] with the current `state`.
  @override
  final BlocBuilderCondition<S> buildWhen;

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current `state` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final BlocWidgetBuilder<S> builder;

  /// Takes the previous `state` and the current `state` and is responsible
  /// for returning a [bool] which determines whether or not to trigger
  /// [builder] with the current `state`.
  @override
  Widget build(BuildContext context) {
    final _cubit = use<C>();
    return builder(context, _cubit.state);
  }
}
