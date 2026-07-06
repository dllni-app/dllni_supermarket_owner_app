extension StringExtensions on String {
  String toUpper() => toUpperCase();

  String toLower() => toLowerCase();

  String toCamelCase() {
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String toPascalCase() {
    return split(RegExp(r'[\s_-]+')).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  String toSnakeCase() {
    return replaceAll(RegExp(r'\s+'), '_').toLowerCase();
  }

  String toKebabCase() {
    return replaceAll(RegExp(r'\s+'), '-').toLowerCase();
  }

  String toSentenceCase() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  bool containsNumbers() {
    return contains(RegExp(r'\d'));
  }
}


extension PhoneNumberFormatting on String? {
  String get formatAsPhoneNumber {
    if (this == null || this!.isEmpty) return '-';

    // 1. إزالة أي رموز غير رقمية
    String cleaned = this!.replaceAll(RegExp(r'\D'), '');

    // 2. التحقق من طول الرقم (يجب أن يكون طويلاً بما يكفي)
    // نفترض أن الرقم السوري يبدأ بـ 963 يتبعه 9 أرقام (إجمالي 12 رقماً)
    if (cleaned.startsWith('963') && cleaned.length >= 12) {
      String prefix = cleaned.substring(0, 3); // 963
      String part1 = cleaned.substring(3, 6);  // 964
      String part2 = cleaned.substring(6, 9);  // 786
      String part3 = cleaned.substring(9);     // 134

      // التنسيق النهائي: +963 964 786 134
      return '\u200E+$prefix $part1 $part2 $part3';
    }

    // في حال لم يطابق التنسيق المطلوب، نرجعه كما هو مع إضافة + إذا لزم الأمر
    return '\u200E${this!.startsWith('+') ? '' : '+'}$cleaned';
  }
}
