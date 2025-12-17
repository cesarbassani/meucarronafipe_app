import 'package:flutter/material.dart';
import 'package:meucarronafipe/core/constants/app_constants.dart';
import 'package:meucarronafipe/core/theme/app_theme.dart';
import 'package:meucarronafipe/presentation/providers/consulta_provider';
import 'package:provider/provider.dart';

import '../widgets/vehicle_card.dart';
import '../widgets/ipva_card.dart';
import '../widgets/fipe_models_list.dart';
import '../widgets/fipe_value_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<ConsultaProvider>(
        builder: (context, provider, child) {
          if (!provider.hasData) {
            return const Center(
              child: Text('Nenhum dado disponível'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card do Veículo
                VehicleCard(vehicle: provider.vehicle!),

                const SizedBox(height: AppSpacing.md),

                // Card do IPVA Principal
                IpvaCard(
                  estado: provider.ipvaPrincipal?.estado ?? '',
                  valor: provider.ipvaValor,
                  aliquota: provider.ipvaPrincipal?.aliquota ?? 0,
                ),

                const SizedBox(height: AppSpacing.md),

                // Lista de Modelos FIPE
                if (provider.fipeModels.isNotEmpty) ...[
                  FipeModelsList(
                    models: provider.fipeModels,
                    selectedModel: provider.selectedModel,
                    onModelSelected: (model) {
                      provider.selectModel(model);
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Card do Valor FIPE (modelo selecionado)
                  if (provider.selectedModel != null)
                    FipeValueCard(
                      model: provider.selectedModel!,
                      estado: provider.ipvaPrincipal?.estado ?? '',
                    ),
                ] else ...[
                  _buildNoModelsCard(),
                ],

                const SizedBox(height: AppSpacing.lg),

                // Indicador de cache
                if (provider.fromCache) _buildCacheIndicator(),

                const SizedBox(height: AppSpacing.md),

                // Botão Nova Consulta
                _buildNovaConsultaButton(context),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          context.read<ConsultaProvider>().reset();
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textPrimary,
        ),
      ),
      title: Consumer<ConsultaProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Resultado',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          );
        },
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.border,
        ),
      ),
    );
  }

  Widget _buildNoModelsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 48,
            color: AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Valor FIPE não encontrado',
            style: AppTextStyles.h4,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Não foi possível encontrar o valor FIPE para este veículo. '
            'Os dados básicos ainda estão disponíveis acima.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCacheIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cached_rounded,
            size: 16,
            color: AppColors.info,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Dados em cache (últimas 24h)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNovaConsultaButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<ConsultaProvider>().reset();
        Navigator.of(context).pop();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.refresh_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppConstants.novaConsultaButton,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
