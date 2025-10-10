part of 'multiplayer_bloc.dart';

class MultiplayerState extends Equatable{
  final bool isLoadingCreateGameRoom;
  final bool hasCreatedGameRoom;
  final bool isLoadingConfigureGameRoom;
  final bool hasConfiguredGameRoom;
  final bool isJoiningRoom;
  final bool hasJoinedRoom;
  final bool isLoadingGameInvite;
  final bool hasInvitedUser;
  final bool isFetchingListOfGameInvite;
  final bool hasFetchedGameInvite;
  final bool isLoadingAcceptInvite;
  final bool hasAcceptedInvite;
  final bool isLoadingRejectInvite;
  final bool hasRejectedInvite;
  final bool isLeavingRoom;
  final bool hasLeaveRoom;
  final bool isLoadingKickOut;
  final bool hasKickedOut;
  final dynamic inviteCount;

  final CreateGameRoomModel createGameRoomResponse;
  final List<GameInviteModel> listOfInvite;

  const MultiplayerState(
      {
        required this.isLoadingCreateGameRoom,
        required this.hasCreatedGameRoom,
        required this.createGameRoomResponse,
        required this.isLoadingConfigureGameRoom,
        required this.hasConfiguredGameRoom,
        required this.isJoiningRoom,
        required this.hasJoinedRoom,
        required this.isLoadingGameInvite,
        required this.hasInvitedUser,
        required this.isFetchingListOfGameInvite,
        required this.hasFetchedGameInvite,
        required this.listOfInvite,
        required this.isLoadingAcceptInvite,
        required this.hasAcceptedInvite,
        required this.isLoadingRejectInvite,
        required this.hasRejectedInvite,
        required this.inviteCount,
        required this.isLeavingRoom,
        required this.hasLeaveRoom,
        required this.isLoadingKickOut,
        required this.hasKickedOut,
      });

  factory MultiplayerState.initial(){
    return MultiplayerState(
        isLoadingCreateGameRoom: false,
        hasCreatedGameRoom: false,
        isLoadingConfigureGameRoom: false,
        hasConfiguredGameRoom: false,
        createGameRoomResponse: CreateGameRoomModel.fromJson({}),
        isJoiningRoom: false,
        hasJoinedRoom: false,
        isLoadingGameInvite: false,
        hasInvitedUser: false,
        isFetchingListOfGameInvite: false,
        hasFetchedGameInvite: false,
       listOfInvite: [],
      isLoadingAcceptInvite: false,
      hasAcceptedInvite: false,
      isLoadingRejectInvite: false,
      hasRejectedInvite: false,
      isLeavingRoom: false,
      hasLeaveRoom: false,
      isLoadingKickOut: false,
      hasKickedOut: false,
      inviteCount: 0,
    );
  }

MultiplayerState copyWith(
      {
        bool? isLoadingCreateGameRoom,
        bool? hasCreatedGameRoom,
        bool? isLoadingConfigureGameRoom,
        bool? hasConfiguredGameRoom,
        bool? isJoiningRoom,
        bool? hasJoinedRoom,
        bool? isLoadingGameInvite,
        bool? hasInvitedUser,
        bool? isFetchingListOfGameInvite,
        bool? hasFetchedGameInvite,
        List<GameInviteModel>? listOfInvite,
        bool? isLoadingAcceptInvite,
        bool? hasAcceptedInvite,
        bool? isLoadingRejectInvite,
        bool? hasRejectedInvite,
        bool? isLeavingRoom,
        bool? hasLeaveRoom,
        bool? isLoadingKickOut,
        bool? hasKickedOut,
        int? inviteCount,
        CreateGameRoomModel? createGameRoomResponse
      }) {
    return MultiplayerState(
        isLoadingCreateGameRoom: isLoadingCreateGameRoom ?? this.isLoadingCreateGameRoom,
        hasCreatedGameRoom: hasCreatedGameRoom ?? this.hasCreatedGameRoom,
        isLoadingConfigureGameRoom: isLoadingConfigureGameRoom ?? this.isLoadingConfigureGameRoom,
        hasConfiguredGameRoom: hasConfiguredGameRoom ?? this.hasConfiguredGameRoom,
        createGameRoomResponse: createGameRoomResponse??this.createGameRoomResponse,
        isJoiningRoom: isJoiningRoom ?? this.isJoiningRoom,
        hasJoinedRoom: hasJoinedRoom ?? this.hasJoinedRoom,
        isLoadingGameInvite: isLoadingGameInvite ?? this.isLoadingGameInvite,
        hasInvitedUser: hasInvitedUser ?? this.hasInvitedUser,
        isFetchingListOfGameInvite: isFetchingListOfGameInvite ?? this.isFetchingListOfGameInvite,
        hasFetchedGameInvite: hasFetchedGameInvite ?? this.hasFetchedGameInvite,
        listOfInvite: listOfInvite ?? this.listOfInvite,
        isLoadingAcceptInvite: isLoadingAcceptInvite ?? this.isLoadingAcceptInvite,
        hasAcceptedInvite: hasAcceptedInvite ?? this.hasAcceptedInvite,
        isLoadingRejectInvite: isLoadingRejectInvite ?? this.isLoadingRejectInvite,
        hasRejectedInvite: hasRejectedInvite ?? this.hasRejectedInvite,
        isLeavingRoom: isLeavingRoom ?? this.isLeavingRoom,
        hasLeaveRoom: hasLeaveRoom ?? this.hasLeaveRoom,
        isLoadingKickOut: isLoadingKickOut ?? this.isLoadingKickOut,
        hasKickedOut: hasKickedOut ?? this.hasKickedOut,
        inviteCount: inviteCount ?? this.inviteCount,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingCreateGameRoom,
    hasCreatedGameRoom,
    isLoadingConfigureGameRoom,
    hasConfiguredGameRoom,
    isJoiningRoom,
    hasJoinedRoom,
    isLoadingGameInvite,
    hasInvitedUser,
    isFetchingListOfGameInvite,
    hasFetchedGameInvite,
    createGameRoomResponse,
    listOfInvite,
    isLoadingAcceptInvite,
    hasAcceptedInvite,
    isLoadingRejectInvite,
    hasRejectedInvite,
    isLeavingRoom,
    hasLeaveRoom,
    isLoadingKickOut,
    hasKickedOut,
    inviteCount,
  ];
}

