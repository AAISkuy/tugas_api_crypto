import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_api_crypto/day35/models/user_model.dart';
import 'package:tugas_api_crypto/day35/services/absensi_api_service.dart';
import 'package:tugas_api_crypto/day35/services/dio_client.dart';

class AbsensiTrainingDetailScreen extends StatefulWidget {
  final int trainingId;
  const AbsensiTrainingDetailScreen({super.key, required this.trainingId});

  @override
  State<AbsensiTrainingDetailScreen> createState() => _AbsensiTrainingDetailScreenState();
}

class _AbsensiTrainingDetailScreenState extends State<AbsensiTrainingDetailScreen> {
  Training? _training;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainingDetail();
  }

  Future<void> _loadTrainingDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = createDioClient();
      final apiService = AbsensiApiService(dio);

      final response = await apiService.getTrainingDetail(widget.trainingId);
      setState(() {
        _training = response.data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memuat detail pelatihan"),
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
    final units = _training?.units ?? [];
    final activities = _training?.activities ?? [];

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
          "Detail Pelatihan",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1677FF)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Training Header Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueGrey.shade900),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.school, color: Color(0xFF1677FF), size: 30),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _training?.title ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildHeaderMeta(Icons.access_time_filled_rounded, "Durasi", _training?.duration ?? "-"),
                        const SizedBox(height: 8),
                        _buildHeaderMeta(Icons.description, "Deskripsi", _training?.description ?? "Tidak ada deskripsi."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Units of Competency Section
                  Text(
                    "Unit Kompetensi (${units.length})",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  units.isEmpty
                      ? _buildEmptyState("Belum ada unit kompetensi terdaftar.")
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: units.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildListTile(units[index].toString());
                          },
                        ),
                  const SizedBox(height: 30),

                  // Activities Section
                  Text(
                    "Aktivitas Pelatihan (${activities.length})",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  activities.isEmpty
                      ? _buildEmptyState("Belum ada aktivitas terdaftar.")
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildListTile(activities[index].toString());
                          },
                        ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderMeta(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueGrey, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: GoogleFonts.outfit(
                    color: Colors.blueGrey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade900.withOpacity(0.5)),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.outfit(color: Colors.blueGrey.shade400, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildListTile(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade900),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF1677FF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
