import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester, {VoidCallback? onTap}) async {
    late BuildContext host;
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        home: Builder(builder: (context) {
          host = context;
          return Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: const SizedBox.expand(),
            ),
          );
        }),
      ),
    ));
    return host;
  }

  testWidgets('a toast replaced in the frame it was shown is not left behind',
      (tester) async {
    var taps = 0;
    final context = await pumpHost(tester, onTap: () => taps++);

    // Same frame, as "Game has started" and the connection toasts were: the
    // first entry has not been built yet when the second replaces it.
    CustomToast.showStatus(context, 'Connection restored');
    CustomToast.showStatus(context, 'Connection restored');
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.text('Connection restored'), findsNothing);

    // Nothing invisible in front of the screen either: the tap gets through.
    await tester.tapAt(const Offset(200, 130));
    expect(taps, 1);
  });

  testWidgets('a faded-out banner does not take taps', (tester) async {
    var taps = 0;
    final context = await pumpHost(tester, onTap: () => taps++);

    CustomToast.showBanner(context, 'Copied', duration: const Duration(seconds: 1));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(200, 40));
    expect(taps, 1);
  });
}
