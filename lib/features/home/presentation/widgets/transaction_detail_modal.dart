import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

/// A professional modal for viewing, updating, and deleting transactions
class TransactionDetailModal extends StatefulWidget {
  final Transaction transaction;
  final Function(Transaction)? onUpdate;
  final Function(Transaction)? onDelete;

  const TransactionDetailModal({
    super.key,
    required this.transaction,
    this.onUpdate,
    this.onDelete,
  });

  /// Shows the modal as a bottom sheet
  static Future<void> show(
    BuildContext context, {
    required Transaction transaction,
    Function(Transaction)? onUpdate,
    Function(Transaction)? onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailModal(
        transaction: transaction,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<TransactionDetailModal> createState() => _TransactionDetailModalState();
}

class _TransactionDetailModalState extends State<TransactionDetailModal> {
  bool _isEditMode = false;
  bool _isDeleting = false;

  // Form controllers
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late String _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;

  // Available categories
  final List<String> _categories = [
    AppStrings.transactions.categoryFood,
    AppStrings.transactions.categoryTransport,
    AppStrings.transactions.categoryShopping,
    AppStrings.transactions.categoryEntertainment,
    AppStrings.transactions.categoryBills,
    AppStrings.transactions.categoryHealthcare,
    AppStrings.transactions.categoryEducation,
    AppStrings.transactions.categorySalary,
    AppStrings.transactions.categoryInvestment,
    AppStrings.transactions.categoryGift,
    AppStrings.transactions.categoryOther,
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormValues();
  }

  void _initializeFormValues() {
    _descriptionController =
        TextEditingController(text: widget.transaction.description);
    _amountController = TextEditingController(
        text: widget.transaction.amount.toStringAsFixed(2));
    _selectedType = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    _selectedDate = widget.transaction.transactionDate;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        // Reset form values when canceling edit
        _initializeFormValues();
      }
    });
  }

  void _handleUpdate() {
    final updatedTransaction = Transaction(
      transactionId: widget.transaction.transactionId,
      type: _selectedType,
      amount:
          double.tryParse(_amountController.text) ?? widget.transaction.amount,
      category: _selectedCategory,
      description: _descriptionController.text,
      transactionDate: _selectedDate,
      createdAt: widget.transaction.createdAt,
      relevanceScore: widget.transaction.relevanceScore,
      totalMatches: widget.transaction.totalMatches,
    );

    widget.onUpdate?.call(updatedTransaction);
    Navigator.pop(context);
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error, size: 24),
            ),
            const SizedBox(width: 12),
            Text(AppStrings.transactions.deleteTransaction),
          ],
        ),
        content: Text(
          AppStrings.transactions.deleteConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppStrings.common.cancel,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Capture context references before async gap
              final navigator = Navigator.of(context);

              navigator.pop(); // Close dialog
              setState(() => _isDeleting = true);

              // Simulate delete with delay
              Future.delayed(const Duration(milliseconds: 500), () {
                widget.onDelete?.call(widget.transaction);
                if (!mounted) return;
                navigator.pop(); // Close modal
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(AppStrings.common.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = widget.transaction.isIncome;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _isDeleting
          ? SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.transactions.deleting,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Transaction icon
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                              size: 28,
                            ),
                          ).animate().fadeIn(duration: 300.ms).scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 300.ms),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isEditMode
                                      ? AppStrings.transactions.editTransaction
                                      : AppStrings
                                          .transactions.transactionDetails,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppStrings.transactions.transactionId}: #${widget.transaction.transactionId}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                              ],
                            )
                                .animate()
                                .fadeIn(delay: 100.ms, duration: 300.ms)
                                .slideX(
                                    begin: 0.1,
                                    end: 0,
                                    delay: 100.ms,
                                    duration: 300.ms),
                          ),
                          // Edit/Cancel button
                          IconButton(
                            onPressed: _toggleEditMode,
                            icon: Icon(
                              _isEditMode ? Icons.close : Icons.edit_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                            ),
                          ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                        ],
                      ),
                    ),

                    // Content
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isEditMode
                          ? _buildEditForm(isDark, colorScheme)
                          : _buildDetailView(isDark, colorScheme),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Delete button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _handleDelete,
                              icon: const Icon(Icons.delete_outline, size: 20),
                              label: Text(AppStrings.common.delete),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.error,
                                side: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 300.ms)
                              .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 400.ms,
                                  duration: 300.ms),
                          const SizedBox(width: 16),
                          // Update/Save button
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isEditMode ? _handleUpdate : _toggleEditMode,
                              icon: Icon(_isEditMode ? Icons.check : Icons.edit,
                                  size: 20),
                              label: Text(_isEditMode
                                  ? AppStrings.common.saveChanges
                                  : AppStrings.common.edit),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 450.ms, duration: 300.ms)
                              .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 450.ms,
                                  duration: 300.ms),
                        ],
                      ),
                    ),

                    // Safe area padding
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailView(bool isDark, ColorScheme colorScheme) {
    final transaction = widget.transaction;
    final isIncome = transaction.isIncome;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Amount
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isIncome
                    ? [
                        Colors.green.withValues(alpha: 0.1),
                        Colors.green.withValues(alpha: 0.05)
                      ]
                    : [
                        Colors.red.withValues(alpha: 0.1),
                        Colors.red.withValues(alpha: 0.05)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isIncome
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  isIncome
                      ? AppStrings.dashboard.income
                      : AppStrings.dashboard.expense,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  sl<CurrencyCubit>().formatAmountWithSign(transaction.amount,
                      isIncome: isIncome),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .scaleXY(begin: 0.95, end: 1, delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 20),

          // Details list
          _buildDetailRow(
            icon: Icons.description_outlined,
            label: AppStrings.transactions.description,
            value: transaction.description.isNotEmpty
                ? transaction.description
                : AppStrings.transactions.noDescription,
            delay: 250,
          ),
          _buildDetailRow(
            icon: Icons.category_outlined,
            label: AppStrings.transactions.category,
            value: transaction.category,
            delay: 300,
          ),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: AppStrings.transactions.date,
            value: DateFormat('EEEE, MMMM d, yyyy')
                .format(transaction.transactionDate),
            delay: 350,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required int delay,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 300.ms)
        .slideX(
            begin: 0.05,
            end: 0,
            delay: Duration(milliseconds: delay),
            duration: 300.ms);
  }

  Widget _buildEditForm(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Type
          _buildFormSection(
            label: AppStrings.transactions.transactionType,
            child: Row(
              children: [
                Expanded(
                  child: _buildTypeChip(
                      'INCOME', 'Income', Icons.arrow_downward, Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeChip(
                      'EXPENSE', 'Expense', Icons.arrow_upward, Colors.red),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Amount
          _buildFormSection(
            label: AppStrings.transactions.amount,
            child: TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '${sl<CurrencyCubit>().symbol} ',
                prefixStyle: TextStyle(
                  color: _selectedType == 'INCOME' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description
          _buildFormSection(
            label: AppStrings.transactions.description,
            child: TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: AppStrings.transactions.descriptionHint,
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Category
          _buildFormSection(
            label: AppStrings.transactions.category,
            child: DropdownButtonFormField<String>(
              value: _categories.contains(_selectedCategory)
                  ? _selectedCategory
                  : _categories.last,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
          ),

          const SizedBox(height: 20),

          // Date
          _buildFormSection(
            label: AppStrings.transactions.date,
            child: InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).hintColor,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0, duration: 300.ms);
  }

  Widget _buildFormSection({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTypeChip(String type, String label, IconData icon, Color color) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Theme.of(context).hintColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Theme.of(context).hintColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
