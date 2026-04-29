import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';

abstract class PaymentChildrenState {
  const PaymentChildrenState();
}

class PaymentChildrenInitial extends PaymentChildrenState {
  const PaymentChildrenInitial();
}

class PaymentChildrenLoading extends PaymentChildrenState {
  const PaymentChildrenLoading();
}

class PaymentChildrenLoaded extends PaymentChildrenState {
  final List<ParentChildModel> children;

  const PaymentChildrenLoaded(this.children);
}

class PaymentChildrenError extends PaymentChildrenState {
  final String message;

  const PaymentChildrenError(this.message);
}

