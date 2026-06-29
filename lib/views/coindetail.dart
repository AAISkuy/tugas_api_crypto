import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_api_crypto/models/crypto_models.dart';

class CoinDetailScreen extends StatelessWidget {
  final CryptoModels crypto;

  const CoinDetailScreen({super.key, required this.crypto});

  String formatCurrency(num value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  String formatNumber(num value) {
    return NumberFormat.compact(locale: 'id_ID').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isUp = (crypto.priceChangePercentage24H ?? 0) >= 0;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: Text(
          crypto.name ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.black),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.star_border),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Hero(
                tag: crypto.id ?? "",
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(crypto.image ?? ""),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                crypto.name ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  (crypto.symbol ?? "").toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                formatCurrency(crypto.currentPrice ?? 0),

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isUp ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.trending_up : Icons.trending_down,
                      color: isUp ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${(crypto.priceChangePercentage24H ?? 0).toStringAsFixed(2)} %",
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPriceChart(isUp),
              ),

              const SizedBox(height: 25),

              // ============================
              // MARKET STATISTICS
              // ============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Market Statistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildStatRow(
                        "Market Rank",
                        "#${crypto.marketCapRank ?? "-"}",
                      ),

                      const Divider(),

                      _buildStatRow(
                        "Market Cap",
                        formatCurrency(crypto.marketCap ?? 0),
                      ),

                      const Divider(),

                      _buildStatRow(
                        "24H Volume",
                        formatCurrency(crypto.totalVolume ?? 0),
                      ),

                      const Divider(),

                      _buildStatRow(
                        "High 24H",
                        formatCurrency(crypto.high24H ?? 0),
                      ),

                      const Divider(),

                      _buildStatRow(
                        "Low 24H",
                        formatCurrency(crypto.low24H ?? 0),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ============================
              // ATH & ATL
              // ============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.green),

                            const SizedBox(height: 10),

                            const Text(
                              "All Time High",
                              style: TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              formatCurrency(crypto.ath ?? 0),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.red),

                            const SizedBox(height: 10),

                            const Text(
                              "All Time Low",
                              style: TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              formatCurrency(crypto.atl ?? 0),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ============================
              // ABOUT
              // ============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "About Coin",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "${crypto.name} (${(crypto.symbol ?? "").toUpperCase()}) "
                        "is one of the cryptocurrencies listed on CoinGecko. "
                        "This page displays real-time market information including "
                        "price, market capitalization, trading volume, "
                        "24-hour performance, and historical all-time high/low values.",

                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ============================
              // LAST UPDATED
              // ============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Last Updated",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              crypto.lastUpdated
                                      ?.toString()
                                      .replaceFirst("T", " ")
                                      .substring(0, 19) ??
                                  "-",

                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 15)),

          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart(bool isUp) {
    final List<FlSpot> spots = isUp
        ? const [
            FlSpot(0, 2.8),
            FlSpot(1, 3.3),
            FlSpot(2, 3.1),
            FlSpot(3, 4.2),
            FlSpot(4, 3.9),
            FlSpot(5, 5.3),
            FlSpot(6, 5.0),
            FlSpot(7, 6.2),
          ]
        : const [
            FlSpot(0, 6.2),
            FlSpot(1, 5.8),
            FlSpot(2, 6.0),
            FlSpot(3, 4.8),
            FlSpot(4, 5.1),
            FlSpot(5, 3.8),
            FlSpot(6, 3.5),
            FlSpot(7, 2.9),
          ];

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 7,
          minY: 2,
          maxY: 7,

          gridData: const FlGridData(show: false),

          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          borderData: FlBorderData(show: false),

          lineBarsData: [
            LineChartBarData(
              spots: spots,

              isCurved: true,

              color: isUp ? Colors.green : Colors.red,

              barWidth: 4,

              isStrokeCapRound: true,

              dotData: const FlDotData(show: false),

              belowBarData: BarAreaData(
                show: true,
                color: (isUp ? Colors.green : Colors.red).withOpacity(.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
