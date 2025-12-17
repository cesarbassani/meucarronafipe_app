import 'package:meucarronafipe/data/models/fipe_model.dart';

class FipeModel {
  final String codigo;
  final String nome;
  final double valor;
  final double? score;
  final String? codigoFipe;
  final String? mesReferencia;
  final String? combustivel;
  final int? anoModelo;
  final String? tipoVeiculoFipe;

  FipeModel({
    required this.codigo,
    required this.nome,
    required this.valor,
    this.score,
    this.codigoFipe,
    this.mesReferencia,
    this.combustivel,
    this.anoModelo,
    this.tipoVeiculoFipe,
  });

  factory FipeModel.fromJson(Map<String, dynamic> json) {
    return FipeModel(
      codigo: json['codigo']?.toString() ?? '',
      nome: json['nome'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      score: json['score']?.toDouble(),
      codigoFipe: json['codigoFipe'],
      mesReferencia: json['mesReferencia'],
      combustivel: json['combustivel'],
      anoModelo: json['anoModelo'],
      tipoVeiculoFipe: json['tipoVeiculoFipe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'valor': valor,
      'score': score,
      'codigoFipe': codigoFipe,
      'mesReferencia': mesReferencia,
      'combustivel': combustivel,
      'anoModelo': anoModelo,
      'tipoVeiculoFipe': tipoVeiculoFipe,
    };
  }

  /// Retorna o código FIPE formatado
  String get codigoDisplay => codigoFipe ?? codigo;
}

class IpvaPrincipal {
  final String estado;
  final double valor;
  final double aliquota;

  IpvaPrincipal({
    required this.estado,
    required this.valor,
    required this.aliquota,
  });

  factory IpvaPrincipal.fromJson(Map<String, dynamic> json) {
    return IpvaPrincipal(
      estado: json['estado'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      aliquota: (json['aliquota'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'valor': valor,
      'aliquota': aliquota,
    };
  }
}

class FipeHistoryEntry {
  final String mes;
  final double valor;

  FipeHistoryEntry({
    required this.mes,
    required this.valor,
  });

  factory FipeHistoryEntry.fromJson(Map<String, dynamic> json) {
    return FipeHistoryEntry(
      mes: json['mes'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
    );
  }
}

class ConsultaResponse {
  final VehicleModel vehicle;
  final List<FipeModel> fipeModels;
  final IpvaPrincipal ipvaPrincipal;
  final bool fromCache;
  final List<FipeHistoryEntry>? fipeHistory;
  final String? error;

  ConsultaResponse({
    required this.vehicle,
    required this.fipeModels,
    required this.ipvaPrincipal,
    this.fromCache = false,
    this.fipeHistory,
    this.error,
  });

  factory ConsultaResponse.fromJson(Map<String, dynamic> json) {
    return ConsultaResponse(
      vehicle: VehicleModel.fromJson(json['vehicle'] ?? {}),
      fipeModels: (json['fipeModels'] as List<dynamic>?)
              ?.map((e) => FipeModel.fromJson(e))
              .toList() ??
          [],
      ipvaPrincipal: IpvaPrincipal.fromJson(json['ipvaPrincipal'] ?? {}),
      fromCache: json['from_cache'] ?? false,
      fipeHistory: (json['fipeHistory'] as List<dynamic>?)
          ?.map((e) => FipeHistoryEntry.fromJson(e))
          .toList(),
      error: json['error'],
    );
  }

  /// Retorna o modelo FIPE principal (primeiro da lista)
  FipeModel? get mainModel => fipeModels.isNotEmpty ? fipeModels.first : null;

  /// Verifica se há modelos FIPE disponíveis
  bool get hasModels => fipeModels.isNotEmpty;

  /// Verifica se há erro
  bool get hasError => error != null && error!.isNotEmpty;
}
