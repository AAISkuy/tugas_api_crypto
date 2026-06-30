class ImageUtils {
  static String sanitizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return "";

    String sanitized = url;
    // Replace localhost or 127.0.0.1 with the actual public host (appabsensi.mobileprojp.com)
    if (sanitized.contains("127.0.0.1:8000")) {
      sanitized = sanitized.replaceAll("127.0.0.1:8000", "appabsensi.mobileprojp.com");
    }
    if (sanitized.contains("localhost:8000")) {
      sanitized = sanitized.replaceAll("localhost:8000", "appabsensi.mobileprojp.com");
    }

    // Support fallback replacement of the old absensib1 domain to the active appabsensi domain
    if (sanitized.contains("absensib1.mobileprojp.com")) {
      sanitized = sanitized.replaceAll("absensib1.mobileprojp.com", "appabsensi.mobileprojp.com");
    }

    // If it's a relative path, prepend host and correct paths
    if (!sanitized.startsWith("http")) {
      if (sanitized.startsWith("public/profile_photo/")) {
        sanitized = "https://appabsensi.mobileprojp.com/$sanitized";
      } else if (sanitized.startsWith("profile_photo/")) {
        sanitized = "https://appabsensi.mobileprojp.com/public/$sanitized";
      } else {
        sanitized = "https://appabsensi.mobileprojp.com/public/profile_photo/$sanitized";
      }
    } else {
      // Ensure secure HTTPS protocol if it points to either PPKD domain
      if (sanitized.startsWith("http://appabsensi.mobileprojp.com")) {
        sanitized = sanitized.replaceAll("http://appabsensi.mobileprojp.com", "https://appabsensi.mobileprojp.com");
      }
      if (sanitized.startsWith("http://absensib1.mobileprojp.com")) {
        sanitized = sanitized.replaceAll("http://absensib1.mobileprojp.com", "https://appabsensi.mobileprojp.com");
      }
    }

    // Clean up any double/duplicate folder paths (e.g. public/profile_photo/profile_photo/)
    if (sanitized.contains("public/profile_photo/profile_photo/")) {
      sanitized = sanitized.replaceAll("public/profile_photo/profile_photo/", "public/profile_photo/");
    }

    // Append unique timestamp to bust Flutter's image caching
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    if (sanitized.contains("?")) {
      return "$sanitized&t=$timestamp";
    } else {
      return "$sanitized?t=$timestamp";
    }
  }
}
