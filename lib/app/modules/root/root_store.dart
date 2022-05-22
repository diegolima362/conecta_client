import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class RootStore extends NotifierStore<AppContentFailure, RootStoreState> {
  RootStore() : super(RootStoreState.empty());

  Unit setIndex(int index) {
    update(state.copyWith(currentIndex: index));

    return unit;
  }
}

class RootStoreState {
  final int currentIndex;
  final bool showingModal;

  RootStoreState(this.currentIndex, this.showingModal);

  factory RootStoreState.empty() => RootStoreState(0, false);

  RootStoreState copyWith({
    int? currentIndex,
    bool? showingModal,
  }) {
    return RootStoreState(
      currentIndex ?? this.currentIndex,
      showingModal ?? this.showingModal,
    );
  }
}
