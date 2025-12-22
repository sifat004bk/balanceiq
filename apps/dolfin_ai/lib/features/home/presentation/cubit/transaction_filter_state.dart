import 'package:equatable/equatable.dart';

class TransactionFilterState extends Equatable {
  final String searchQuery;
  final String? selectedType;
  final String? selectedCategory;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionFilterState({
    this.searchQuery = '',
    this.selectedType,
    this.selectedCategory,
    this.startDate,
    this.endDate,
  });

  TransactionFilterState copyWith({
    String? searchQuery,
    String? selectedType,
    String? selectedCategory,
    DateTime? startDate,
    DateTime? endDate,
    bool clearType = false,
    bool clearCategory = false,
    bool clearDateRange = false,
  }) {
    return TransactionFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      startDate: clearDateRange ? null : (startDate ?? this.startDate),
      endDate: clearDateRange ? null : (endDate ?? this.endDate),
    );
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      selectedType != null ||
      selectedCategory != null ||
      startDate != null;

  @override
  List<Object?> get props => [
        searchQuery,
        selectedType,
        selectedCategory,
        startDate,
        endDate,
      ];
}
