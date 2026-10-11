// Google's own sign-in button exists only on web; elsewhere this draws nothing.
export 'google_web_button_stub.dart'
    if (dart.library.js_interop) 'google_web_button_web.dart';
