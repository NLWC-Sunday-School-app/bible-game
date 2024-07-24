part of 'user_bloc.dart';


class UserState extends Equatable {
  final bool isLoadingAds;
  final List<GameAds>? adContent;
  final List<PilgrimProgressLevelData>? pilgrimProgressDetails;

  const UserState({
    this.isLoadingAds = false,
    this.adContent,
    this.pilgrimProgressDetails,

  });

  UserState copyWith({
    bool? isLoadingAds,
    List<GameAds>? adContent,
    List<PilgrimProgressLevelData>? pilgrimProgressDetails,

  }) {
    return UserState(
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      adContent: adContent ?? this.adContent,
      pilgrimProgressDetails: pilgrimProgressDetails ?? this.pilgrimProgressDetails,

    );
  }

  @override
  List<Object?> get props => [
    isLoadingAds,
    adContent,
    pilgrimProgressDetails,

  ];
}

