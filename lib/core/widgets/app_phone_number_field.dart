import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../helpers/phone_number_helper.dart';

enum AppPhoneFieldVariant { ownerLogin, ownerProfile }

class AppPhoneNumberField extends StatefulWidget {
  final String? label;

  final bool isRequired;
  final String hintText;
  final PhoneNumber? initialValue;
  final ValueChanged<PhoneNumber>? onChanged;
  final bool enabled;
  final AppPhoneFieldVariant variant;
  final bool showLabel;
  final Future<String?> Function(PhoneNumber?)? validator;
  const AppPhoneNumberField({
    super.key,
    this.label,
    this.isRequired = false,
    this.hintText = 'أدخل رقم الجوال',
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.variant = AppPhoneFieldVariant.ownerProfile,
    this.showLabel = true,
    this.validator,
  });

  @override
  State<AppPhoneNumberField> createState() => AppPhoneNumberFieldState();
}

class AppPhoneNumberFieldState extends State<AppPhoneNumberField> {
  PhoneNumber? _phone;

  PhoneNumber? get phone => _phone;

  @override
  Widget build(BuildContext context) {
    final input = TextFormField(
      decoration: _decoration(context),
      keyboardType: TextInputType.phone,
      initialValue: widget.initialValue?.phoneNumber,
      textAlign: TextAlign.left,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        _phone = PhoneNumber( phoneNumber: "+963${value}");
        widget.onChanged?.call(_phone!);
      },
      validator: (value) => validatePhoneNumberText(value),
    );
    // Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: InternationalPhoneNumberInput(
    //     initialValue: widget.initialValue ?? _phone,
    //     onInputChanged: (number) {
    //       _phone = number;
    //       widget.onChanged?.call(number);
    //     },
    //     selectorConfig: const SelectorConfig(
    //       selectorType: PhoneInputSelectorType.DROPDOWN,
    //       showFlags: true,
    //       useEmoji: true,
    //       leadingPadding: 8,
    //       trailingSpace: false,
    //     ),
    //     ignoreBlank: false,
    //     autoValidateMode: AutovalidateMode.disabled,
    //     formatInput: true,
    //     keyboardType: TextInputType.phone,
    //     textAlign: TextAlign.left,
    //     inputDecoration: _decoration(context),
    //     selectorTextStyle: const TextStyle(
    //       color: Color(0xff2F2B3D),
    //       fontSize: 14,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     textStyle: const TextStyle(
    //       color: Color(0xff2F2B3D),
    //       fontSize: 14,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     countries: const [
    //       'SY',
    //       'SA',
    //       'AE',
    //       'JO',
    //       'EG',
    //       'LB',
    //       'IQ',
    //       'KW',
    //       'QA',
    //       'BH',
    //       'OM',
    //     ],
    //     validator: (value) => validatePhoneNumberText(value),
    //     isEnabled: widget.enabled,
    //     locale: 'ar',
    //   ),
    // );

    final field = widget.enabled ? input : AbsorbPointer(child: input);

    if (!widget.showLabel || widget.label == null) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.bodyMedium(
              widget.label!,
              fontWeight: widget.variant == AppPhoneFieldVariant.ownerLogin
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: widget.variant == AppPhoneFieldVariant.ownerLogin
                  ? const Color(0xff111827)
                  : null,
            ),
            if (widget.isRequired)
              AppText.bodyMedium(
                '*',
                color: context.error,
                fontWeight: FontWeight.w500,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          spacing: 16,
          children: [
            Expanded(child: field),
            _buildFlagsButton(),
          ],
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant AppPhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _phone = widget.initialValue;
    }
  }

  @override
  void initState() {
    super.initState();
    _phone = widget.initialValue;
  }

  Future<String?> validate() async {
    if (widget.validator != null) {
      return widget.validator!(_phone);
    }
    return validatePhoneNumber(_phone);
  }

  Widget _buildFlagsButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5E7EB), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        // onTap: widget.enabled ? _changeCountry : null,
        onTap: null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 4),
            FittedBox(
              child: Text(
                '+963',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Color(0xff2F2B3D),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildFlagWidget(),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SvgPicture.asset(
          'assets/images/svgs/sy.svg',
          width: 28,
          height: 20,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  InputDecoration _decoration(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);
    final fillColor = widget.variant == AppPhoneFieldVariant.ownerLogin
        ? context.onPrimary
        : const Color(0xffF9FAFB);
    final borderColor = widget.variant == AppPhoneFieldVariant.ownerLogin
        ? Colors.grey.shade300
        : const Color(0xffE5E7EB);

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      prefixIcon: Icon(
        Icons.phone_outlined,
        color: Colors.grey.shade400,
        size: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: widget.variant == AppPhoneFieldVariant.ownerLogin
              ? context.secondary
              : context.primary,
          width: widget.variant == AppPhoneFieldVariant.ownerLogin ? 1 : 1.1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: context.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: context.error),
      ),
    );
  }
}
