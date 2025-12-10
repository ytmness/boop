import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';

class GlassBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<GlassBottomNavBar> createState() => _GlassBottomNavBarState();
}

class _GlassBottomNavBarState extends State<GlassBottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _pressControllers;
  late List<AnimationController> _selectionControllers;
  late AnimationController
      _glowController; // Controlador para glow constante del botón central
  late List<Animation<double>> _pressAnimations;
  late List<Animation<double>> _blurAnimations;
  late List<Animation<double>> _glassOpacityAnimations;
  late List<Animation<double>> _scaleAnimations;
  late Animation<double> _glowAnimation; // Animación de glow pulsante

  @override
  void initState() {
    super.initState();
    _pressControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
      ),
    );
    _selectionControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
        value: widget.currentIndex == index ? 1.0 : 0.0,
      ),
    );

    // Controlador para glow constante del botón central
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _pressAnimations = _pressControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ),
      );
    }).toList();

    _blurAnimations = _pressControllers.map((controller) {
      return Tween<double>(begin: 10.0, end: 25.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ),
      );
    }).toList();

    _glassOpacityAnimations = _pressControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ),
      );
    }).toList();

    _scaleAnimations = _selectionControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(GlassBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Animar la selección anterior hacia fuera
      if (oldWidget.currentIndex >= 0 &&
          oldWidget.currentIndex < _selectionControllers.length) {
        _selectionControllers[oldWidget.currentIndex].reverse();
      }
      // Animar la nueva selección hacia dentro
      if (widget.currentIndex >= 0 &&
          widget.currentIndex < _selectionControllers.length) {
        _selectionControllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _pressControllers) {
      controller.dispose();
    }
    for (var controller in _selectionControllers) {
      controller.dispose();
    }
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final newDarkBackground = const Color(0xFF080C32);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Isla flotante del bottom nav bar
        Padding(
          padding: EdgeInsets.only(
            bottom:
                24 + MediaQuery.of(context).padding.bottom, // Subido más arriba
            left: 20,
            right: 20,
          ),
          child: Container(
            height: 80, // Aumentado el tamaño
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: -10,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: newDarkBackground.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: -5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        newDarkBackground.withOpacity(0.5),
                        Colors.black.withOpacity(0.4),
                        newDarkBackground.withOpacity(0.3),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    border: Border.all(
                      color: CupertinoColors.white.withOpacity(0.1),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Botones izquierda (0, 1)
                        for (int i = 0; i < 2 && i < widget.items.length; i++)
                          Expanded(
                            child: _buildNavItem(
                              context,
                              widget.items[i],
                              i,
                              isDark,
                              newDarkBackground,
                            ),
                          ),
                        // Espacio para el botón flotante central
                        const SizedBox(
                            width: 56), // Espacio para el botón central
                        // Botones derecha (3, 4)
                        for (int i = 3; i < widget.items.length; i++)
                          Expanded(
                            child: _buildNavItem(
                              context,
                              widget.items[i],
                              i,
                              isDark,
                              newDarkBackground,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Botón central (+) flotante con glow (fuera del contenedor para que sobresalga)
        if (widget.items.length >= 3)
          Positioned(
            bottom: 24 +
                MediaQuery.of(context).padding.bottom +
                8, // Bajado un poco
            left: 0,
            right: 0,
            child: Center(
              child: _buildFloatingCreateButton(
                context,
                widget.items[2],
                isDark,
                newDarkBackground,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    int index,
    bool isDark,
    Color darkBackground,
  ) {
    final isSelected = widget.currentIndex == index;
    final pressAnimation = _pressAnimations[index];
    final blurAnimation = _blurAnimations[index];
    final glassOpacityAnimation = _glassOpacityAnimations[index];
    final scaleAnimation = _scaleAnimations[index];

    return GestureDetector(
      onTapDown: (_) {
        _pressControllers[index].forward();
      },
      onTapUp: (_) {
        _pressControllers[index].reverse();
        widget.onTap(index);
      },
      onTapCancel: () {
        _pressControllers[index].reverse();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          pressAnimation,
          blurAnimation,
          glassOpacityAnimation,
          scaleAnimation,
        ]),
        builder: (context, child) {
          final buttonScale = pressAnimation.value;
          final iconScale = isSelected ? scaleAnimation.value : 1.0;
          final blurValue = isSelected
              ? (15.0 + (blurAnimation.value - 10.0))
              : blurAnimation.value;
          final glassOpacity = isSelected
              ? (0.3 + (glassOpacityAnimation.value * 0.2))
              : glassOpacityAnimation.value * 0.15;

          // Todos los botones del mismo tamaño
          final iconBaseSize = 22.0; // Reducido ligeramente
          final iconSelectedSize = 26.0; // Reducido ligeramente
          final paddingBase = 6.0; // Reducido
          final paddingSelected = 8.0; // Reducido

          return Transform.scale(
            scale: buttonScale,
            alignment: Alignment.center,
            child: Container(
              height: 60, // Todos del mismo tamaño
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Contenedor glass para el icono (similar a los botones de eventos)
                  Container(
                    padding: EdgeInsets.all(
                        isSelected ? paddingSelected : paddingBase),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Branding.radiusMedium),
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                darkBackground.withOpacity(0.5 + glassOpacity),
                                Colors.black.withOpacity(0.4 + glassOpacity),
                                darkBackground.withOpacity(0.3 + glassOpacity),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            )
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                darkBackground.withOpacity(0.2 + glassOpacity),
                                Colors.black.withOpacity(0.15 + glassOpacity),
                              ],
                            ),
                      border: Border.all(
                        color: CupertinoColors.white.withOpacity(isSelected
                            ? 0.25 + glassOpacity
                            : 0.1 + glassOpacity),
                        width: isSelected ? 1.5 : 0.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              // Glow principal cuando está seleccionado
                              BoxShadow(
                                color: darkBackground
                                    .withOpacity(0.5 + glassOpacity),
                                blurRadius: 16,
                                spreadRadius: -2,
                                offset: const Offset(0, 4),
                              ),
                              // Glow blanco suave adicional
                              BoxShadow(
                                color: CupertinoColors.white
                                    .withOpacity(0.15 + glassOpacity),
                                blurRadius: 12,
                                spreadRadius: -1,
                                offset: const Offset(0, -2),
                              ),
                              // Glow exterior para profundidad
                              BoxShadow(
                                color: darkBackground
                                    .withOpacity(0.3 + glassOpacity),
                                blurRadius: 24,
                                spreadRadius: -4,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Branding.radiusMedium),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blurValue,
                          sigmaY: blurValue,
                        ),
                        child: Transform.scale(
                          scale: iconScale,
                          alignment: Alignment.center,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: isSelected ? iconSelectedSize : iconBaseSize,
                            color: isSelected
                                ? CupertinoColors.white.withOpacity(
                                    1.0) // Más brillante cuando está seleccionado
                                : CupertinoColors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (item.label != null) ...[
                    const SizedBox(height: 4), // Reducido de 6 a 4
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        fontSize:
                            isSelected ? 10 : 9, // Reducido el tamaño de fuente
                        fontWeight: isSelected
                            ? Branding.weightSemibold
                            : Branding.weightRegular,
                        color: isSelected
                            ? CupertinoColors.white.withOpacity(0.9)
                            : CupertinoColors.white.withOpacity(0.6),
                        letterSpacing: isSelected ? -0.2 : -0.1,
                        height: 1.0, // Altura de línea reducida
                      ),
                      child: Text(
                        item.label!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingCreateButton(
    BuildContext context,
    BottomNavItem item,
    bool isDark,
    Color darkBackground,
  ) {
    final isSelected = widget.currentIndex == 2;
    final pressAnimation = _pressAnimations[2];
    final blurAnimation = _blurAnimations[2];
    final glassOpacityAnimation = _glassOpacityAnimations[2];
    final scaleAnimation = _scaleAnimations[2];

    return GestureDetector(
      onTapDown: (_) {
        _pressControllers[2].forward();
      },
      onTapUp: (_) {
        _pressControllers[2].reverse();
        widget.onTap(2);
      },
      onTapCancel: () {
        _pressControllers[2].reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          pressAnimation,
          blurAnimation,
          glassOpacityAnimation,
          scaleAnimation,
          _glowAnimation, // Agregar animación de glow constante
        ]),
        builder: (context, child) {
          final buttonScale = pressAnimation.value;
          final iconScale = isSelected
              ? scaleAnimation.value
              : 1.15; // Más grande cuando está seleccionado
          final blurValue = isSelected
              ? (20.0 + (blurAnimation.value - 10.0))
              : blurAnimation.value;
          final glassOpacity = isSelected
              ? (0.4 + (glassOpacityAnimation.value * 0.2))
              : glassOpacityAnimation.value * 0.2;

          // Glow pulsante constante
          final glowIntensity = _glowAnimation.value;
          final baseGlowOpacity = 0.5 + (glowIntensity * 0.2);

          return Transform.translate(
            offset: const Offset(0, -12), // Bajado un poco
            child: Transform.scale(
              scale: buttonScale,
              alignment: Alignment.center,
              child: Container(
                width: 56, // Mismo tamaño que los otros botones
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      darkBackground.withOpacity(0.7 + glassOpacity),
                      Colors.black.withOpacity(0.6 + glassOpacity),
                      darkBackground.withOpacity(0.5 + glassOpacity),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: CupertinoColors.white.withOpacity(
                        0.2 + glassOpacity + (glowIntensity * 0.1)),
                    width: 1.5,
                  ),
                  boxShadow: [
                    // Glow pulsante principal con azul oscuro
                    BoxShadow(
                      color: darkBackground
                          .withOpacity(baseGlowOpacity + glassOpacity),
                      blurRadius: 25 + (glowIntensity * 10),
                      spreadRadius: -5 + (glowIntensity * 2),
                      offset: const Offset(0, 10),
                    ),
                    // Glow blanco suave pulsante alrededor
                    BoxShadow(
                      color: CupertinoColors.white.withOpacity(
                          0.15 + glassOpacity + (glowIntensity * 0.1)),
                      blurRadius: 20 + (glowIntensity * 8),
                      spreadRadius: -3 + (glowIntensity * 1),
                      offset: const Offset(0, -3),
                    ),
                    // Glow adicional para profundidad
                    BoxShadow(
                      color: darkBackground.withOpacity(
                          0.4 + glassOpacity + (glowIntensity * 0.15)),
                      blurRadius: 35 + (glowIntensity * 15),
                      spreadRadius: -8 + (glowIntensity * 3),
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurValue + 10,
                      sigmaY: blurValue + 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            CupertinoColors.white
                                .withOpacity(0.1 + glassOpacity),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Transform.scale(
                          scale: iconScale,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: isSelected
                                ? 28
                                : 24, // Mismo tamaño que los otros
                            color: CupertinoColors.white
                                .withOpacity(0.95 + (glowIntensity * 0.05)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String? label;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    this.label,
  });
}
