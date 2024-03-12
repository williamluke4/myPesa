import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/transaction.dart';

enum AmountComparison { equal, less, greater, between }

extension AmountComparisonExt on AmountComparison {
  String get name {
    switch (this) {
      case AmountComparison.equal:
        return 'Equal To';
      case AmountComparison.less:
        return 'Less Than';
      case AmountComparison.greater:
        return 'Greater Than';
      case AmountComparison.between:
        return 'Between';
    }
  }
}

class AdvancedSearchCriteria {
  AdvancedSearchCriteria({
    this.query,
    this.transactionTypes,
    this.amountBounds,
    this.amountComparison = AmountComparison.equal,
    this.startDate,
    this.endDate,
    this.categoryIds,
  });
  String? query;
  List<TransactionType>? transactionTypes;
  List<double>? amountBounds;
  AmountComparison amountComparison;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? categoryIds;
}

class AdvancedSearchForm extends StatefulWidget {
  const AdvancedSearchForm({super.key, required this.onSearch, this.initial});
  final void Function(AdvancedSearchCriteria criteria) onSearch;
  final AdvancedSearchCriteria? initial;

  @override
  AdvancedSearchFormState createState() => AdvancedSearchFormState();
}

class AdvancedSearchFormState extends State<AdvancedSearchForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();
  final ValueNotifier<AmountComparison> _amountComparisonNotifier =
      ValueNotifier(AmountComparison.equal);
  List<TransactionType> _selectedTransactionTypes = [];
  List<String> _selectedCategoryIds = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Initialize state with widget.initial values if they exist
    _queryController.text = widget.initial?.query ?? '';
    _amountController.text =
        widget.initial?.amountBounds?.first.toString() ?? '';
    _minAmountController.text =
        widget.initial?.amountBounds?.first.toString() ?? '';
    _maxAmountController.text =
        widget.initial?.amountBounds?.last.toString() ?? '';
    _amountComparisonNotifier.value =
        widget.initial?.amountComparison ?? AmountComparison.equal;

    _selectedTransactionTypes = widget.initial?.transactionTypes ?? [];
    _selectedCategoryIds = widget.initial?.categoryIds ?? [];
    _startDate = widget.initial?.startDate;
    _endDate = widget.initial?.endDate;
  }

  @override
  void dispose() {
    _queryController.dispose();
    _amountController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    _amountComparisonNotifier.dispose();
    super.dispose();
  }

  AdvancedSearchCriteria _buildCriteria() {
    List<double>? amountBounds;
    if (_amountComparisonNotifier.value == AmountComparison.between) {
      amountBounds = [
        double.parse(_minAmountController.text),
        double.parse(_maxAmountController.text),
      ];
    } else if (_amountController.text.isNotEmpty) {
      amountBounds = [double.parse(_amountController.text)];
    }

    return AdvancedSearchCriteria(
      query: _queryController.text,
      transactionTypes: _selectedTransactionTypes,
      amountBounds: amountBounds,
      amountComparison: _amountComparisonNotifier.value,
      startDate: _startDate,
      endDate: _endDate,
      categoryIds: _selectedCategoryIds,
    );
  }

  Widget _buildAmountField() {
    switch (_amountComparisonNotifier.value) {
      case AmountComparison.between:
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minAmountController,
                decoration: const InputDecoration(labelText: 'Minimum Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _maxAmountController,
                decoration: const InputDecoration(labelText: 'Maximum Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        );
      case AmountComparison.equal:
      case AmountComparison.less:
      case AmountComparison.greater:
        return TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        );
    }
  }

  Widget _transactionTypeSelector() {
    return MultiSelectDialogField<TransactionType>(
      items: TransactionType.values
          .map((type) => MultiSelectItem(type, type.name))
          .toList(),
      title: const Text('Transaction Type'),
      buttonText: const Text('Transaction Type'),
      buttonIcon: const Icon(Icons.import_export_rounded),
      selectedColor: Theme.of(context).focusColor,
      itemsTextStyle: Theme.of(context).textTheme.bodyMedium,
      selectedItemsTextStyle: Theme.of(context).textTheme.bodyMedium,
      initialValue: _selectedTransactionTypes,
      onConfirm: (values) {
        _selectedTransactionTypes = values;
      },
    );
  }

  Widget _categorySelector(DatabaseState state) {
    return MultiSelectDialogField<String>(
      items: state.categories
          .map((category) => MultiSelectItem(category.id, category.name))
          .toList(),
      title: const Text('Categories'),
      buttonText: const Text('Categories'),
      searchable: true,
      initialValue: _selectedCategoryIds,
      buttonIcon: const Icon(Icons.category),
      selectedColor: Theme.of(context).focusColor,
      itemsTextStyle: Theme.of(context).textTheme.bodyMedium,
      selectedItemsTextStyle: Theme.of(context).textTheme.bodyMedium,
      onConfirm: (values) {
        _selectedCategoryIds = values;
      },
    );
  }

  Widget _dateRangePicker() {
    return ElevatedButton(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDateRange: _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
        );
        if (picked != null) {
          setState(() {
            _startDate = picked.start;
            _endDate = picked.end;
          });
        }
      },
      child: Text(
        _startDate != null && _endDate != null
            // ignore: lines_longer_than_80_chars
            ? 'Date Range: ${_startDate!.toIso8601String().split('T').first} - ${_endDate!.toIso8601String().split('T').first}'
            : 'Select Date Range',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      labelText: 'Search transactions',
                      hintText: 'Enter recipient, amount, or notes',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<AmountComparison>(
                    valueListenable: _amountComparisonNotifier,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          DropdownButtonFormField<AmountComparison>(
                            decoration: const InputDecoration(
                              labelText: 'Amount Comparison',
                            ),
                            value: value,
                            onChanged: (AmountComparison? newValue) {
                              if (newValue != null) {
                                _amountComparisonNotifier.value = newValue;
                              }
                            },
                            items: AmountComparison.values
                                .map((AmountComparison comparison) {
                              return DropdownMenuItem<AmountComparison>(
                                value: comparison,
                                child: Text(comparison.name),
                              );
                            }).toList(),
                          ),
                          _buildAmountField(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // Transaction Types Selector
                  const SizedBox(height: 10),
                  _transactionTypeSelector(),
                  const SizedBox(height: 10),
                  _categorySelector(state),
                  const SizedBox(height: 10),
                  _dateRangePicker(),
                  const SizedBox(height: 20),
                  // Search and Reset Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.onSearch(_buildCriteria());
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Search'),
                      ),
                      TextButton(
                        onPressed: _resetForm,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _resetForm() {
    _queryController.clear();
    _amountController.clear();
    _minAmountController.clear();
    _maxAmountController.clear();
    _amountComparisonNotifier.value = AmountComparison.equal;
    _selectedTransactionTypes = [];
    _selectedCategoryIds = [];
    _startDate = null;
    _endDate = null;
    // Reset other stateful widgets and fields as necessary
  }
}
