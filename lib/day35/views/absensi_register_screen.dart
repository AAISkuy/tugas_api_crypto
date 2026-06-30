import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:tugas_api_crypto/day35/models/user_model.dart';
import 'package:tugas_api_crypto/day35/services/absensi_api_service.dart';
import 'package:tugas_api_crypto/day35/services/dio_client.dart';
import 'absensi_login_screen.dart';

class AbsensiRegisterScreen extends StatefulWidget {
  const AbsensiRegisterScreen({super.key});

  @override
  State<AbsensiRegisterScreen> createState() => _AbsensiRegisterScreenState();
}

class _AbsensiRegisterScreenState extends State<AbsensiRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender;
  int? _selectedTrainingId;
  int? _selectedBatchId;

  List<Training> _trainings = [];
  List<Batch> _batches = [];
  bool _isLoading = false;
  bool _isLoadingDropdowns = true;
  bool _obscurePassword = true;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      final dio = createDioClient();
      final apiService = AbsensiApiService(dio);

      // Fetch trainings (public endpoint)
      final trainingsResponse = await apiService.getTrainings();
      if (trainingsResponse.data != null) {
        setState(() {
          _trainings = trainingsResponse.data!;
        });
      }

      // Try to fetch batches, but fail gracefully since it might require token
      try {
        final batchesResponse = await apiService.getBatches();
        if (batchesResponse.data != null) {
          setState(() {
            _batches = batchesResponse.data!;
          });
        }
      } catch (e) {
        // Fallback static batches if API requires token
        setState(() {
          _batches = [
            Batch(id: 1, batchKe: "Angkatan 1"),
            Batch(id: 2, batchKe: "Angkatan 2"),
            Batch(id: 3, batchKe: "Angkatan 3"),
            Batch(id: 4, batchKe: "Angkatan 4"),
            Batch(id: 5, batchKe: "Angkatan 5"),
          ];
        });
      }
    } catch (e) {
      // Fallback both if all fail
      setState(() {
        _trainings = [
          Training(id: 1, title: "Mobile Programming"),
          Training(id: 2, title: "Web Programming"),
          Training(id: 3, title: "Desainer Grafis Madya"),
          Training(id: 4, title: "Tata Boga"),
        ];
        _batches = [
          Batch(id: 1, batchKe: "Angkatan 1"),
          Batch(id: 2, batchKe: "Angkatan 2"),
          Batch(id: 3, batchKe: "Angkatan 3"),
        ];
      });
    } finally {
      setState(() {
        _isLoadingDropdowns = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 50, // Compress to save bandwidth
        maxWidth: 500,    // Limit dimensions
        maxHeight: 500,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengambil gambar"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF1677FF)),
                title: Text("Ambil Foto dari Kamera", style: GoogleFonts.outfit(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF1677FF)),
                title: Text("Pilih dari Galeri", style: GoogleFonts.outfit(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jenis Kelamin wajib dipilih"), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_selectedTrainingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pelatihan wajib dipilih"), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_selectedBatchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Angkatan wajib dipilih"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = createDioClient();
      final apiService = AbsensiApiService(dio);

      // Convert profile photo to base64 if selected
      String base64Image = "";
      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        final base64String = base64Encode(bytes);
        
        final ext = p.extension(_selectedImage!.path).toLowerCase();
        String mimeType = "image/png";
        if (ext == ".jpg" || ext == ".jpeg") {
          mimeType = "image/jpeg";
        } else if (ext == ".gif") {
          mimeType = "image/gif";
        } else if (ext == ".webp") {
          mimeType = "image/webp";
        }

        base64Image = "data:$mimeType;base64,$base64String";
      }

      final response = await apiService.register({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "jenis_kelamin": _selectedGender,
        "profile_photo": base64Image,
        "batch_id": _selectedBatchId,
        "training_id": _selectedTrainingId
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Registrasi berhasil! Silakan login."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AbsensiLoginScreen()),
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Registrasi gagal. Harap periksa input Anda.";
      if (e.response != null && e.response!.data != null) {
        final message = e.response!.data['message'];
        final errors = e.response!.data['errors'];
        if (errors != null && errors is Map) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first.toString();
          }
        } else if (message != null) {
          errorMessage = message;
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Buat Akun",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Daftar untuk memulai absensi digital PPKD",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueGrey.shade300,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Avatar Picker
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF1E293B),
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? const Icon(Icons.add_a_photo_outlined, size: 40, color: Color(0xFF1677FF))
                              : null,
                        ),
                        if (_selectedImage != null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _showImagePickerOptions,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1677FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 14),
                              ),
                            ),
                          )
                        else
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: _showImagePickerOptions,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Foto Profil (Opsional)",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(color: Colors.blueGrey.shade400, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.blueGrey),
                      hintText: "Nama Lengkap",
                      hintStyle: const TextStyle(color: Colors.blueGrey),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF1677FF), width: 1.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nama wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.blueGrey),
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.blueGrey),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF1677FF), width: 1.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email wajib diisi";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                        return "Masukkan email yang valid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outlined, color: Colors.blueGrey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.blueGrey),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF1677FF), width: 1.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password wajib diisi";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: _selectedGender,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.wc_outlined, color: Colors.blueGrey),
                      hintText: "Jenis Kelamin",
                      hintStyle: const TextStyle(color: Colors.blueGrey),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                      DropdownMenuItem(value: "P", child: Text("Perempuan")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  _isLoadingDropdowns
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(color: Color(0xFF1677FF)),
                          ),
                        )
                      : Column(
                          children: [
                            // Trainings Dropdown
                            DropdownButtonFormField<int>(
                              dropdownColor: const Color(0xFF1E293B),
                              value: _selectedTrainingId,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.school_outlined, color: Colors.blueGrey),
                                hintText: "Pilih Pelatihan",
                                hintStyle: const TextStyle(color: Colors.blueGrey),
                                filled: true,
                                fillColor: const Color(0xFF1E293B),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: _trainings.map((t) {
                                return DropdownMenuItem(
                                  value: t.id,
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: Text(
                                      t.title ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTrainingId = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Batches Dropdown
                            DropdownButtonFormField<int>(
                              dropdownColor: const Color(0xFF1E293B),
                              value: _selectedBatchId,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.blueGrey),
                                hintText: "Pilih Angkatan / Batch",
                                hintStyle: const TextStyle(color: Colors.blueGrey),
                                filled: true,
                                fillColor: const Color(0xFF1E293B),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: _batches.map((b) {
                                return DropdownMenuItem(
                                  value: b.id,
                                  child: Text(b.batchKe ?? "Angkatan ${b.id}"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBatchId = value;
                                });
                              },
                            ),
                          ],
                        ),
                  const SizedBox(height: 30),

                  // Register Button
                  ElevatedButton(
                    onPressed: _isLoading || _isLoadingDropdowns ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1677FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF1677FF).withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Daftar",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
