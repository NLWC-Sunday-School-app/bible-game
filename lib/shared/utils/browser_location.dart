// Conditional imports: a no-op everywhere but the web build.
import 'browser_location_stub.dart'
    if (dart.library.js_interop) 'browser_location_web.dart' as platform;

/// On web, takes an invite link's /join/CODE back out of the address bar once
/// it has been handled, so a refresh does not act on it again. Flutter's own
/// route lives in the #fragment and is left as it is. Does nothing elsewhere.
void clearInvitePathFromAddressBar() => platform.clearInvitePath();
