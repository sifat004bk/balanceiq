import 'package:currency_picker/currency_picker.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CurrencySelectorSheet extends StatefulWidget {
  final CurrencyService currencyService;
  final Function(Currency) onSelect;
  final List<String> favorites;

  const CurrencySelectorSheet({
    super.key,
    required this.currencyService,
    required this.onSelect,
    this.favorites = const ['BDT', 'USD', 'EUR', 'GBP', 'INR'],
  });

  static void show(BuildContext context,
      {required Function(Currency) onSelect}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelectorSheet(
        currencyService: CurrencyService(),
        onSelect: onSelect,
      ),
    );
  }

  @override
  State<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();
}

class _CurrencySelectorSheetState extends State<CurrencySelectorSheet> {
  late List<Currency> _allCurrencies;
  late List<Currency> _filteredCurrencies;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _allCurrencies = widget.currencyService.getAll();
    _sortCurrencies();
    _filteredCurrencies = List.from(_allCurrencies);
    _searchController.addListener(_onSearchChanged);
  }

  void _sortCurrencies() {
    // Sort by Favorites first, then Name
    _allCurrencies.sort((a, b) {
      final aFav = widget.favorites.contains(a.code);
      final bFav = widget.favorites.contains(b.code);
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return a.name.compareTo(b.name);
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = List.from(_allCurrencies);
      } else {
        _filteredCurrencies = _allCurrencies.where((currency) {
          return currency.name.toLowerCase().contains(query) ||
              currency.code.toLowerCase().contains(query) ||
              currency.symbol.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyCubit = context.watch<CurrencyCubit>();
    final currentCode = currencyCubit.state.currencyCode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Currency',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.x, color: theme.hintColor),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search currency',
                prefixIcon: Icon(LucideIcons.search, color: theme.hintColor),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: _filteredCurrencies.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 72,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                final isSelected = currency.code == currentCode;

                return InkWell(
                  onTap: () {
                    widget.onSelect(currency);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        // Flag (using text as simpler fallback if Utils not available,
                        // but package usually provides CurrencyUtils.currencyToEmoji(currency))
                        Text(
                          CurrencyUtils.currencyToEmoji(currency),
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currency.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${currency.code} (${currency.symbol})',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            LucideIcons.check,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
