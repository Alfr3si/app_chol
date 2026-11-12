import 'dart:math';
import 'package:flutter/material.dart';

class ModuleCarousel extends StatelessWidget {
  final PageController pageController;
  final List<Map<String, String>> modulos;
  final void Function(String idModulo, String titulo) onModuloSelected;

  const ModuleCarousel({
    super.key,
    required this.pageController,
    required this.modulos,
    required this.onModuloSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double currentPageValue = 0.0;
        if (pageController.hasClients &&
            pageController.position.haveDimensions) {
          currentPageValue = pageController.page ?? 0.0;
        }

        return Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 340,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: modulos.length,
                    itemBuilder: (context, index) {
                      double scale = max(
                        0.85,
                        (1.0 - (currentPageValue - index).abs() * 0.25),
                      );

                      double translateY =
                          (currentPageValue - index).abs() * 15.0;

                      final modulo = modulos[index];
                      final bool isCurrent =
                          (index == currentPageValue.round());

                      return Center(
                        child: Transform.translate(
                          offset: Offset(0, translateY),
                          child: Transform.scale(
                            scale: scale,
                            child: GestureDetector(
                              onTap: () {
                                if (!isCurrent) {
                                  pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  onModuloSelected(
                                    modulo['id']!,
                                    modulo['titulo']!,
                                  );
                                }
                              },
                              child: Container(
                                width: 446,
                                height: 252,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(modulo['tarjeta']!),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                modulos.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 15,
                  ),
                  width: (currentPageValue.round() == index) ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: (currentPageValue.round() == index)
                        ? Colors.orange
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
