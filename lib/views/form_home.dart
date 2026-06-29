import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_api_crypto/models/crypto_models.dart';
import 'package:tugas_api_crypto/services/api_services.dart';
import 'package:tugas_api_crypto/services/dio_client.dart';
import 'package:tugas_api_crypto/views/coindetail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService apiService;
  late Future<List<CryptoModels>> futureCrypto;

  @override
  void initState() {
    super.initState();

    final dio = createDioClient();
    apiService = ApiService(dio);

    futureCrypto = apiService.getAllPosts("idr");
  }

  String formatRupiah(num? value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),

      body: SafeArea(
        child: FutureBuilder<List<CryptoModels>>(
          future: futureCrypto,

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final crypto = snapshot.data!;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  futureCrypto = apiService.getAllPosts("idr");
                });
              },

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// HEADER
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),

                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.blue,

                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: const Center(
                              child: Text(
                                "|<",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            "KAIS CRYPTO",

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          IconButton(
                            onPressed: () {},

                            icon: const Icon(Icons.notifications_none),
                          ),

                          const CircleAvatar(
                            radius: 18,

                            child: Icon(Icons.person),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// OVERVIEW TITLE
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),

                      child: Text(
                        "Market Overview",

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// MARKET CARD
                    SizedBox(
                      height: 240,

                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),

                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        itemCount: 4,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,

                              mainAxisSpacing: 12,

                              crossAxisSpacing: 12,

                              childAspectRatio: 1.5,
                            ),

                        itemBuilder: (context, index) {
                          final coin = crypto[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CoinDetailScreen(crypto: coin),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(18),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.15),

                                    blurRadius: 8,
                                  ),
                                ],
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          coin.image ?? "",
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Text(
                                        (coin.symbol ?? "").toUpperCase(),

                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  Text(
                                    formatRupiah(coin.currentPrice),

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "${(coin.priceChangePercentage24H ?? 0).toStringAsFixed(2)}%",

                                    style: TextStyle(
                                      color:
                                          (coin.priceChangePercentage24H ??
                                                  0) >=
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// BANNER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),

                      child: Container(
                        height: 150,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                          gradient: const LinearGradient(
                            colors: [Color(0xff2563EB), Color(0xff4F8DFD)],
                          ),
                        ),

                        child: const Padding(
                          padding: EdgeInsets.all(20),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Trade Crypto Smarter",

                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: 22,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                "Realtime Market\nPowered by CoinGecko",

                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// TRENDING TITLE
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),

                      child: Text(
                        "Trending Coins",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 130,

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,

                        itemCount: 10,

                        itemBuilder: (context, index) {
                          final coin = crypto[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CoinDetailScreen(crypto: coin),
                                ),
                              );
                            },
                            child: Container(
                              width: 140,

                              margin: EdgeInsets.only(
                                left: index == 0 ? 20 : 10,
                              ),

                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      coin.image ?? "",
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    (coin.symbol ?? "").toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    formatRupiah(coin.currentPrice),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
