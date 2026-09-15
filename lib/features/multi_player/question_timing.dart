/// Seconds a multiplayer question stays on screen.
///
/// Was a bare `8` written separately into lightning_mode_question_screen and
/// first_to_x_question_screen. They drifted once already -- the container was
/// handed 6 while the controller ran on 8, so the countdown players watched
/// disagreed with the cutoff they were actually judged against.
const int kDefaultSecondsPerQuestion = 8;

/// The host cannot set a longer window than this.
const int kMaxSecondsPerQuestion = 12;

/// The shortest that is still playable -- below this a question cannot be read
/// and answered, whatever the host picks.
const int kMinSecondsPerQuestion = 4;

/// Accepts whatever the server sends and returns something safe to run a round
/// on. Null, unparseable or out-of-range values fall back to the default
/// rather than handing a Duration of 0 -- or 60 -- to the timer.
int resolveSecondsPerQuestion(dynamic value) {
  final seconds = value is int ? value : int.tryParse('${value ?? ''}');
  if (seconds == null) return kDefaultSecondsPerQuestion;
  if (seconds < kMinSecondsPerQuestion) return kMinSecondsPerQuestion;
  if (seconds > kMaxSecondsPerQuestion) return kMaxSecondsPerQuestion;
  return seconds;
}
