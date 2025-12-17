import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meucarronafipe/core/constants/app_constants.dart';
import 'package:meucarronafipe/core/theme/app_theme.dart';

class PlateInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const PlateInput({
    super.key,
    required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      maxLength: 7,
      style: AppTextStyles.plate.copyWith(
        color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
      ),
      decoration: InputDecoration(
        hintText: AppConstants.placaHint,
        hintStyle: AppTextStyles.plate.copyWith(
          color: AppColors.textTertiary.withOpacity(0.5),
        ),
        counterText: '',
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide:
              BorderSide(color: AppColors.border.withOpacity(0.5), width: 1.5),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: AppSpacing.md),
          child: Icon(
            Icons.directions_car_rounded,
            color: enabled ? AppColors.primary : AppColors.textTertiary,
            size: 24,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
      ),
      inputFormatters: [
        // Converte para maiúsculas
        UpperCaseTextFormatter(),
        // Remove caracteres inválidos
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
        // Limita a 7 caracteres
        LengthLimitingTextInputFormatter(7),
      ],
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}

/// Formatter que converte texto para maiúsculas
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Widget de exibição de placa (somente leitura)
class PlateDisplay extends StatelessWidget {
  final String placa;
  final double? fontSize;
  final Color? backgroundColor;

  const PlateDisplay({
    super.key,
    required this.placa,
    this.fontSize,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPlate = _formatPlate(placa);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador azul (estilo placa Mercosul)
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF003399),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Texto da placa
          Text(
            formattedPlate,
            style: AppTextStyles.plate.copyWith(
              fontSize: fontSize ?? 24,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPlate(String plate) {
    final clean = plate.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (clean.length == 7) {
      return '${clean.substring(0, 3)}-${clean.substring(3)}';
    }
    return clean;
  }
}

/// Widget compacto de placa para listas
class PlateChip extends StatelessWidget {
  final String placa;

  const PlateChip({
    super.key,
    required this.placa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        placa.toUpperCase(),
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
