import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bible_game/features/memory_verses/model/memory_verse.dart';

class MemoryVersesState extends Equatable {
  final bool loading;
  final List<VerseTopic> topics;
  final Set<String> memorizedRefs;

  const MemoryVersesState({
    this.loading = true,
    this.topics = const [],
    this.memorizedRefs = const {},
  });

  MemoryVersesState copyWith({
    bool? loading,
    List<VerseTopic>? topics,
    Set<String>? memorizedRefs,
  }) {
    return MemoryVersesState(
      loading: loading ?? this.loading,
      topics: topics ?? this.topics,
      memorizedRefs: memorizedRefs ?? this.memorizedRefs,
    );
  }

  int memorizedCountFor(VerseTopic topic) =>
      topic.verses.where((v) => memorizedRefs.contains(v.reference)).length;

  @override
  List<Object?> get props => [loading, topics, memorizedRefs];
}

class MemoryVersesCubit extends Cubit<MemoryVersesState> {
  static const String _storageKey = 'memorized_verse_refs';

  MemoryVersesCubit() : super(const MemoryVersesState());

  Future<void> load() async {
    final topics = await MemoryVerseData.loadTopics();
    final stored = GetStorage().read<List<dynamic>>(_storageKey) ?? [];
    emit(state.copyWith(
      loading: false,
      topics: topics,
      memorizedRefs: stored.map((e) => e.toString()).toSet(),
    ));
  }

  Future<void> toggleMemorized(String reference) async {
    final refs = Set<String>.from(state.memorizedRefs);
    if (!refs.remove(reference)) {
      refs.add(reference);
    }
    emit(state.copyWith(memorizedRefs: refs));
    await GetStorage().write(_storageKey, refs.toList());
  }
}
