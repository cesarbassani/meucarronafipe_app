import 'package:flutter/material.dart';
import 'package:meucarronafipe/core/theme/app_theme.dart';
import 'package:meucarronafipe/core/utils/formatters.dart';
import 'package:meucarronafipe/data/models/fipe_model.dart';
import 'package:meucarronafipe/presentation/widgets/ipva_card.dart';

class FipeValueCard extends StatelessWidget {
  final FipeModel model;
  final String estado;

  const FipeValueCard({
    super.key,
    required this.model,
    required this.estado,
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

          // Valor FIPE
          _buildValorSection(),

          const Divider(height: 1, color: AppColors.divider),

          // Informações adicionais
          _buildInfoSection(),

          const Divider(height: 1, color: AppColors.divider),

          // Disclaimer
          _buildDisclaimer(),

          const SizedBox(height: AppSpacing.md),

          // IPVA por estado (expandível)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: IpvaAllStatesCard(
              valorFipe: model.valor,
              estadoPrincipal: estado,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: AppColors.textOnPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valor FIPE',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  model.nome,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValorSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Valor principal
          Text(
            Formatters.formatCurrency(model.valor),
            style: AppTextStyles.currency.copyWith(
              fontSize: 40,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Badges
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              // Ano
              if (model.anoModelo != null)
                _buildBadge(
                  icon: Icons.calendar_today_rounded,
                  label: model.anoModelo.toString(),
                ),

              // Combustível
              if (model.combustivel != null)
                _buildBadge(
                  icon: Icons.local_gas_station_rounded,
                  label: Formatters.formatCombustivel(model.combustivel),
                ),

              // Mês de referência
              if (model.mesReferencia != null)
                _buildBadge(
                  icon: Icons.update_rounded,
                  label:
                      'Ref. ${Formatters.formatMesReferencia(model.mesReferencia)}',
                  color: AppColors.info,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final badgeColor = color ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: badgeColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: badgeColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              label: 'Código FIPE',
              value: model.codigoDisplay,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildInfoItem(
              label: 'Tipo',
              value: _getTipoVeiculo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.labelLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getTipoVeiculo() {
    switch (model.tipoVeiculoFipe) {
      case '1':
        return 'Carro';
      case '2':
        return 'Moto';
      case '3':
        return 'Caminhão';
      default:
        return 'Veículo';
    }
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Entenda este valor:',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'O valor FIPE é uma referência média de mercado, calculada com base em pesquisas junto a concessionárias, revendedoras e lojas de veículos em todo o Brasil.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Este valor não considera:',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildDisclaimerItem('Estado de conservação e quilometragem'),
          _buildDisclaimerItem('Opcionais de fábrica ou acessórios instalados'),
          _buildDisclaimerItem('Histórico de manutenção e acidentes'),
          _buildDisclaimerItem('Variações regionais de oferta e demanda'),
        ],
      ),
    );
  }

  Widget _buildDisclaimerItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
