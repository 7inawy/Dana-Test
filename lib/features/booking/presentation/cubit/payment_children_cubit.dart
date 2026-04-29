import 'package:dana/core/errors/error_mapper.dart';
import 'package:dana/features/booking/presentation/cubit/payment_children_state.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentChildrenCubit extends Cubit<PaymentChildrenState> {
  final ParentProfileRepository repo;

  PaymentChildrenCubit(this.repo) : super(const PaymentChildrenInitial());

  Future<void> load() async {
    emit(const PaymentChildrenLoading());
    try {
      final me = await repo.getMe();
      emit(PaymentChildrenLoaded(me.children));
    } catch (e) {
      emit(PaymentChildrenError(ErrorMapper.message(e)));
    }
  }
}

