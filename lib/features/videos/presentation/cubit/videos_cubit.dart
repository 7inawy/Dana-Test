import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/repo/videos_repo.dart';
import 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  final VideosRepo repo;

  VideosCubit(this.repo) : super(const VideosInitial());

  Future<void> load() async {
    emit(const VideosLoading());
    try {
      final videos = await repo.getVideos();
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideosError(ErrorMapper.message(e)));
    }
  }

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      emit(const VideosSearchLoaded([]));
      return;
    }
    emit(const VideosLoading());
    try {
      final results = await repo.search(q);
      emit(VideosSearchLoaded(results));
    } catch (e) {
      emit(VideosError(ErrorMapper.message(e)));
    }
  }
}
