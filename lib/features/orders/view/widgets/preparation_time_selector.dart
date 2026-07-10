import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreparationTimeSelector extends StatefulWidget {
  const PreparationTimeSelector({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final int? initialValue;
  final ValueChanged<int?> onChanged;

  @override
  State<PreparationTimeSelector> createState() =>
      _PreparationTimeSelectorState();
}

class _PreparationTimeSelectorState extends State<PreparationTimeSelector> {
  final TextEditingController _controller = TextEditingController();
  final List<int> _choices = [15, 25, 35, 45];
  int? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    if (_selected != null && !_choices.contains(_selected)) {
      _controller.text = '$_selected';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setValue(int? value) {
    setState(() => _selected = value);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final raw = _controller.text.trim();
    final parsed = raw.isEmpty ? null : int.tryParse(raw);
    final invalid = raw.isNotEmpty &&
        (parsed == null || parsed < 1 || parsed > 120);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Color(0xFF3B82F6)),
            const SizedBox(width: 8),
            AppText(
              'وقت التجهيز المتوقع',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 6),
            const Text('(اختياري)', style: TextStyle(color: Color(0xFF9CA3AF))),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _controller.clear();
              _setValue(null);
            },
            icon: const Icon(Icons.help_outline),
            label: const Text('الوقت غير معروف حالياً'),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _choices.map((minutes) {
            final selected = _selected == minutes && _controller.text.isEmpty;
            return ChoiceChip(
              label: Text('$minutes دقيقة'),
              selected: selected,
              onSelected: (_) {
                _controller.clear();
                _setValue(minutes);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final number = int.tryParse(value);
            setState(() => _selected = number);
            widget.onChanged(
              number != null && number >= 1 && number <= 120 ? number : null,
            );
          },
          decoration: InputDecoration(
            hintText: 'وقت مخصص من 1 إلى 120 دقيقة',
            prefixIcon: const Icon(Icons.hourglass_bottom),
            errorText: invalid ? 'يجب أن يكون الوقت بين 1 و120 دقيقة' : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
