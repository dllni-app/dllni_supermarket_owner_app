import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/store_owner_operations_service.dart';
import '../../data/models/get_products_model.dart';

class ProductOptionsEditorDialog extends StatefulWidget {
  final GetProductsModelDataItem product;

  const ProductOptionsEditorDialog({
    super.key,
    required this.product,
  });

  @override
  State<ProductOptionsEditorDialog> createState() =>
      _ProductOptionsEditorDialogState();
}

class _ProductOptionsEditorDialogState
    extends State<ProductOptionsEditorDialog> {
  late final List<_OptionDraft> _options;
  bool _saving = false;
  String? _error;

  StoreOwnerOperationsService get _operations =>
      StoreOwnerOperationsService(getIt<DioNetwork>());

  @override
  void initState() {
    super.initState();
    _options = (widget.product.options ?? const [])
        .map(_OptionDraft.fromModel)
        .toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ø®ÙŠØ§Ø±Ø§Øª Ø§Ù„Ù…Ù†ØªØ¬'),
          const SizedBox(height: 4),
          Text(
            widget.product.name ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      content: SizedBox(
        width: 650,
        height: MediaQuery.sizeOf(context).height * .68,
        child: Column(
          children: [
            Expanded(
              child: _options.isEmpty
                  ? const Center(
                      child: Text(
                        'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ø¬Ù…ÙˆØ¹Ø§Øª Ø®ÙŠØ§Ø±Ø§Øª. Ø£Ø¶Ù Ù…Ø¬Ù…ÙˆØ¹Ø© Ù…Ø«Ù„ Ø§Ù„Ø­Ø¬Ù… Ø£Ùˆ Ø§Ù„Ù†ÙƒÙ‡Ø©.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _OptionCard(
                        key: ValueKey(_options[index]),
                        draft: _options[index],
                        onDelete: () {
                          setState(() => _options.removeAt(index));
                        },
                        onChanged: () => setState(() {}),
                      ),
                    ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _saving
                  ? null
                  : () {
                      setState(() {
                        _options.add(_OptionDraft.empty());
                        _error = null;
                      });
                    },
              icon: const Icon(Icons.add),
              label: const Text('Ø¥Ø¶Ø§ÙØ© Ù…Ø¬Ù…ÙˆØ¹Ø© Ø®ÙŠØ§Ø±Ø§Øª'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Ø¥Ù„ØºØ§Ø¡'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save_outlined),
          label: const Text('Ø­ÙØ¸ Ø§Ù„Ø®ÙŠØ§Ø±Ø§Øª'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final productId = widget.product.id;
    if (productId == null) return;

    for (final option in _options) {
      if (option.name.trim().isEmpty) {
        setState(() => _error = 'Ø§Ø³Ù… Ù…Ø¬Ù…ÙˆØ¹Ø© Ø§Ù„Ø®ÙŠØ§Ø±Ø§Øª Ù…Ø·Ù„ÙˆØ¨');
        return;
      }
      if (option.minSelections < 0 ||
          option.maxSelections < option.minSelections ||
          option.maxSelections < 1) {
        setState(
          () => _error =
              'ØªØ­Ù‚Ù‚ Ù…Ù† Ø§Ù„Ø­Ø¯ Ø§Ù„Ø£Ø¯Ù†Ù‰ ÙˆØ§Ù„Ø£Ù‚ØµÙ‰ Ù„Ù„Ø§Ø®ØªÙŠØ§Ø±Ø§Øª ÙÙŠ ÙƒÙ„ Ù…Ø¬Ù…ÙˆØ¹Ø©',
        );
        return;
      }
      if (option.modifiers.any((item) => item.name.trim().isEmpty)) {
        setState(() => _error = 'Ø§Ø³Ù… ÙƒÙ„ Ø®ÙŠØ§Ø± Ù…Ø·Ù„ÙˆØ¨');
        return;
      }
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _operations.updateProductOptions(
        productId: productId,
        options: _options.map((item) => item.toPayload()).toList(),
      );
      if (!mounted) return;
      AppToast.showToast(
        context: context,
        message: 'ØªÙ… ØªØ­Ø¯ÙŠØ« Ø®ÙŠØ§Ø±Ø§Øª Ø§Ù„Ù…Ù†ØªØ¬',
        type: ToastificationType.success,
      );
      Navigator.pop(context, true);
    } on StoreOwnerOperationException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _OptionCard extends StatelessWidget {
  final _OptionDraft draft;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _OptionCard({
    super.key,
    required this.draft,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: draft.name,
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ø³Ù… Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø©',
                      hintText: 'Ù…Ø«Ø§Ù„: Ø§Ù„Ø­Ø¬Ù…',
                    ),
                    onChanged: (value) => draft.name = value,
                  ),
                ),
                IconButton(
                  tooltip: 'Ø­Ø°Ù Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø©',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ø§Ù„Ø§Ø®ØªÙŠØ§Ø± Ø¥Ù„Ø²Ø§Ù…ÙŠ'),
              value: draft.isRequired,
              onChanged: (value) {
                draft.isRequired = value;
                onChanged();
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø© Ù…ÙØ¹Ù„Ø©'),
              value: draft.isActive,
              onChanged: (value) {
                draft.isActive = value;
                onChanged();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '${draft.minSelections}',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ø£Ù‚Ù„ Ø¹Ø¯Ø¯ Ø§Ø®ØªÙŠØ§Ø±Ø§Øª',
                    ),
                    onChanged: (value) {
                      draft.minSelections = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: '${draft.maxSelections}',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ø£Ø¹Ù„Ù‰ Ø¹Ø¯Ø¯ Ø§Ø®ØªÙŠØ§Ø±Ø§Øª',
                    ),
                    onChanged: (value) {
                      draft.maxSelections = int.tryParse(value) ?? 1;
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Ø§Ù„Ø®ÙŠØ§Ø±Ø§Øª',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    draft.modifiers.add(_ModifierDraft.empty());
                    onChanged();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ø¥Ø¶Ø§ÙØ© Ø®ÙŠØ§Ø±'),
                ),
              ],
            ),
            if (draft.modifiers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø®ÙŠØ§Ø±Ø§Øª Ø¯Ø§Ø®Ù„ Ù‡Ø°Ù‡ Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø©'),
              ),
            for (var index = 0; index < draft.modifiers.length; index++)
              _ModifierRow(
                key: ValueKey(draft.modifiers[index]),
                draft: draft.modifiers[index],
                onDelete: () {
                  draft.modifiers.removeAt(index);
                  onChanged();
                },
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }
}

class _ModifierRow extends StatelessWidget {
  final _ModifierDraft draft;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _ModifierRow({
    super.key,
    required this.draft,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: draft.name,
              decoration: const InputDecoration(labelText: 'Ø§Ø³Ù… Ø§Ù„Ø®ÙŠØ§Ø±'),
              onChanged: (value) => draft.name = value,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: '${draft.price}',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Ø§Ù„Ø³Ø¹Ø± Ø§Ù„Ø¥Ø¶Ø§ÙÙŠ'),
              onChanged: (value) {
                draft.price = num.tryParse(value) ?? 0;
              },
            ),
          ),
          IconButton(
            tooltip: draft.isAvailable ? 'Ù…ØªØ§Ø­' : 'ØºÙŠØ± Ù…ØªØ§Ø­',
            onPressed: () {
              draft.isAvailable = !draft.isAvailable;
              onChanged();
            },
            icon: Icon(
              draft.isAvailable
                  ? Icons.check_circle_outline
                  : Icons.remove_circle_outline,
              color: draft.isAvailable ? Colors.green : Colors.orange,
            ),
          ),
          IconButton(
            tooltip: 'Ø­Ø°Ù Ø§Ù„Ø®ÙŠØ§Ø±',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class _OptionDraft {
  int? id;
  String name;
  bool isRequired;
  int minSelections;
  int maxSelections;
  int sortOrder;
  bool isActive;
  final List<_ModifierDraft> modifiers;

  _OptionDraft({
    this.id,
    required this.name,
    required this.isRequired,
    required this.minSelections,
    required this.maxSelections,
    required this.sortOrder,
    required this.isActive,
    required this.modifiers,
  });

  factory _OptionDraft.empty() => _OptionDraft(
    name: '',
    isRequired: false,
    minSelections: 0,
    maxSelections: 1,
    sortOrder: 0,
    isActive: true,
    modifiers: [],
  );

  factory _OptionDraft.fromModel(GetProductsModelDataOption model) {
    return _OptionDraft(
      id: model.id,
      name: model.name ?? '',
      isRequired: model.isRequired ?? false,
      minSelections: model.minSelections ?? 0,
      maxSelections: model.maxSelections ?? 1,
      sortOrder: model.sortOrder ?? 0,
      isActive: model.isActive ?? true,
      modifiers: (model.modifiers ?? const [])
          .map(_ModifierDraft.fromModel)
          .toList(growable: true),
    );
  }

  Map<String, dynamic> toPayload() => {
    if (id != null) 'id': id,
    'name': name.trim(),
    'isRequired': isRequired,
    'minSelections': minSelections,
    'maxSelections': maxSelections,
    'sortOrder': sortOrder,
    'isActive': isActive,
    'modifiers': modifiers.map((item) => item.toPayload()).toList(),
  };
}

class _ModifierDraft {
  int? id;
  String name;
  num price;
  int sortOrder;
  bool isAvailable;

  _ModifierDraft({
    this.id,
    required this.name,
    required this.price,
    required this.sortOrder,
    required this.isAvailable,
  });

  factory _ModifierDraft.empty() => _ModifierDraft(
    name: '',
    price: 0,
    sortOrder: 0,
    isAvailable: true,
  );

  factory _ModifierDraft.fromModel(GetProductsModelDataModifier model) {
    return _ModifierDraft(
      id: model.id,
      name: model.name ?? '',
      price: model.price ?? 0,
      sortOrder: model.sortOrder ?? 0,
      isAvailable: model.isAvailable ?? true,
    );
  }

  Map<String, dynamic> toPayload() => {
    if (id != null) 'id': id,
    'name': name.trim(),
    'price': price,
    'sortOrder': sortOrder,
    'isAvailable': isAvailable,
  };
}
