part of 'payment_bloc.dart';

import 'package:equatable/equatable.dart';
import '../../../domain/repositories/payment_repository.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessPaymentRequested extends PaymentEvent {
  final PaymentRequest request;

  const ProcessPaymentRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class PaymentCompleted extends PaymentEvent {
  final String paymentId;
  final String? redirectUrl;

  const PaymentCompleted({required this.paymentId, this.redirectUrl});

  @override
  List<Object?> get props => [paymentId, redirectUrl];
}

class PaymentError extends PaymentEvent {
  final String errorMessage;

  const PaymentError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ResetPaymentState extends PaymentEvent {}
