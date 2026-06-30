import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_api_crypto/day35/models/user_model.dart';
import 'package:tugas_api_crypto/day35/services/absensi_api_service.dart';
import 'package:tugas_api_crypto/day35/services/dio_client.dart';
import 'package:tugas_api_crypto/day35/services/image_utils.dart';

import 'absensi_profile_screen.dart';
import 'absensi_training_detail_screen.dart';

class AbsensiHomeScreen extends StatefulWidget {
  const AbsensiHomeScreen({super.key});

  @override
  State<AbsensiHomeScreen> createState() => _AbsensiHomeScreenState();
}

class _AbsensiHomeScreenState extends State<AbsensiHomeScreen> {
  UserModel? _currentUser;
  List<Training> _trainings = [];
  List<UserModel> _users = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = createDioClient();
      final apiService = AbsensiApiService(dio);

      // Fetch user profile, trainings, and all users list concurrently
      final profileRes = await apiService.getProfile();
      final trainingsRes = await apiService.getTrainings();
      final usersRes = await apiService.getAllUsers();

      setState(() {
        _currentUser = profileRes.data;
        if (trainingsRes.data != null) {
          _trainings = trainingsRes.data!;
        }
        if (usersRes.data != null) {
          _users = usersRes.data!;
        }
      });
    } catch (e) {
      debugPrint("Absensi Dashboard Load Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat data: $e"),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _currentIndex == 0
              ? "Dashboard PPKD"
              : (_currentIndex == 1 ? "Program Pelatihan" : "Daftar Pengguna"),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              // Navigate to profile and reload when returning
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AbsensiProfileScreen(),
                ),
              );
              _loadDashboardData();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1677FF)),
            )
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              color: const Color(0xFF1677FF),
              child: _currentIndex == 0
                  ? _buildDashboardTab()
                  : (_currentIndex == 1
                        ? _buildTrainingsTab()
                        : _buildUsersTab()),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: const Color(0xFF1677FF),
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Pelatihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Pengguna',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome & Profile Card
          _buildProfileCard(),
          const SizedBox(height: 30),

          // Brief Info Section Title
          Text(
            "Ringkasan PPKD",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Statistics Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueGrey.shade900),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  Icons.school_outlined,
                  "Total Pelatihan Tersedia",
                  "${_trainings.length} Kelas",
                ),
                const Divider(
                  color: Colors.blueGrey,
                  height: 24,
                  thickness: 0.5,
                ),
                _buildStatRow(
                  Icons.people_outline,
                  "Total Pengguna PPKD",
                  "${_users.length} Orang",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1677FF), size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.blueGrey.shade300,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingsTab() {
    return _trainings.isEmpty
        ? Center(
            child: Text(
              "Tidak ada pelatihan saat ini.",
              style: GoogleFonts.outfit(color: Colors.blueGrey, fontSize: 16),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20.0),
            itemCount: _trainings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final training = _trainings[index];
              return _buildTrainingCard(training);
            },
          );
  }

  Widget _buildUsersTab() {
    return _users.isEmpty
        ? Center(
            child: Text(
              "Tidak ada data pengguna.",
              style: GoogleFonts.outfit(color: Colors.blueGrey, fontSize: 16),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20.0),
            itemCount: _users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final user = _users[index];
              final rawPhotoUrl = user.profilePhotoUrl ?? user.profilePhoto;
              String photoUrl = ImageUtils.sanitizeImageUrl(rawPhotoUrl);
              if (photoUrl.isNotEmpty && !photoUrl.startsWith("http")) {
                photoUrl =
                    "https://appabsensi.mobileprojp.com/public/profile_photo/$photoUrl";
              }
              final hasPhoto = photoUrl.isNotEmpty;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueGrey.shade900),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF1677FF).withOpacity(0.1),
                      backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
                      child: !hasPhoto
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFF1677FF),
                              size: 28,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "Pengguna PPKD",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email ?? "",
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Training Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1677FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              user.training?.title ??
                                  "Belum Terdaftar Pelatihan",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1677FF),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildProfileCard() {
    String? rawPhotoUrl =
        _currentUser?.profilePhotoUrl ?? _currentUser?.profilePhoto;
    if (rawPhotoUrl != null &&
        rawPhotoUrl.isNotEmpty &&
        !rawPhotoUrl.startsWith("http")) {
      rawPhotoUrl =
          "https://appabsensi.mobileprojp.com/public/profile_photo/$rawPhotoUrl";
    }
    final photoUrl = ImageUtils.sanitizeImageUrl(rawPhotoUrl);
    final hasPhoto = photoUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade800.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF1677FF).withOpacity(0.2),
                backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
                child: !hasPhoto
                    ? const Icon(
                        Icons.person,
                        size: 36,
                        color: Color(0xFF1677FF),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentUser?.name ?? "Pengguna PPKD",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser?.email ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.blueGrey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.blueGrey, thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaInfo(
                Icons.school_outlined,
                "Pelatihan Saya",
                _currentUser?.training?.title ?? "Belum terdaftar",
              ),
              _buildMetaInfo(
                Icons.calendar_month_outlined,
                "Angkatan",
                _currentUser?.batch?.batchKe != null
                    ? "Batch ${_currentUser!.batch!.batchKe}"
                    : "Belum terdaftar",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1677FF), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(Training training) {
    return InkWell(
      onTap: () {
        if (training.id != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AbsensiTrainingDetailScreen(trainingId: training.id!),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueGrey.shade900),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1677FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school,
                color: Color(0xFF1677FF),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    training.title ?? "",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    training.duration ?? "Durasi belum ditentukan",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.blueGrey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.blueGrey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
