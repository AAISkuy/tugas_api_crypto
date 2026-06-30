import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tugas_api_crypto/day35/models/auth_response.dart';
import 'package:tugas_api_crypto/day35/models/profile_response.dart';
import 'package:tugas_api_crypto/day35/models/trainings_response.dart';
import 'package:tugas_api_crypto/day35/models/batches_response.dart';
import 'package:tugas_api_crypto/day35/models/all_users_response.dart';

part 'absensi_api_service.g.dart';

@RestApi()
abstract class AbsensiApiService {
  factory AbsensiApiService(Dio dio, {String baseUrl}) = _AbsensiApiService;

  @POST('/api/register')
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @POST('/api/login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @GET('/api/profile')
  Future<ProfileResponse> getProfile();

  @PUT('/api/profile')
  Future<ProfileResponse> updateProfile(@Body() Map<String, dynamic> body);

  @PUT('/api/profile/photo')
  Future<ProfileResponse> updateProfilePhoto(@Body() Map<String, dynamic> body);

  @GET('/api/users')
  Future<AllUsersResponse> getAllUsers();

  @GET('/api/trainings')
  Future<TrainingsResponse> getTrainings();

  @GET('/api/trainings/{id}')
  Future<TrainingDetailResponse> getTrainingDetail(@Path('id') int id);

  @GET('/api/batches')
  Future<BatchesResponse> getBatches();
}
