import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ProductTypeAheadField<T> extends StatelessWidget {
  const ProductTypeAheadField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.suggestionsCallback,
    required this.titleBuilder,
    required this.onSelected,
    this.subtitleBuilder,
    this.imageUrlBuilder,
    this.onTextChanged,
    this.isRequired = false,
    this.emptyText = 'لا توجد نتائج',
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final FutureOr<List<T>?> Function(String search) suggestionsCallback;
  final String Function(T item) titleBuilder;
  final String? Function(T item)? subtitleBuilder;
  final String? Function(T item)? imageUrlBuilder;
  final ValueChanged<T> onSelected;
  final ValueChanged<String>? onTextChanged;
  final bool isRequired;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: [
              if (isRequired)
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
            ],
          ),
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        TypeAheadField<T>(
          controller: controller,
          debounceDuration: const Duration(milliseconds: 350),
          constraints: const BoxConstraints(maxHeight: 320),
          suggestionsCallback: suggestionsCallback,
          builder: (context, fieldController, focusNode) {
            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              textDirection: TextDirection.rtl,
              onChanged: onTextChanged,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: const TextStyle(
                color: Color(0xB22F2B3D),
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF9CA3AF),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF243684)),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            );
          },
          decorationBuilder: (context, child) {
            return Material(
              type: MaterialType.card,
              elevation: 6,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(16),
              child: child,
            );
          },
          loadingBuilder: (context) => const Padding(
            padding: EdgeInsets.all(18),
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
          emptyBuilder: (context) => Padding(
            padding: const EdgeInsets.all(18),
            child: Center(
              child: Text(
                emptyText,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          errorBuilder: (context, error) => const Padding(
            padding: EdgeInsets.all(18),
            child: Center(
              child: Text(
                'تعذر تحميل النتائج، حاول مرة أخرى',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          itemBuilder: (context, item) {
            final imageUrl = imageUrlBuilder?.call(item)?.trim();
            final subtitle = subtitleBuilder?.call(item)?.trim();
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    _SuggestionImage(imageUrl: imageUrl),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            titleBuilder(item),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          if (subtitle != null && subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemSeparatorBuilder: (_, __) => const Divider(height: 1),
          onSelected: (item) {
            controller.text = titleBuilder(item);
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
            onSelected(item);
          },
        ),
      ],
    );
  }
}

class _SuggestionImage extends StatelessWidget {
  const _SuggestionImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: Color(0xFF9CA3AF),
        size: 22,
      ),
    );
  }
}
