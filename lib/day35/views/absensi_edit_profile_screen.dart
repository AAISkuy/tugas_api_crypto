import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:tugas_api_crypto/day35/models/user_model.dart';
import 'package:tugas_api_crypto/day35/services/absensi_api_service.dart';
import 'package:tugas_api_crypto/day35/services/dio_client.dart';
import 'package:tugas_api_crypto/day35/services/image_utils.dart';

class AbsensiEditProfileScreen extends StatefulWidget {
  final UserModel user;
  const AbsensiEditProfileScreen({super.key, required this.user});

  @override
  State<AbsensiEditProfileScreen> createState() => _AbsensiEditProfileScreenState();
}

class _AbsensiEditProfileScreenState extends State<AbsensiEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = createDioClient();
      final apiService = AbsensiApiService(dio);

      // 1. Update Name
      await apiService.updateProfile({
        "name": _nameController.text.trim(),
      });

      // 2. Update Profile Photo if selected
      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        final base64String = base64Encode(bytes);
        
        // Dynamically detect file extension to set appropriate mime-type
        final ext = p.extension(_selectedImage!.path).toLowerCase();
        String mimeType = "image/png";
        if (ext == ".jpg" || ext == ".jpeg") {
          mimeType = "image/jpeg";
        } else if (ext == ".gif") {
          mimeType = "image/gif";
        } else if (ext == ".webp") {
          mimeType = "image/webp";
        }

        final base64DataUri = "data:$mimeType;base64,$base64String";
        await apiService.updateProfilePhoto({
          "profile_photo": base64DataUri,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } on DioException catch (e) {
      String errorMessage = "Gagal memperbarui profil.";
      if (e.response != null && e.response!.data != null) {
        final message = e.response!.data['message'];
        if (message != null) errorMessage = message;
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
  Widget build(BuildContext context) {
    String? rawPhotoUrl = widget.user.profilePhotoUrl ?? widget.user.profilePhoto;
    if (rawPhotoUrl != null && rawPhotoUrl.isNotEmpty && !rawPhotoUrl.startsWith("http")) {
      rawPhotoUrl = "https://appabsensi.mobileprojp.com/public/profile_photo/$rawPhotoUrl";
    }
    final photoUrl = ImageUtils.sanitizeImageUrl(rawPhotoUrl);
    final hasPhoto = photoUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Edit Profil",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Preview & picker button
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFF1E293B),
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (hasPhoto ? NetworkImage(photoUrl) : null) as ImageProvider?,
                          child: _selectedImage == null && !hasPhoto
                              ? const Icon(Icons.person, size: 65, color: Color(0xFF1677FF))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1677FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Name Field
                  Text(
                    "Nama Pengguna",
                    style: GoogleFonts.outfit(color: Colors.blueGrey.shade300, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.blueGrey),
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
                  const SizedBox(height: 40),

                  // Save Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
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
                    child: Text(
                      "Simpan Perubahan",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF1677FF)),
              ),
            ),
        ],
      ),
    );
  }
}
