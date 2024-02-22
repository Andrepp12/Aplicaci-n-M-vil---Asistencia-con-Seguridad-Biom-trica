import 'package:supabase_flutter/supabase_flutter.dart';

class Profile {

  final String name;
  final String email;
  final String avatarUrl;

  Profile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  static Profile fromSupabase(User user) {
    return Profile(
      name: user.userMetadata!['full_name'] ?? '',
      email: user.email ?? '',
      avatarUrl: user.userMetadata!['avatar_url'] ?? '',
    );
  }
}
