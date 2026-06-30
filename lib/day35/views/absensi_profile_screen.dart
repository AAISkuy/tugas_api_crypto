import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_api_crypto/day35/models/user_model.dart';
import 'package:tugas_api_crypto/day35/services/absensi_api_service.dart';
import 'package:tugas_api_crypto/day35/services/dio_client.dart';
import 'package:tugas_api_crypto/day35/services/token_storage.dart';
import 'package:tugas_api_crypto/day35/services/image_utils.dart';
import 'absensi_login_screen.dart';
import 'absensi_edit_profile_screen.dart';

class AbsensiProfileScreen extends StatefulWidget {
  const AbsensiProfileScreen({super.key});

  @override
  State<AbsensiProfileScreen> createState() => _AbsensiProfileScreenState();
}

class _AbsensiProfileScreenState extends State<AbsensiProfileScreen> {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = createDioClient();
      final apiService = AbsensiApiService(dio);

      final profileRes = await apiService.getProfile();
      setState(() {
        _currentUser = profileRes.data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memuat profil."),
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

  Future<void> _handleLogout() async {
    await TokenStorage().deleteToken();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AbsensiLoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? rawPhotoUrl = _currentUser?.profilePhotoUrl ?? _currentUser?.profilePhoto;
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
          "Profil Saya",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1677FF)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar Section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFF1677FF).withOpacity(0.1),
                          backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
                          child: !hasPhoto
                              ? const Icon(Icons.person, size: 60, color: Color(0xFF1677FF))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1677FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name & Email Header
                  Text(
                    _currentUser?.name ?? "Pengguna PPKD",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _currentUser?.email ?? "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: Colors.blueGrey.shade400,
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Detail Fields (Interactive List)
                  _buildProfileTile(Icons.wc, "Jenis Kelamin",
                      _currentUser?.jenisKelamin == "L" ? "Laki-laki" : "Perempuan"),
                  _buildProfileTile(Icons.school, "Pelatihan", _currentUser?.training?.title ?? "-"),
                  _buildProfileTile(Icons.calendar_month, "Angkatan",
                      _currentUser?.batch?.batchKe != null ? "Batch ${_currentUser!.batch!.batchKe}" : "-"),
                  _buildProfileTile(Icons.badge, "Role", _currentUser?.role?.toUpperCase() ?? "-"),
                  _buildProfileTile(
                      Icons.toggle_on_outlined,
                      "Status Keaktifan",
                      _currentUser?.isActive == "1" ? "Aktif" : "Tidak Aktif",
                      trailingColor: _currentUser?.isActive == "1" ? Colors.green : Colors.redAccent),
                  const SizedBox(height: 40),

                  // Edit Profile Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_currentUser != null) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AbsensiEditProfileScreen(user: _currentUser!),
                          ),
                        );
                        _loadProfileData();
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: Text(
                      "Edit Profil & Foto",
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.blueGrey.shade800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: Text(
                      "Keluar Akun",
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value, {Color? trailingColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1677FF), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.blueGrey.shade400,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: trailingColor ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
