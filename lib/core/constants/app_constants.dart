class AppConstants {
  // API
  static const String apiUrl =
      'https://aihkpdcygtaomsdtlzlh.supabase.co/functions/v1/consulta-placa';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFpaGtwZGN5Z3Rhb21zZHRsemxoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5ODMzOTksImV4cCI6MjA4MDU1OTM5OX0.462wX085EW82EmGgPvQ2pi37kcpjJ-q7YX0SBDSeQA0';

  // App Info
  static const String appName = 'Meu Carro na FIPE';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Consulte o valor FIPE do seu veículo';

  // Textos da UI
  static const String placaHint = 'ABC1D23';
  static const String placaLabel = 'Digite a placa do veículo';
  static const String consultarButton = 'Consultar Veículo';
  static const String consultandoButton = 'Consultando...';
  static const String novaConsultaButton = 'Nova Consulta';

  // Mensagens de erro
  static const String erroPlacaInvalida =
      'Placa inválida. Digite no formato ABC1234 ou ABC1D23.';
  static const String erroConexao = 'Erro de conexão. Verifique sua internet.';
  static const String erroServidor = 'Erro no servidor. Tente novamente.';
  static const String erroPlacaNaoEncontrada = 'Placa não encontrada.';
  static const String erroGenerico = 'Ocorreu um erro. Tente novamente.';

  // Regex para validação de placa
  static final RegExp placaAntigaRegex = RegExp(r'^[A-Z]{3}[0-9]{4}$');
  static final RegExp placaMercosulRegex =
      RegExp(r'^[A-Z]{3}[0-9][A-Z][0-9]{2}$');

  // Duração de animações
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
}

class StateNames {
  static const Map<String, String> names = {
    'AC': 'Acre',
    'AL': 'Alagoas',
    'AP': 'Amapá',
    'AM': 'Amazonas',
    'BA': 'Bahia',
    'CE': 'Ceará',
    'DF': 'Distrito Federal',
    'ES': 'Espírito Santo',
    'GO': 'Goiás',
    'MA': 'Maranhão',
    'MT': 'Mato Grosso',
    'MS': 'Mato Grosso do Sul',
    'MG': 'Minas Gerais',
    'PA': 'Pará',
    'PB': 'Paraíba',
    'PR': 'Paraná',
    'PE': 'Pernambuco',
    'PI': 'Piauí',
    'RJ': 'Rio de Janeiro',
    'RN': 'Rio Grande do Norte',
    'RS': 'Rio Grande do Sul',
    'RO': 'Rondônia',
    'RR': 'Roraima',
    'SC': 'Santa Catarina',
    'SP': 'São Paulo',
    'SE': 'Sergipe',
    'TO': 'Tocantins',
  };

  static String getName(String uf) => names[uf] ?? uf;
}

class IpvaRates {
  static const Map<String, double> rates = {
    'AC': 2.0,
    'AL': 3.0,
    'AP': 3.0,
    'AM': 3.0,
    'BA': 2.5,
    'CE': 3.0,
    'DF': 3.0,
    'ES': 2.0,
    'GO': 3.75,
    'MA': 2.5,
    'MT': 2.0,
    'MS': 3.0,
    'MG': 4.0,
    'PA': 2.5,
    'PB': 2.5,
    'PR': 1.9,
    'PE': 1.5,
    'PI': 2.5,
    'RJ': 4.0,
    'RN': 3.0,
    'RS': 3.0,
    'RO': 3.0,
    'RR': 3.0,
    'SC': 2.0,
    'SP': 4.0,
    'SE': 2.5,
    'TO': 2.0,
  };

  static double getRate(String uf) => rates[uf] ?? 3.0;

  static double calculateIpva(double fipeValue, String uf) {
    return fipeValue * (getRate(uf) / 100);
  }

  static List<MapEntry<String, double>> getAllIpvaValues(double fipeValue) {
    final list = rates.entries.map((e) {
      return MapEntry(e.key, fipeValue * (e.value / 100));
    }).toList();
    list.sort((a, b) => b.value.compareTo(a.value));
    return list;
  }
}
