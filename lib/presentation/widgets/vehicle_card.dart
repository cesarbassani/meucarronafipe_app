import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/fipe_model.dart';
import 'plate_input.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleCard({
    super.key,
    required this.vehicle,
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

          // Divider
          const Divider(height: 1, color: AppColors.divider),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Linha 1: Placa | Marca | Ano
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildInfoItem(
                        label: 'Placa',
                        child: PlateChip(placa: vehicle.placa),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Linha 4: Chassi | Combustível
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildInfoItem(
                        label: 'Marca',
                        value: vehicle.marca,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildInfoItem(
                        label: 'Ano/Modelo',
                        value: Formatters.formatAnoModelo(
                          vehicle.ano,
                          vehicle.anoModelo,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildInfoItem(
                        label: 'Cor',
                        value: Formatters.capitalize(vehicle.cor),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Linha 2: Modelo
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildInfoItem(
                        label: 'Modelo',
                        value: vehicle.modeloDisplay,
                        fullWidth: true,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildInfoItem(
                        label: 'Chassi',
                        value: Formatters.formatChassi(vehicle.chassi),
                        isMonospace: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Linha 3: Cor | UF | Município
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildInfoItem(
                        label: 'UF',
                        value: vehicle.uf,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: _buildInfoItem(
                        label: 'Município',
                        value: Formatters.capitalize(vehicle.municipio),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildInfoItem(
                        label: 'Combustível',
                        child: _buildCombustivelChip(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: AppColors.textOnPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resultado da Consulta',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Informações obtidas para a placa ${vehicle.placa}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    String? value,
    Widget? child,
    bool fullWidth = false,
    bool isMonospace = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        if (child != null)
          child
        else
          Text(
            value ?? '-',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: isMonospace ? 'monospace' : 'Inter',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildCombustivelChip() {
    final combustivel = Formatters.formatCombustivel(vehicle.combustivel);
    final color = _getCombustivelColor(combustivel);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCombustivelIcon(combustivel),
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            combustivel,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCombustivelColor(String combustivel) {
    switch (combustivel.toLowerCase()) {
      case 'flex':
        return AppColors.primary;
      case 'gasolina':
        return AppColors.warning;
      case 'álcool':
      case 'etanol':
        return AppColors.success;
      case 'diesel':
        return const Color(0xFF8B4513);
      case 'elétrico':
        return AppColors.info;
      case 'híbrido':
        return const Color(0xFF9C27B0);
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getCombustivelIcon(String combustivel) {
    switch (combustivel.toLowerCase()) {
      case 'flex':
        return Icons.local_gas_station_rounded;
      case 'gasolina':
        return Icons.local_gas_station_rounded;
      case 'álcool':
      case 'etanol':
        return Icons.eco_rounded;
      case 'diesel':
        return Icons.local_gas_station_rounded;
      case 'elétrico':
        return Icons.bolt_rounded;
      case 'híbrido':
        return Icons.sync_alt_rounded;
      default:
        return Icons.local_gas_station_rounded;
    }
  }
}
