import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Formatters {
  // Formatador de moeda brasileira
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  // Formatador de número simples
  static final NumberFormat _numberFormatter =
      NumberFormat.decimalPattern('pt_BR');

  /// Formata valor para moeda brasileira
  /// Ex: 73916.00 -> "R$ 73.916,00"
  static String formatCurrency(double value) {
    return _currencyFormatter.format(value);
  }

  /// Formata valor sem símbolo de moeda
  /// Ex: 73916.00 -> "73.916,00"
  static String formatNumber(double value) {
    return _numberFormatter.format(value);
  }

  /// Formata placa para exibição
  /// Ex: "ABC1D23" -> "ABC-1D23" ou "ABC1234" -> "ABC-1234"
  static String formatPlate(String plate) {
    final clean = plate.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (clean.length == 7) {
      return '${clean.substring(0, 3)}-${clean.substring(3)}';
    }
    return clean;
  }

  /// Remove formatação da placa
  /// Ex: "ABC-1D23" -> "ABC1D23"
  static String cleanPlate(String plate) {
    return plate.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  /// Valida se a placa é válida (formato antigo ou Mercosul)
  static bool isValidPlate(String plate) {
    final clean = cleanPlate(plate);
    if (clean.length != 7) return false;
    return AppConstants.placaAntigaRegex.hasMatch(clean) ||
        AppConstants.placaMercosulRegex.hasMatch(clean);
  }

  /// Formata chassi parcialmente oculto
  /// Ex: "9BWZZZ377VT004251" -> "*****7VT004251"
  static String formatChassi(String? chassi) {
    if (chassi == null || chassi.isEmpty) return '-';
    if (chassi.length <= 8) return chassi;
    return '*****${chassi.substring(chassi.length - 8)}';
  }

  /// Formata porcentagem
  /// Ex: 3.0 -> "3%"
  static String formatPercentage(double value) {
    if (value == value.truncateToDouble()) {
      return '${value.truncate()}%';
    }
    return '${value.toString().replaceAll('.', ',')}%';
  }

  /// Formata ano/modelo
  /// Ex: ano=2023, anoModelo=2024 -> "2023/2024"
  static String formatAnoModelo(int? ano, int? anoModelo) {
    if (ano == null && anoModelo == null) return '-';
    if (ano == null) return anoModelo.toString();
    if (anoModelo == null) return ano.toString();
    if (ano == anoModelo) return ano.toString();
    return '$ano/$anoModelo';
  }

  /// Capitaliza primeira letra de cada palavra
  /// Ex: "CAMPO GRANDE" -> "Campo Grande"
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '-';
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      // Mantém siglas em maiúsculo (2-3 letras)
      if (word.length <= 3 && word == word.toUpperCase()) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Formata nome do estado
  /// Ex: "MS" -> "Mato Grosso do Sul (MS)"
  static String formatStateName(String uf) {
    final name = StateNames.getName(uf);
    return '$name ($uf)';
  }

  /// Formata nome do estado curto
  /// Ex: "MS" -> "Mato Grosso do Sul"
  static String formatStateNameShort(String uf) {
    return StateNames.getName(uf);
  }

  /// Formata combustível
  /// Ex: "GASOLINA/ALCOOL" -> "Flex"
  static String formatCombustivel(String? combustivel) {
    if (combustivel == null || combustivel.isEmpty) return '-';
    final upper = combustivel.toUpperCase();
    if (upper.contains('ALCOOL') && upper.contains('GASOLINA')) return 'Flex';
    if (upper.contains('FLEX')) return 'Flex';
    if (upper.contains('DIESEL')) return 'Diesel';
    if (upper.contains('GASOLINA')) return 'Gasolina';
    if (upper.contains('ALCOOL') || upper.contains('ETANOL')) return 'Álcool';
    if (upper.contains('GNV')) return 'GNV';
    if (upper.contains('ELETRICO') || upper.contains('ELÉTRICO'))
      return 'Elétrico';
    if (upper.contains('HIBRIDO') || upper.contains('HÍBRIDO'))
      return 'Híbrido';
    return capitalize(combustivel);
  }

  /// Formata mês de referência
  /// Ex: "dezembro de 2025" -> "Dez/2025"
  static String formatMesReferencia(String? mes) {
    if (mes == null || mes.isEmpty) return '-';

    final meses = {
      'janeiro': 'Jan',
      'fevereiro': 'Fev',
      'março': 'Mar',
      'marco': 'Mar',
      'abril': 'Abr',
      'maio': 'Mai',
      'junho': 'Jun',
      'julho': 'Jul',
      'agosto': 'Ago',
      'setembro': 'Set',
      'outubro': 'Out',
      'novembro': 'Nov',
      'dezembro': 'Dez',
    };

    final lower = mes.toLowerCase();
    for (final entry in meses.entries) {
      if (lower.contains(entry.key)) {
        final yearMatch = RegExp(r'\d{4}').firstMatch(mes);
        if (yearMatch != null) {
          return '${entry.value}/${yearMatch.group(0)}';
        }
        return entry.value;
      }
    }
    return mes;
  }
}
