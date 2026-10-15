import 'package:flutter/material.dart';

class LevelCardWidget extends StatelessWidget {
  final int levelNumber;
  final String title;
  final String description;
  final bool isUnlocked;
  final Color color;
  final VoidCallback? onTap;

  const LevelCardWidget({
    super.key,
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color.withOpacity(0.5) : Colors.white12,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isUnlocked ? color.withOpacity(0.2) : Colors.white10,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(
                            '$levelNumber',
                            style: TextStyle(
                              color: color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.lock_rounded, color: Colors.white38, size: 22),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel $levelNumber: $title',
                        style: TextStyle(
                          color: isUnlocked ? Colors.white : Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isUnlocked ? Icons.play_arrow_rounded : Icons.lock_outline_rounded,
                  color: isUnlocked ? color : Colors.white38,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
