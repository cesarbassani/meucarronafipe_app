import 'package:flutter/material.dart';
import 'package:meucarronafipe/core/constants/app_constants.dart';
import 'package:meucarronafipe/core/theme/app_theme.dart';
import 'package:meucarronafipe/core/utils/formatters.dart';
import 'package:meucarronafipe/presentation/providers/consulta_provider';
import 'package:provider/provider.dart';
import '../widgets/plate_input.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _plateController = TextEditingController();
  final FocusNode _plateFocusNode = FocusNode();

  @override
  void dispose() {
    _plateController.dispose();
    _plateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onConsultar() async {
    final placa = _plateController.text.trim();

    // Valida a placa
    if (!Formatters.isValidPlate(placa)) {
      _showError(AppConstants.erroPlacaInvalida);
      return;
    }

    // Remove foco do campo
    _plateFocusNode.unfocus();

    // Faz a consulta
    final provider = context.read<ConsultaProvider>();
    await provider.consultarPlaca(placa);

    if (!mounted) return;

    // Verifica resultado
    if (provider.hasError) {
      _showError(provider.errorMessage ?? AppConstants.erroGenerico);
    } else if (provider.hasData) {
      // Navega para tela de resultado
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResultScreen(),
        ),
      );

      // 👇 LIMPA AO VOLTAR
      _plateController.clear();
      _plateFocusNode.requestFocus();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
        duration: AppConstants.snackBarDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),

              // Logo
              _buildLogo(),

              const SizedBox(height: AppSpacing.xl),

              // Título
              const Text(
                'Consulte seu veículo',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtítulo
              Text(
                'Digite a placa para descobrir o valor FIPE\ne calcular o IPVA',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Card de consulta
              _buildConsultaCard(),

              const SizedBox(height: AppSpacing.xl),

              // Informações
              _buildInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.directions_car_rounded,
            size: 60,
            color: AppColors.primary,
          );
        },
      ),
    );
  }

  Widget _buildConsultaCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label
          const Text(
            AppConstants.placaLabel,
            style: AppTextStyles.labelLarge,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Campo de placa
          PlateInput(
            controller: _plateController,
            focusNode: _plateFocusNode,
            onSubmitted: (_) => _onConsultar(),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Botão de consultar
          Consumer<ConsultaProvider>(
            builder: (context, provider, child) {
              return AnimatedContainer(
                duration: AppConstants.animationDuration,
                height: 56,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _onConsultar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: provider.isLoading
                      ? _buildLoadingButton()
                      : _buildNormalButton(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNormalButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.search_rounded,
          size: 22,
          color: AppColors.textOnPrimary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          AppConstants.consultarButton,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          AppConstants.consultandoButton,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textOnPrimary.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildInfoItem(
          icon: Icons.verified_rounded,
          title: 'Dados Oficiais',
          description: 'Valores da Tabela FIPE atualizados',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildInfoItem(
          icon: Icons.speed_rounded,
          title: 'Consulta Rápida',
          description: 'Resultado em segundos',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildInfoItem(
          icon: Icons.lock_rounded,
          title: '100% Gratuito',
          description: 'Sem cadastro ou taxas',
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge,
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
