/// Maps a game mode's display name onto the code the API expects.
///
/// The screens carry human labels ("Lightning Mode", "First to X"); the
/// backend wants uppercase, underscore-delimited codes -- the same shape as
/// the victoryCondition values it already sends back (LIGHTNING, FIRST_TO_X)
/// and as the MULTIPLAYER_GROUP constant invites used to hardcode.
///
/// The server also accepts the code coming straight back in, so a value that
/// is already a code passes through untouched.
String gameModeCode(String? displayName) {
  switch ((displayName ?? '').trim().toLowerCase()) {
    case 'lightning mode':
    case 'lightning':
    case 'lightning_mode':
      return 'LIGHTNING_MODE';
    case 'first to x':
    case 'first_to_x':
      return 'FIRST_TO_X';
    case 'time-based mode':
    case 'time based mode':
    case 'time_based_mode':
      return 'TIME_BASED_MODE';
    case 'survival mode':
    case 'survival_mode':
      return 'SURVIVAL_MODE';
    default:
      // Unknown mode: fall back to what every invite sent before this existed,
      // so an invite still goes out rather than failing validation.
      return 'MULTIPLAYER_GROUP';
  }
}
