part of 'payment_bloc.dart';

import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentInProgress extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentId;
  final String? redirectUrl;
  final PaymentEntity? payment;

  const PaymentSuccess({
    required this.paymentId,
    this.redirectUrl,
    this.payment,
  });

  @override
  List<Object?> get props => [paymentId, redirectUrl, payment];
}

class PaymentFailed extends PaymentState {
  final String errorMessage;

  const PaymentFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PaymentEscrowHeld extends PaymentState {
  final String escrowId;
  final double amount;

  const PaymentEscrowHeld({
    required this.escrowId,
    required this.amount,
  });

  @override
  List<Object?> get props => [escrowId, amount];
}
