import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tugas_api_crypto/models/crypto_models.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://api.coingecko.com/api/v3')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/coins/markets?vs_currency=idr')
  Future<List<CryptoModels>> getAllPosts(@Query('vs_currency') String currency);
}
