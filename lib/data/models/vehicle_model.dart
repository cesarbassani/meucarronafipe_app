class VehicleModel {
  final String placa;
  final String marca;
  final String? marcaOriginal;
  final String modelo;
  final String? modeloLimpo;
  final int anoModelo;
  final int ano;
  final String uf;
  final String? municipio;
  final String? chassi;
  final String? cor;
  final String? categoria;
  final String? tipoVeiculo;
  final String? combustivel;
  final int? codigoCombustivel;

  VehicleModel({
    required this.placa,
    required this.marca,
    this.marcaOriginal,
    required this.modelo,
    this.modeloLimpo,
    required this.anoModelo,
    required this.ano,
    required this.uf,
    this.municipio,
    this.chassi,
    this.cor,
    this.categoria,
    this.tipoVeiculo,
    this.combustivel,
    this.codigoCombustivel,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      placa: json['placa'] ?? '',
      marca: json['marca'] ?? '',
      marcaOriginal: json['marcaOriginal'],
      modelo: json['modelo'] ?? '',
      modeloLimpo: json['modeloLimpo'],
      anoModelo: json['anoModelo'] ?? 0,
      ano: json['ano'] ?? 0,
      uf: json['uf'] ?? '',
      municipio: json['municipio'],
      chassi: json['chassi'],
      cor: json['cor'],
      categoria: json['categoria'],
      tipoVeiculo: json['tipoVeiculo'],
      combustivel: json['combustivel'],
      codigoCombustivel: json['codigoCombustivel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa': placa,
      'marca': marca,
      'marcaOriginal': marcaOriginal,
      'modelo': modelo,
      'modeloLimpo': modeloLimpo,
      'anoModelo': anoModelo,
      'ano': ano,
      'uf': uf,
      'municipio': municipio,
      'chassi': chassi,
      'cor': cor,
      'categoria': categoria,
      'tipoVeiculo': tipoVeiculo,
      'combustivel': combustivel,
      'codigoCombustivel': codigoCombustivel,
    };
  }

  /// Retorna o nome de exibição do veículo
  String get displayName {
    if (marca.isNotEmpty && modelo.isNotEmpty) {
      // Remove a marca do modelo se estiver duplicada
      final modeloClean = modelo.toUpperCase().startsWith(marca.toUpperCase())
          ? modelo.substring(marca.length).trim()
          : modelo;
      return '$marca $modeloClean'.trim();
    }
    return modelo.isNotEmpty ? modelo : 'Veículo';
  }

  /// Retorna apenas o nome do modelo sem a marca
  String get modeloDisplay {
    if (modeloLimpo != null && modeloLimpo!.isNotEmpty) {
      return modeloLimpo!;
    }
    // Tenta remover a marca do modelo
    final upper = modelo.toUpperCase();
    final marcaUpper = marca.toUpperCase();
    if (upper.startsWith(marcaUpper)) {
      return modelo
          .substring(marca.length)
          .replaceAll(RegExp(r'^[/\s-]+'), '')
          .trim();
    }
    return modelo;
  }
}
