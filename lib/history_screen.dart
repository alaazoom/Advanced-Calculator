import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advanced_calculator/app_theme.dart';
import 'package:advanced_calculator/calc_controller.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CalculatorController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
            color: AppColors.cyan, size: 18.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('السجل',
          style: GoogleFonts.dmMono(
            color: AppColors.textPri, fontSize: 16.sp)),
        actions: [
          Obx(() => ctrl.history.isNotEmpty
            ? TextButton.icon(
                onPressed: () {
                  Get.dialog(AlertDialog(
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r)),
                    title: Text('مسح السجل؟',
                      style: GoogleFonts.dmMono(color: AppColors.textPri)),
                    content: Text('سيتم حذف كل العمليات السابقة',
                      style: GoogleFonts.dmMono(color: AppColors.textSec, fontSize: 13.sp)),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('إلغاء',
                          style: GoogleFonts.dmMono(color: AppColors.textSec))),
                      TextButton(
                        onPressed: () { ctrl.clearHistory(); Get.back(); },
                        child: Text('مسح',
                          style: GoogleFonts.dmMono(color: AppColors.pink))),
                    ],
                  ));
                },
                icon: Icon(Icons.delete_outline_rounded,
                  color: AppColors.pink, size: 16.sp),
                label: Text('مسح الكل',
                  style: GoogleFonts.dmMono(
                    color: AppColors.pink, fontSize: 12.sp)),
              )
            : const SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.history.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded,
                  color: AppColors.textDim, size: 64.sp),
                SizedBox(height: 12.h),
                Text('لا يوجد سجل بعد',
                  style: GoogleFonts.dmMono(
                    color: AppColors.textDim, fontSize: 15.sp)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: ctrl.history.length,
          itemBuilder: (_, i) {
            final item = ctrl.history[i];
            return GestureDetector(
              onTap: () {
                ctrl.useHistoryItem(item);
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.cyan.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(item.time),
                      style: GoogleFonts.dmMono(
                        fontSize: 10.sp, color: AppColors.textDim),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.expression,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.dmMono(
                        fontSize: 13.sp, color: AppColors.textSec),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.subdirectory_arrow_left_rounded,
                          color: AppColors.cyan, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          item.result,
                          style: GoogleFonts.dmMono(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1)  return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24)   return 'منذ ${diff.inHours} ساعة';
    return '${t.day}/${t.month} ${t.hour}:${t.minute.toString().padLeft(2, '0')}';
  }
}
