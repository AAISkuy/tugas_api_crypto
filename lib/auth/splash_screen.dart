import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_api_crypto/auth/form_login.dart';
import 'package:tugas_api_crypto/database/preferences_handler.dart';
import 'package:tugas_api_crypto/extension/extension.dart';
import 'package:tugas_api_crypto/widgets/bot_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "/splash";
  @override
  State<SplashScreen> createState() => Splash_Screen();
}

class Splash_Screen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;
    if (PreferencesHandler.isLogin) {
      context.pushAndRemoveAll(AppBottomnav());
    } else {
      context.pushAndRemoveAll(const Formlogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "|<",
                      style: GoogleFonts.inter(
                        fontSize: 70,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1677FF),
                      ),
                    ),

                    const SizedBox(width: 12),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "KAIS ",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "CRYPTO",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1677FF),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Text(
                  "KAIS CRYPTO",
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "TRACK THE FUTURE",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    letterSpacing: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
