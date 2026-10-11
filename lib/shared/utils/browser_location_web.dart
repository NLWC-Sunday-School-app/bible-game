import 'package:web/web.dart' as web;

void clearInvitePath() {
  final location = web.window.location;
  if (!location.pathname.startsWith('/join/')) return;
  web.window.history.replaceState(null, '', '/${location.hash}');
}
