import 'package:advanced_calculator/app_theme.dart';
import 'package:advanced_calculator/calc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class CalcDisplay extends StatelessWidget {
  const CalcDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CalculatorController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(() => ctrl.memory.value != 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.violet.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.violet.withOpacity(0.3)),
                ),
                child: Text(
                  'M = ${ctrl.memory.value}',
                  style: GoogleFonts.dmMono(
                    fontSize: 10.sp, color: AppColors.violet,
                  ),
                ),
              )
            : const SizedBox(),
          ),
          SizedBox(height: 6.h),

          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              key: ValueKey(ctrl.expression.value),
              ctrl.expression.value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmMono(
                fontSize: 14.sp,
                color: AppColors.textSec,
                height: 1.5,
              ),
            ),
          )),
          SizedBox(height: 8.h),

          Obx(() {
            final text = ctrl.display.value;
            final fontSize = text.length > 12 ? 32.sp
                : text.length > 8 ? 42.sp : 52.sp;
            return AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: GoogleFonts.dmMono(
                fontSize: fontSize,
                fontWeight: FontWeight.w300,
                color: ctrl.hasResult.value ? AppColors.cyan : AppColors.textPri,
                height: 1,
              ),
              child: Text(
                text,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() => _StatusChip(
                label: ctrl.isDegree.value ? 'DEG' : 'RAD',
                color: AppColors.orange,
              )),
              SizedBox(width: 8.w),
              Obx(() => ctrl.isInverse.value
                ? _StatusChip(label: 'INV', color: AppColors.pink)
                : const SizedBox(),
              ),
              SizedBox(width: 8.w),
              Obx(() => _StatusChip(
                label: ctrl.mode.value == CalcMode.scientific ? 'SCI' : 'STD',
                color: AppColors.cyan,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
        style: GoogleFonts.dmMono(
          fontSize: 9.sp, color: color, fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
