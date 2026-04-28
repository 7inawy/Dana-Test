import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/doctors_list_remote_data_source.dart';
import 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  DoctorsListCubit(this._remote) : super(const DoctorsListInitial());

  final DoctorsListRemoteDataSource _remote;

  Future<void> load() async {
    emit(const DoctorsListLoading());
    try {
      final list = await _remote.fetchDoctors();
      emit(DoctorsListLoaded(list));
    } catch (e) {
      emit(DoctorsListError(e.toString()));
    }
  }
}
