/// App Text Field Widgets
/// 
/// Reusable text input components with consistent styling.
/// Includes regular, password, search, and multiline text fields.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// Standard text field with consistent styling
class AppTextField extends StatelessWidget {
  /// Text controller
  final TextEditingController? controller;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Label text
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Helper text
  final String? helperText;
  
  /// Error text
  final String? errorText;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Suffix icon
  final IconData? suffixIcon;
  
  /// Suffix icon callback
  final VoidCallback? onSuffixIconPressed;
  
  /// Custom suffix widget
  final Widget? suffix;
  
  /// Custom prefix widget
  final Widget? prefix;
  
  /// Text input type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// On submitted callback
  final ValueChanged<String>? onSubmitted;
  
  /// Validator function
  final FormFieldValidator<String>? validator;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Whether field is read only
  final bool readOnly;
  
  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Maximum lines
  final int? maxLines;
  
  /// Minimum lines
  final int? minLines;
  
  /// Maximum length
  final int? maxLength;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Obscure text (for passwords)
  final bool obscureText;
  
  /// Auto focus
  final bool autofocus;
  
  /// Fill color
  final Color? fillColor;
  
  /// Border radius
  final double? borderRadius;
  
  /// Content padding
  final EdgeInsets? contentPadding;
  
  /// On tap callback
  final VoidCallback? onTap;
  
  /// Initial value
  final String? initialValue;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.autofocus = false,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.onTap,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          initialValue: controller == null ? initialValue : null,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          enabled: enabled,
          readOnly: readOnly,
          autovalidateMode: autovalidateMode,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          autofocus: autofocus,
          onTap: onTap,
          style: AppTextStyles.inputText.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: fillColor ?? 
                (isDark ? AppColors.darkInputFill : AppColors.lightInputFill),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
                  )
                : prefix,
            suffixIcon: suffix ?? 
                (suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          suffixIcon,
                          color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
                        ),
                        onPressed: onSuffixIconPressed,
                      )
                    : null),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.defaultRadius,
              ),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkInputBorder : AppColors.lightInputBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.defaultRadius,
              ),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkInputBorder : AppColors.lightInputBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.defaultRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.defaultRadius,
              ),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.defaultRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.defaultRadius,
              ),
              borderSide: BorderSide(
                color: isDark ? AppColors.grey700 : AppColors.grey200,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Password text field with toggle visibility
class PasswordTextField extends StatefulWidget {
  /// Text controller
  final TextEditingController? controller;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Label text
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Error text
  final String? errorText;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// On submitted callback
  final ValueChanged<String>? onSubmitted;
  
  /// Validator function
  final FormFieldValidator<String>? validator;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Initial value
  final String? initialValue;

  const PasswordTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
    this.initialValue,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      label: widget.label ?? 'Password',
      hint: widget.hint ?? 'Enter your password',
      errorText: widget.errorText,
      prefixIcon: Icons.lock_outline_rounded,
      suffixIcon: _obscureText
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      onSuffixIconPressed: _toggleVisibility,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      obscureText: _obscureText,
      initialValue: widget.initialValue,
    );
  }
}

/// Email text field with email keyboard
class EmailTextField extends StatelessWidget {
  /// Text controller
  final TextEditingController? controller;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Label text
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Error text
  final String? errorText;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// On submitted callback
  final ValueChanged<String>? onSubmitted;
  
  /// Validator function
  final FormFieldValidator<String>? validator;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Initial value
  final String? initialValue;

  const EmailTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email',
      errorText: errorText,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      initialValue: initialValue,
    );
  }
}

/// Phone number text field
class PhoneTextField extends StatelessWidget {
  /// Text controller
  final TextEditingController? controller;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Label text
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Error text
  final String? errorText;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// On submitted callback
  final ValueChanged<String>? onSubmitted;
  
  /// Validator function
  final FormFieldValidator<String>? validator;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Country code prefix widget
  final Widget? prefixWidget;
  
  /// Initial value
  final String? initialValue;

  const PhoneTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
    this.prefixWidget,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label ?? 'Phone Number',
      hint: hint ?? 'Enter your phone number',
      errorText: errorText,
      prefixIcon: prefixWidget == null ? Icons.phone_outlined : null,
      prefix: prefixWidget,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction ?? TextInputAction.next,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\+\(\)]')),
      ],
      initialValue: initialValue,
    );
  }
}

/// Search text field
class SearchTextField extends StatelessWidget {
  /// Text controller
  final TextEditingController? controller;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Hint text
  final String? hint;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// On submitted callback
  final ValueChanged<String>? onSubmitted;
  
  /// On clear callback
  final VoidCallback? onClear;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Auto focus
  final bool autofocus;
  
  /// Background color
  final Color? fillColor;

  const SearchTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClearButton = true,
    this.autofocus = false,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        filled: true,
        fillColor: fillColor ?? 
            (isDark ? AppColors.darkInputFill : AppColors.lightInputFill),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
        ),
        suffixIcon: showClearButton && (controller?.text.isNotEmpty ?? false)
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
                ),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                  onChanged?.call('');
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// Multiline text field / Text area
class TextAreaField extends StatelessWidget {
  /// Text controller
  final TextEditingController? controller;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Label text
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Error text
  final String? errorText;
  
  /// Helper text
  final String? helperText;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// Validator function
  final FormFieldValidator<String>? validator;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Maximum lines
  final int maxLines;
  
  /// Minimum lines
  final int minLines;
  
  /// Maximum length
  final int? maxLength;
  
  /// Show character counter
  final bool showCounter;
  
  /// Initial value
  final String? initialValue;

  const TextAreaField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
    this.showCounter = false,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hint: hint,
      errorText: errorText,
      helperText: helperText,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: showCounter ? maxLength : null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      initialValue: initialValue,
    );
  }
}

/// Dropdown field with consistent styling
class AppDropdownField<T> extends StatelessWidget {
  /// Currently selected value
  final T? value;
  
  /// List of items
  final List<DropdownMenuItem<T>> items;
  
  /// On changed callback
  final ValueChanged<T?>? onChanged;
  
  /// Label text
  final String? label;
  
  /// Hint text
  final String? hint;
  
  /// Error text
  final String? errorText;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Validator function
  final FormFieldValidator<T>? validator;

  const AppDropdownField({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          style: AppTextStyles.inputText.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: true,
            fillColor: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkInputBorder : AppColors.lightInputBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkInputBorder : AppColors.lightInputBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}