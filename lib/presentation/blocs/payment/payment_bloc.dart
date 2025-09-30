import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/payment/process_payment_usecase.dart';
import 'payment_event.dart' as payment_event;
import 'payment_state.dart' as payment_state;

class PaymentBloc extends Bloc<payment_event.PaymentEvent, payment_state.PaymentState> {
  final ProcessPaymentUsecase _processPaymentUsecase;

  PaymentBloc({
    required ProcessPaymentUsecase processPaymentUsecase,
  })  : _processPaymentUsecase = processPaymentUsecase,
        super(payment_state.PaymentInitial()) {
    on<payment_event.ProcessPaymentRequested>(_onProcessPaymentRequested);
    on<payment_event.PaymentCompleted>(_onPaymentCompleted);
    on<payment_event.PaymentError>(_onPaymentError);
    on<payment_event.ResetPaymentState>(_onResetPaymentState);
  }

  Future<void> _onProcessPaymentRequested(
    payment_event.ProcessPaymentRequested event,
    Emitter<payment_state.PaymentState> emit,
  ) async {
    emit(payment_state.PaymentInProgress());

    try {
      final result = await _processPaymentUsecase.call(event.request);

      result.fold(
        (failure) => emit(payment_state.PaymentFailed(failure.message)),
        (payment) {
          if (payment.status == 'pending' && payment.metadata.additionalData?['requiresRedirect'] == true) {
            emit(payment_state.PaymentSuccess(
              paymentId: payment.id,
              redirectUrl: payment.metadata.additionalData?['redirectUrl'],
              payment: payment,
            ));
          } else {
            emit(payment_state.PaymentSuccess(
              paymentId: payment.id,
              payment: payment,
            ));
          }
        },
      );
    } catch (e) {
      emit(payment_state.PaymentFailed('Payment processing failed: ${e.toString()}'));
    }
  }

  void _onPaymentCompleted(payment_event.PaymentCompleted event, Emitter<payment_state.PaymentState> emit) {
    emit(payment_state.PaymentSuccess(
      paymentId: event.paymentId,
      redirectUrl: event.redirectUrl,
    ));
  }

  void _onPaymentError(payment_event.PaymentError event, Emitter<payment_state.PaymentState> emit) {
    emit(payment_state.PaymentFailed(event.errorMessage));
  }

  void _onResetPaymentState(payment_event.ResetPaymentState event, Emitter<payment_state.PaymentState> emit) {
    emit(payment_state.PaymentInitial());
  }
}
