import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/payment/process_payment_usecase.dart';
import '../../../domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessPaymentUsecase _processPaymentUsecase;

  PaymentBloc({
    required ProcessPaymentUsecase processPaymentUsecase,
  })  : _processPaymentUsecase = processPaymentUsecase,
        super(PaymentInitial()) {
    on<ProcessPaymentRequested>(_onProcessPaymentRequested);
    on<PaymentCompleted>(_onPaymentCompleted);
    on<PaymentError>(_onPaymentError);
    on<ResetPaymentState>(_onResetPaymentState);
  }

  Future<void> _onProcessPaymentRequested(
    ProcessPaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentInProgress());

    try {
      final result = await _processPaymentUsecase.call(event.request);

      result.fold(
        (failure) => emit(PaymentFailed(failure.message)),
        (payment) {
          if (payment.status == 'pending' && payment.metadata.additionalData?['requiresRedirect'] == true) {
            emit(PaymentSuccess(
              paymentId: payment.id,
              redirectUrl: payment.metadata.additionalData?['redirectUrl'],
              payment: payment,
            ));
          } else {
            emit(PaymentSuccess(
              paymentId: payment.id,
              payment: payment,
            ));
          }
        },
      );
    } catch (e) {
      emit(PaymentFailed('Payment processing failed: ${e.toString()}'));
    }
  }

  void _onPaymentCompleted(PaymentCompleted event, Emitter<PaymentState> emit) {
    emit(PaymentSuccess(
      paymentId: event.paymentId,
      redirectUrl: event.redirectUrl,
    ));
  }

  void _onPaymentError(PaymentError event, Emitter<PaymentState> emit) {
    emit(PaymentFailed(event.errorMessage));
  }

  void _onResetPaymentState(ResetPaymentState event, Emitter<PaymentState> emit) {
    emit(PaymentInitial());
  }
}
