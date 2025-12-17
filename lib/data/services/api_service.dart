import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/fipe_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  /// Headers padrão para requisições
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.supabaseAnonKey}',
      };

  /// Consulta os dados do veículo pela placa
  Future<ApiResult<ConsultaResponse>> consultarPlaca(String placa) async {
    try {
      // Limpa e valida a placa
      final cleanPlate =
          placa.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

      if (cleanPlate.length != 7) {
        return ApiResult.error(AppConstants.erroPlacaInvalida);
      }

      // Valida formato
      final isValidOld = AppConstants.placaAntigaRegex.hasMatch(cleanPlate);
      final isValidNew = AppConstants.placaMercosulRegex.hasMatch(cleanPlate);

      if (!isValidOld && !isValidNew) {
        return ApiResult.error(AppConstants.erroPlacaInvalida);
      }

      print('[API] Consultando placa: $cleanPlate');

      final response = await _client
          .post(
            Uri.parse(AppConstants.apiUrl),
            headers: _headers,
            body: jsonEncode({'plate': cleanPlate}),
          )
          .timeout(_timeout);

      print('[API] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verifica se há erro na resposta
        if (data['error'] != null) {
          return ApiResult.error(data['error']);
        }

        final consultaResponse = ConsultaResponse.fromJson(data);
        print(
            '[API] Veículo: ${consultaResponse.vehicle.marca} ${consultaResponse.vehicle.modelo}');
        print('[API] Modelos FIPE: ${consultaResponse.fipeModels.length}');

        return ApiResult.success(consultaResponse);
      } else if (response.statusCode == 404) {
        return ApiResult.error(AppConstants.erroPlacaNaoEncontrada);
      } else if (response.statusCode == 429) {
        return ApiResult.error('Muitas consultas. Aguarde um momento.');
      } else {
        print('[API] Erro: ${response.body}');
        return ApiResult.error(AppConstants.erroServidor);
      }
    } on SocketException {
      print('[API] Erro de conexão');
      return ApiResult.error(AppConstants.erroConexao);
    } on TimeoutException {
      print('[API] Timeout');
      return ApiResult.error('Tempo de conexão esgotado. Tente novamente.');
    } on FormatException catch (e) {
      print('[API] Erro de formato: $e');
      return ApiResult.error(AppConstants.erroServidor);
    } catch (e) {
      print('[API] Erro inesperado: $e');
      return ApiResult.error(AppConstants.erroGenerico);
    }
  }

  /// Fecha o cliente HTTP
  void dispose() {
    _client.close();
  }
}

/// Classe genérica para resultado de API
class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResult._({
    this.data,
    this.errorMessage,
    required this.isSuccess,
  });

  factory ApiResult.success(T data) {
    return ApiResult._(
      data: data,
      isSuccess: true,
    );
  }

  factory ApiResult.error(String message) {
    return ApiResult._(
      errorMessage: message,
      isSuccess: false,
    );
  }

  /// Executa uma função com o dado se sucesso
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) error,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    }
    return error(errorMessage ?? AppConstants.erroGenerico);
  }
}
