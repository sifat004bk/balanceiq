import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<Transaction> transactions;
  final bool hasReachedMax;
  final bool isMoreLoading;

  const TransactionsLoaded({
    required this.transactions,
    required this.hasReachedMax,
    this.isMoreLoading = false,
  });

  TransactionsLoaded copyWith({
    List<Transaction>? transactions,
    bool? hasReachedMax,
    bool? isMoreLoading,
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
    );
  }

  @override
  List<Object> get props => [transactions, hasReachedMax, isMoreLoading];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError(this.message);

  @override
  List<Object> get props => [message];
}
