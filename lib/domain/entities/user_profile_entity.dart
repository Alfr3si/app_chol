class UserProfileEntity {
  final String alias;
  final String ageRange;
  final String avatarPath;
  final String rankTitle;
  final int completedThemes;
  final List<String> unlockedInsignias;

  const UserProfileEntity({
    required this.alias,
    required this.ageRange,
    required this.avatarPath,
    required this.rankTitle,
    required this.completedThemes,
    required this.unlockedInsignias,
  });

  // Copiar con cambios para actualizar localmente de manera inmutable
  UserProfileEntity copyWith({
    String? alias,
    String? ageRange,
    String? avatarPath,
    String? rankTitle,
    int? completedThemes,
    List<String>? unlockedInsignias,
  }) {
    return UserProfileEntity(
      alias: alias ?? this.alias,
      ageRange: ageRange ?? this.ageRange,
      avatarPath: avatarPath ?? this.avatarPath,
      rankTitle: rankTitle ?? this.rankTitle,
      completedThemes: completedThemes ?? this.completedThemes,
      unlockedInsignias: unlockedInsignias ?? this.unlockedInsignias,
    );
  }
}
