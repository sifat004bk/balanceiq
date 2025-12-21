import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_filter_state.dart';

class TransactionFilterCubit extends Cubit<TransactionFilterState> {
  TransactionFilterCubit() : super(const TransactionFilterState());

  void updateSearch(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void updateType(String? type) {
    emit(state.copyWith(
      selectedType: type,
      clearType: type == null,
    ));
  }

  void updateCategory(String? category) {
    emit(state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
    ));
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    emit(state.copyWith(
      startDate: start,
      endDate: end,
      clearDateRange: start == null && end == null,
    ));
  }

  void clearAllFilters() {
    emit(const TransactionFilterState());
  }
}
