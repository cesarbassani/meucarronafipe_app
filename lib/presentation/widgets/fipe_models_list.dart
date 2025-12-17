import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/fipe_model.dart';

class FipeModelsList extends StatelessWidget {
  final List<FipeModel> models;
  final FipeModel? selectedModel;
  final ValueChanged<FipeModel> onModelSelected;

  const FipeModelsList({
    super.key,
    required this.models,
    required this.selectedModel,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(),

          const Divider(height: 1, color: AppColors.divider),

          // Lista de modelos
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: models.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppColors.divider,
              indent: AppSpacing.md,
              endIndent: AppSpacing.md,
            ),
            itemBuilder: (context, index) {
              final model = models[index];
              final isSelected = selectedModel?.codigo == model.codigo;

              return _buildModelItem(model, isSelected);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.list_alt_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modelos FIPE Encontrados',
                  style: AppTextStyles.labelLarge.copyWith(fontSize: 14),
                ),
                Text(
                  'Selecione um modelo para ver o valor FIPE detalhado',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelItem(FipeModel model, bool isSelected) {
    return InkWell(
      onTap: () => onModelSelected(model),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: isSelected ? AppColors.primaryLight.withOpacity(0.5) : null,
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: AppColors.textOnPrimary,
                    )
                  : null,
            ),

            const SizedBox(width: AppSpacing.sm),

            // Informações do modelo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do modelo
                  Text(
                    model.nome,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Detalhes em linha
                  Row(
                    children: [
                      _buildDetailChip(
                        icon: Icons.tag_rounded,
                        label: model.codigoDisplay,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (model.anoModelo != null)
                        _buildDetailChip(
                          icon: Icons.calendar_today_rounded,
                          label: model.anoModelo.toString(),
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      if (model.combustivel != null)
                        _buildDetailChip(
                          icon: Icons.local_gas_station_rounded,
                          label:
                              Formatters.formatCombustivel(model.combustivel),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Valor
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatCurrency(model.valor),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                if (model.mesReferencia != null)
                  Text(
                    Formatters.formatMesReferencia(model.mesReferencia),
                    style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 10,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
