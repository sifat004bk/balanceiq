class TransactionSearchParams {
  final String? search;
  final String? category;
  final String? type;
  final String? startDate;
  final String? endDate;
  final double? minAmount;
  final double? maxAmount;
  final int? limit;

  TransactionSearchParams({
    this.search,
    this.category,
    this.type,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.limit,
  });

  TransactionSearchParams copyWith({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit,
  }) {
    return TransactionSearchParams(
      search: search ?? this.search,
      category: category ?? this.category,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      limit: limit ?? this.limit,
    );
  }
}
