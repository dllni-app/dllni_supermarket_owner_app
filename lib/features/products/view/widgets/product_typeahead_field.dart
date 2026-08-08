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
                  text: ' *',
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
          constraints: const BoxConstraints(maxHeight: 380),
          suggestionsCallback: suggestionsCallback,
          builder: (context, fieldController, focusNode) {
            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              textDirection: TextDirection.rtl,
              onChanged: onTextChanged,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Cairo',
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 25,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 50,
                  minHeight: 50,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
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
                  borderSide: BorderSide(color: Color(0xFF243684), width: 1.4),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            );
          },
          decorationBuilder: (context, child) {
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F111827),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: child,
              ),
            );
          },
          loadingBuilder: (context) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2.2),
                ),
                SizedBox(width: 10),
                Text(
                  'جارٍ تحميل النتائج...',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          emptyBuilder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  color: Color(0xFF9CA3AF),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  emptyText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          errorBuilder: (context, error) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  color: Color(0xFFEF4444),
                  size: 30,
                ),
                SizedBox(height: 8),
                Text(
                  'تعذر تحميل النتائج، حاول مرة أخرى',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (context, item) {
            final imageUrl = imageUrlBuilder?.call(item)?.trim();
            final subtitle = subtitleBuilder?.call(item)?.trim();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFCFD),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFF0F1F4)),
                ),
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
                              fontWeight: FontWeight.w700,
                              height: 1.45,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          if (subtitle != null && subtitle.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF243684),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemSeparatorBuilder: (_, __) => const SizedBox(height: 2),
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
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty || url.toLowerCase() == 'null') {
      return _placeholder();
    }

    return Container(
      width: 62,
      height: 62,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _placeholder(inFrame: true, loading: true);
          },
          errorBuilder: (_, __, ___) => _placeholder(inFrame: true),
        ),
      ),
    );
  }

  Widget _placeholder({bool inFrame = false, bool loading = false}) {
    return Container(
      width: inFrame ? 56 : 62,
      height: inFrame ? 56 : 62,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(inFrame ? 10 : 14),
        border: inFrame
            ? null
            : Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF9CA3AF),
                size: 24,
              ),
      ),
    );
  }
}
