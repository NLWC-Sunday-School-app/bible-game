import 'package:bible_game_api/model/game_invites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/image_routes.dart';
import '../../../shared/widgets/multi_avatar.dart';

class SentGameRequestCard extends StatelessWidget {
  const SentGameRequestCard({
    super.key,
    required this.invite,
    required this.isBusy,
    required this.onAccept,
    required this.onReject,
  });

  final GameInviteModel invite;

  /// Only the card being actioned, never all of them -- the bloc carries one
  /// shared loading flag, so the caller has to say which invite it belongs to.
  final bool isBusy;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  String get _modeLabel {
    switch (invite.gameMode) {
      case 'LIGHTNING':
      case 'LIGHTNING_MODE':
        return 'Lightning game';
      case 'FIRST_TO_X':
        return 'First to X game';
      default:
        return 'multiplayer game';
    }
  }

  /// Short and approximate on purpose: an invite is only interesting for a few
  /// minutes, so the useful question is "is this still warm?".
  String? get _age {
    final sentAt = invite.invitedAt;
    if (sentAt == null) return null;

    final elapsed = DateTime.now().difference(sentAt);
    if (elapsed.isNegative) return 'just now';
    if (elapsed.inSeconds < 60) return 'just now';
    if (elapsed.inMinutes < 60) return '${elapsed.inMinutes}m ago';
    if (elapsed.inHours < 24) return '${elapsed.inHours}h ago';
    return '${elapsed.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final age = _age;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF4FFCE)),
          color: const Color(0xFFF9EDBB),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFF8BA725),
              offset: Offset(1, 5),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 5),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            // Was an empty bordered Container -- a placeholder ring where the
            // avatar belonged, with the seed never passed in.
            AvatarWidget(
              seed: invite.inviterId?.toString() ??
                  invite.inviterUsername ??
                  '',
              width: 38.w,
              height: 38.w,
            ),
            SizedBox(width: 9.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StrokeText(
                    text: invite.inviterUsername ?? 'Someone',
                    textStyle: TextStyle(
                      color: const Color(0xFF0D468A),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: const Color(0xFFF4FFCE),
                    strokeWidth: 3,
                  ),
                  Text(
                    // Says which game, where it only ever said "a game request".
                    age == null
                        ? 'invited you to a $_modeLabel'
                        : 'invited you to a $_modeLabel · $age',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withValues(alpha: 0.6),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            if (isBusy)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF0D468A)),
                  ),
                ),
              )
            else ...[
              _CircleAction(
                asset: IconImageRoutes.redCircleClose,
                onTap: onReject,
                semanticLabel: 'Decline invite',
              ),
              SizedBox(width: 4.w),
              _CircleAction(
                asset: IconImageRoutes.greenCircleMark,
                onTap: onAccept,
                semanticLabel: 'Accept invite',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The two actions were 65w and 40w, so decline sat noticeably larger than
/// accept. Same size, same tap target.
class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.asset,
    required this.onTap,
    required this.semanticLabel,
  });

  final String asset;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Image.asset(asset, width: 42.w, height: 42.w),
        ),
      ),
    );
  }
}
