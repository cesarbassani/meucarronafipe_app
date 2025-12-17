import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';

class IpvaCard extends StatelessWidget {
  final String estado;
  final double valor;
  final double aliquota;

  const IpvaCard({
    super.key,
    required this.estado,
    required this.valor,
    required this.aliquota,
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

          // Valor do IPVA
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Valor principal
                Text(
                  Formatters.formatCurrency(valor),
                  style: AppTextStyles.currency.copyWith(
                    fontSize: 36,
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                // Alíquota
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Alíquota: ${Formatters.formatPercentage(aliquota)}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final estadoNome = StateNames.getName(estado);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
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
              Icons.receipt_long_rounded,
              color: AppColors.textOnPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IPVA - $estado',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  estadoNome,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card expandível com IPVA de todos os estados
class IpvaAllStatesCard extends StatefulWidget {
  final double valorFipe;
  final String estadoPrincipal;

  const IpvaAllStatesCard({
    super.key,
    required this.valorFipe,
    required this.estadoPrincipal,
  });

  @override
  State<IpvaAllStatesCard> createState() => _IpvaAllStatesCardState();
}

class _IpvaAllStatesCardState extends State<IpvaAllStatesCard> {
  bool _isExpanded = false;
  static const int _initialItemCount = 8;

  @override
  Widget build(BuildContext context) {
    final allIpva = IpvaRates.getAllIpvaValues(widget.valorFipe);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header clicável
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.map_rounded,
                      color: AppColors.info,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IPVA por Estado',
                          style:
                              AppTextStyles.labelLarge.copyWith(fontSize: 14),
                        ),
                        Text(
                          'Comparativo nacional baseado no modelo selecionado',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: AppConstants.animationDuration,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de estados (expandível)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildStatesList(allIpva),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppConstants.animationDuration,
          ),
        ],
      ),
    );
  }

  Widget _buildStatesList(List<MapEntry<String, double>> allIpva) {
    return Column(
      children: [
        const Divider(height: 1, color: AppColors.divider),

        // Container com altura limitada e scroll
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: _initialItemCount * 44.0, // ~44px por item
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            itemCount: allIpva.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppColors.divider,
              indent: AppSpacing.md,
              endIndent: AppSpacing.md,
            ),
            itemBuilder: (context, index) {
              final entry = allIpva[index];
              final isPrincipal = entry.key == widget.estadoPrincipal;
              final rate = IpvaRates.getRate(entry.key);

              return _buildStateItem(entry, isPrincipal, rate);
            },
          ),
        ),

        // Indicador de scroll
        if (allIpva.length > _initialItemCount)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.swipe_vertical_rounded,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Deslize para ver mais estados',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStateItem(
    MapEntry<String, double> entry,
    bool isPrincipal,
    double rate,
  ) {
    return Container(
      color: isPrincipal
          ? AppColors.primaryLight.withOpacity(0.5)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Estado
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    StateNames.getName(entry.key),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight:
                          isPrincipal ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${entry.key})',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),

          // Alíquota
          Expanded(
            flex: 1,
            child: Text(
              '${Formatters.formatPercentage(rate)}',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),

          // Valor
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatCurrency(entry.value),
                  style: AppTextStyles.labelLarge.copyWith(
                    color:
                        isPrincipal ? AppColors.primary : AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                if (isPrincipal) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
