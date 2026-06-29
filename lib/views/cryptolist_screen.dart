import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_api_crypto/models/crypto_models.dart';
import 'package:tugas_api_crypto/services/api_services.dart';
import 'package:tugas_api_crypto/services/dio_client.dart';

class Cryptolistscreen extends StatefulWidget {
  const Cryptolistscreen({super.key});

  @override
  State<Cryptolistscreen> createState() => _CryptolistscreenState();
}

class _CryptolistscreenState extends State<Cryptolistscreen> {
  String formatRupiah(num amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  late final ApiService _apiService;
  late Future<List<CryptoModels>> _postsFuture;
  void searchCrypto(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPosts = allPosts;
      } else {
        filteredPosts = allPosts.where((crypto) {
          return (crypto.name ?? "").toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              (crypto.symbol ?? "").toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  List<CryptoModels> allPosts = [];
  List<CryptoModels> filteredPosts = [];

  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiService = ApiService(dio);
    _postsFuture = _apiService.getAllPosts('idr');
  }

  void _refreshPost() {
    setState(() {
      _postsFuture = _apiService.getAllPosts('idr');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CryptoModels>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshPost,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data post.'));
          }

          final posts = snapshot.data!;
          if (allPosts.isEmpty) {
            allPosts = posts;
            filteredPosts = posts;
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    onChanged: searchCrypto,
                    decoration: InputDecoration(
                      hintText: "Cari Coin...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchCrypto('');
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshPost(),
                    child: ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(post.image ?? ""),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (post.symbol ?? "").toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Text(
                                      post.name ?? "",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatRupiah(post.currentPrice ?? 0),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  Text(
                                    "Rank #${post.marketCapRank ?? ''}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 16),

                              Container(
                                width: 90,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      (post.priceChangePercentage24H ?? 0) >= 0
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${(post.priceChangePercentage24H ?? 0).toStringAsFixed(2)}%",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
