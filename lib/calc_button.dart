import 'package:advanced_calculator/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
enum BtnType { number, operator, function, equals, clear, special }

class CalcButton extends StatefulWidget {
  final String label;
  final String? subLabel;  
  final BtnType type;
  final VoidCallback onTap;
  final double? widthFactor; 
  final Color? overrideColor;
  final Color? overrideTextColor;

  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.onTap,
    this.subLabel,
    this.widthFactor,
    this.overrideColor,
    this.overrideTextColor,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  void _onTap() {
    HapticFeedback.lightImpact();
    _anim.forward().then((_) => _anim.reverse());
    widget.onTap();
  }

  Color get _bgColor {
    if (widget.overrideColor != null) return widget.overrideColor!;
    switch (widget.type) {
      case BtnType.number:   return AppColors.btnNumber;
      case BtnType.operator: return AppColors.btnOp;
      case BtnType.function: return AppColors.btnFunc;
      case BtnType.equals:   return AppColors.btnEquals;
      case BtnType.clear:    return AppColors.btnClear;
      case BtnType.special:  return AppColors.surfaceHi;
    }
  }

  Color get _textColor {
    if (widget.overrideTextColor != null) return widget.overrideTextColor!;
    switch (widget.type) {
      case BtnType.equals:   return AppColors.bg;
      case BtnType.operator: return AppColors.violet;
      case BtnType.function: return AppColors.cyan;
      case BtnType.clear:    return AppColors.pink;
      case BtnType.special:  return AppColors.orange;
      default:               return AppColors.textPri;
    }
  }

  Color get _glowColor {
    switch (widget.type) {
      case BtnType.equals:   return AppColors.cyan.withOpacity(0.4);
      case BtnType.operator: return AppColors.violet.withOpacity(0.2);
      case BtnType.function: return AppColors.cyan.withOpacity(0.15);
      case BtnType.clear:    return AppColors.pink.withOpacity(0.2);
      default:               return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final btnH = 58.h;
    final btnW = widget.widthFactor != null
        ? (58.w * widget.widthFactor! + 10.w * (widget.widthFactor! - 1))
        : 58.w;

    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: btnW,
          height: btnH,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: _glowColor,
                blurRadius: 12,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: _textColor.withOpacity(0.08),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.dmMono(
                  fontSize: widget.type == BtnType.equals ? 22.sp : 18.sp,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              if (widget.subLabel != null) ...[
                SizedBox(height: 1.h),
                Text(
                  widget.subLabel!,
                  style: GoogleFonts.dmMono(
                    fontSize: 8.sp,
                    color: _textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
