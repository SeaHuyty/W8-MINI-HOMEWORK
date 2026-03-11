import 'package:flutter/material.dart';
import 'package:mini_homework/model/async_value.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  AsyncValue<List<Song>> _songs = const AsyncLoading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  AsyncValue<List<Song>> get songs => _songs;

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    // 1 - Fetch songs
    _songs = const AsyncLoading();

    // 2 - notify listeners
    notifyListeners();

    try {
      final fetchSongs = await songRepository.fetchSongs();

      _songs = AsyncData(fetchSongs);
      notifyListeners();
      
    } catch (e, stackTrace) {
      _songs = AsyncError(e, stackTrace);
      notifyListeners();
    }
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
