import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resumable_room.dart';

/// The way back into a game this player created or joined earlier, shown
/// above the create and join cards while that room is still open.
class ResumeGameCard extends StatelessWidget {
  const ResumeGameCard({
    super.key,
    required this.room,
    required this.isLoading,
    required this.onResume,
    required this.onDiscard,
  });

  final ResumableRoom room;
  final bool isLoading;
  final VoidCallback onResume;
  final VoidCallback onDiscard;

  static const _blue = Color(0xFF014CA3);
  static const _green = Color(0xFF19A44B);

  String get _title {
    if (!room.isMember) return 'Rejoin your game';
    if (room.details.isActive) return 'Your game is in progress';
    if (room.details.isFinished && room.isHost) return 'Play your game again';
    return 'Resume your game';
  }

  String get _subtitle {
    final parts = <String>[
      if (room.modeLabel.isNotEmpty) room.modeLabel,
      'Code ${room.inviteCode}',
      if (room.details.isWaiting && room.details.players.isNotEmpty)
        '${room.details.players.length} '
            '${room.details.players.length == 1 ? 'player' : 'players'} in',
    ];
    return parts.join('  ·  ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: isLoading ? null : onResume,
          child: Container(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 4.w, 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(width: 2.w, color: _green),
            ),
            child: Row(
              children: [
                Container(
                  height: 36.r,
                  width: 36.r,
                  decoration: const BoxDecoration(
                    color: _green,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            height: 16.r,
                            width: 16.r,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(Icons.play_arrow_rounded,
                            size: 22.sp, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          color: _blue,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Leave this game',
                  // Compact: the Multiplayer tab is a fixed-height column and
                  // the default 48px target makes this the tallest card in it.
                  visualDensity: VisualDensity.compact,
                  constraints: BoxConstraints.tightFor(width: 36.r, height: 36.r),
                  padding: EdgeInsets.zero,
                  onPressed: isLoading ? null : onDiscard,
                  icon: Icon(Icons.close_rounded,
                      size: 20.sp,
                      color: Colors.black.withValues(alpha: 0.45)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
