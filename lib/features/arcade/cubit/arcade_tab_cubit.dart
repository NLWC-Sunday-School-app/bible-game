import 'package:bloc/bloc.dart';

enum ArcadeTab { globalChallenge, multiplayer }

/// Which sub-tab the arcade screen shows.
///
/// Held above [ArcadeScreen] because games launched from the arcade return
/// by pushing [AppRoutes.home], which rebuilds the screen from scratch. Local
/// state would reset to Global Challenge on the way back; this does not.
class ArcadeTabCubit extends Cubit<ArcadeTab> {
  ArcadeTabCubit() : super(ArcadeTab.multiplayer);

  void showGlobalChallenge() => emit(ArcadeTab.globalChallenge);

  void showMultiplayer() => emit(ArcadeTab.multiplayer);
}
