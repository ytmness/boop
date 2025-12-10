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
  late List<Animation<double>> _pressAnimations;
  late List<Animation<double>> _blurAnimations;
  late List<Animation<double>> _glassOpacityAnimations;
  late List<Animation<double>> _scaleAnimations;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        CupertinoColors.white.withOpacity(0.15),
                        CupertinoColors.white.withOpacity(0.10),
                        CupertinoColors.white.withOpacity(0.08),
                      ]
                    : [
                        CupertinoColors.white.withOpacity(0.85),
                        CupertinoColors.white.withOpacity(0.75),
                        CupertinoColors.white.withOpacity(0.70),
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? CupertinoColors.white.withOpacity(0.1)
                      : CupertinoColors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    widget.items.length,
                    (index) => _buildNavItem(
                      context,
                      widget.items[index],
                      index,
                      isDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    int index,
    bool isDark,
  ) {
    final isSelected = widget.currentIndex == index;
    final pressAnimation = _pressAnimations[index];
    final blurAnimation = _blurAnimations[index];
    final glassOpacityAnimation = _glassOpacityAnimations[index];
    final scaleAnimation = _scaleAnimations[index];

    return Expanded(
      child: GestureDetector(
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

            return Transform.scale(
              scale: buttonScale,
              alignment: Alignment.center,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Contenedor glass para el icono (similar a los botones de eventos)
                    Container(
                      padding: EdgeInsets.all(isSelected ? 10 : 8),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Branding.radiusMedium),
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Branding.primaryPurple
                                      .withOpacity(0.4 + glassOpacity),
                                  Branding.accentViolet
                                      .withOpacity(0.3 + glassOpacity),
                                  Branding.primaryPurple
                                      .withOpacity(0.25 + glassOpacity),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              )
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        CupertinoColors.white
                                            .withOpacity(0.08 + glassOpacity),
                                        CupertinoColors.white
                                            .withOpacity(0.05 + glassOpacity),
                                      ]
                                    : [
                                        CupertinoColors.white
                                            .withOpacity(0.6 + glassOpacity),
                                        CupertinoColors.white
                                            .withOpacity(0.4 + glassOpacity),
                                      ],
                              ),
                        border: Border.all(
                          color: isSelected
                              ? Branding.primaryPurple
                                  .withOpacity(0.3 + glassOpacity)
                              : (isDark
                                  ? CupertinoColors.white
                                      .withOpacity(0.1 + glassOpacity)
                                  : CupertinoColors.black
                                      .withOpacity(0.08 + glassOpacity)),
                          width: isSelected ? 1.0 : 0.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Branding.primaryPurple
                                      .withOpacity(0.3 + glassOpacity),
                                  blurRadius: 12,
                                  spreadRadius: -2,
                                  offset: const Offset(0, 4),
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
                              size: isSelected ? 28 : 24,
                              color: isSelected
                                  ? Branding.primaryPurple
                                  : (isDark
                                      ? CupertinoColors.white.withOpacity(0.7)
                                      : CupertinoColors.black.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (item.label != null) ...[
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          fontSize: isSelected ? 12 : 11,
                          fontWeight: isSelected
                              ? Branding.weightSemibold
                              : Branding.weightRegular,
                          color: isSelected
                              ? Branding.primaryPurple
                              : (isDark
                                  ? CupertinoColors.white.withOpacity(0.6)
                                  : CupertinoColors.black.withOpacity(0.5)),
                          letterSpacing: isSelected ? -0.2 : -0.1,
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
