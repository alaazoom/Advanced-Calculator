import 'package:advanced_calculator/calc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advanced_calculator/app_theme.dart';
import 'package:advanced_calculator/calc_button.dart';
import 'package:advanced_calculator/calc_display.dart';
import 'package:advanced_calculator/history_screen.dart';
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CalculatorController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => GestureDetector(
                    onTap: ctrl.toggleMode,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHi,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.functions_rounded,
                            color: AppColors.cyan, size: 14.sp),
                          SizedBox(width: 6.w),
                          Text(
                            ctrl.mode.value == CalcMode.standard ? 'العلمية' : 'العادية',
                            style: GoogleFonts.dmMono(
                              fontSize: 11.sp, color: AppColors.cyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

                  Text('حاسبة',
                    style: GoogleFonts.dmMono(
                      fontSize: 14.sp, color: AppColors.textSec,
                      letterSpacing: 2,
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Get.to(() => const HistoryScreen(),
                      transition: Transition.rightToLeft),
                    child: Container(
                      padding: EdgeInsets.all(9.w),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHi,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.violet.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.history_rounded,
                        color: AppColors.violet, size: 18.sp),
                    ),
                  ),
                ],
              ),
            ),

            const CalcDisplay(),

            SizedBox(height: 16.h),

            Expanded(
              child: Obx(() => ctrl.mode.value == CalcMode.standard
                ? _StandardPad(ctrl: ctrl)
                : _ScientificPad(ctrl: ctrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _StandardPad extends StatelessWidget {
  final CalculatorController ctrl;
  const _StandardPad({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(label: 'MC', type: BtnType.special, onTap: ctrl.memoryClear),
              CalcButton(label: 'MR', type: BtnType.special, onTap: ctrl.memoryRecall),
              CalcButton(label: 'M+', type: BtnType.special, onTap: ctrl.memoryAdd),
              CalcButton(label: 'M−', type: BtnType.special, onTap: ctrl.memorySub),
            ],
          ),
          _row([
            CalcButton(label: 'AC', type: BtnType.clear, onTap: ctrl.onClear),
            CalcButton(label: '+/−', type: BtnType.special, onTap: ctrl.onToggleSign),
            CalcButton(label: '%', type: BtnType.special, onTap: ctrl.onPercent),
            CalcButton(label: '÷', type: BtnType.operator, onTap: () => ctrl.onOperator('÷')),
          ]),
          _row([
            CalcButton(label: '7', type: BtnType.number, onTap: () => ctrl.onDigit('7')),
            CalcButton(label: '8', type: BtnType.number, onTap: () => ctrl.onDigit('8')),
            CalcButton(label: '9', type: BtnType.number, onTap: () => ctrl.onDigit('9')),
            CalcButton(label: '×', type: BtnType.operator, onTap: () => ctrl.onOperator('×')),
          ]),
          _row([
            CalcButton(label: '4', type: BtnType.number, onTap: () => ctrl.onDigit('4')),
            CalcButton(label: '5', type: BtnType.number, onTap: () => ctrl.onDigit('5')),
            CalcButton(label: '6', type: BtnType.number, onTap: () => ctrl.onDigit('6')),
            CalcButton(label: '−', type: BtnType.operator, onTap: () => ctrl.onOperator('-')),
          ]),
          _row([
            CalcButton(label: '1', type: BtnType.number, onTap: () => ctrl.onDigit('1')),
            CalcButton(label: '2', type: BtnType.number, onTap: () => ctrl.onDigit('2')),
            CalcButton(label: '3', type: BtnType.number, onTap: () => ctrl.onDigit('3')),
            CalcButton(label: '+', type: BtnType.operator, onTap: () => ctrl.onOperator('+')),
          ]),
          _row([
            CalcButton(label: '0', type: BtnType.number, onTap: () => ctrl.onDigit('0'),
              widthFactor: 2),
            CalcButton(label: '.', type: BtnType.number, onTap: () => ctrl.onDigit('.')),
            CalcButton(label: '=', type: BtnType.equals, onTap: ctrl.onEquals),
          ]),
        ],
      ),
    );
  }

  Widget _row(List<Widget> children) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: children,
  );
}

class _ScientificPad extends StatelessWidget {
  final CalculatorController ctrl;
  const _ScientificPad({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Obx(() {
        final inv = ctrl.isInverse.value;
        return Column(
          children: [
            _row([
              CalcButton(
                label: inv ? 'DEG' : 'RAD',
                type: BtnType.function,
                onTap: ctrl.toggleDegRad,
              ),
              CalcButton(
                label: inv ? 'INV off' : 'INV',
                type: BtnType.function,
                onTap: ctrl.toggleInverse,
                overrideTextColor: inv ? AppColors.pink : null,
              ),
              CalcButton(label: inv ? '10^x' : 'log', type: BtnType.function,
                subLabel: inv ? 'log⁻¹' : null,
                onTap: () => ctrl.onScientific(inv ? 'pow10' : 'log')),
              CalcButton(label: inv ? 'eˣ' : 'ln', type: BtnType.function,
                subLabel: inv ? 'ln⁻¹' : null,
                onTap: () => ctrl.onScientific(inv ? 'exp' : 'ln')),
              CalcButton(label: '|x|', type: BtnType.function,
                onTap: () => ctrl.onScientific('abs')),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: inv ? 'asin' : 'sin', type: BtnType.function,
                subLabel: inv ? 'sin⁻¹' : null,
                onTap: () => ctrl.onScientific('sin')),
              CalcButton(label: inv ? 'acos' : 'cos', type: BtnType.function,
                subLabel: inv ? 'cos⁻¹' : null,
                onTap: () => ctrl.onScientific('cos')),
              CalcButton(label: inv ? 'atan' : 'tan', type: BtnType.function,
                subLabel: inv ? 'tan⁻¹' : null,
                onTap: () => ctrl.onScientific('tan')),
              CalcButton(label: inv ? 'x²' : '√x', type: BtnType.function,
                subLabel: inv ? null : 'sqrt',
                onTap: () => ctrl.onScientific(inv ? 'x2' : 'sqrt')),
              CalcButton(label: 'x³', type: BtnType.function,
                onTap: () => ctrl.onScientific('x3')),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: 'xʸ', type: BtnType.operator,
                onTap: () => ctrl.onOperator('xʸ')),
              CalcButton(label: 'ʸ√x', type: BtnType.operator,
                onTap: () => ctrl.onOperator('ʸ√x')),
              CalcButton(label: '1/x', type: BtnType.function,
                onTap: () => ctrl.onScientific('inv')),
              CalcButton(label: 'n!', type: BtnType.function,
                onTap: () => ctrl.onScientific('fact')),
              CalcButton(label: 'eˣ', type: BtnType.function,
                onTap: () => ctrl.onScientific('exp')),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: 'π', type: BtnType.special,
                onTap: () => ctrl.onScientific('pi')),
              CalcButton(label: 'e', type: BtnType.special,
                onTap: () => ctrl.onScientific('e')),
              CalcButton(label: 'AC', type: BtnType.clear, onTap: ctrl.onClear),
              CalcButton(label: '⌫', type: BtnType.special, onTap: ctrl.onBackspace),
              CalcButton(label: '%', type: BtnType.special, onTap: ctrl.onPercent),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: '7', type: BtnType.number, onTap: () => ctrl.onDigit('7')),
              CalcButton(label: '8', type: BtnType.number, onTap: () => ctrl.onDigit('8')),
              CalcButton(label: '9', type: BtnType.number, onTap: () => ctrl.onDigit('9')),
              CalcButton(label: '÷', type: BtnType.operator, onTap: () => ctrl.onOperator('÷')),
              CalcButton(label: '×', type: BtnType.operator, onTap: () => ctrl.onOperator('×')),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: '4', type: BtnType.number, onTap: () => ctrl.onDigit('4')),
              CalcButton(label: '5', type: BtnType.number, onTap: () => ctrl.onDigit('5')),
              CalcButton(label: '6', type: BtnType.number, onTap: () => ctrl.onDigit('6')),
              CalcButton(label: '−', type: BtnType.operator, onTap: () => ctrl.onOperator('-')),
              CalcButton(label: '+', type: BtnType.operator, onTap: () => ctrl.onOperator('+')),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: '1', type: BtnType.number, onTap: () => ctrl.onDigit('1')),
              CalcButton(label: '2', type: BtnType.number, onTap: () => ctrl.onDigit('2')),
              CalcButton(label: '3', type: BtnType.number, onTap: () => ctrl.onDigit('3')),
              CalcButton(label: '+/−', type: BtnType.special, onTap: ctrl.onToggleSign),
              CalcButton(label: '=', type: BtnType.equals, onTap: ctrl.onEquals),
            ]),
            SizedBox(height: 8.h),
            _row([
              CalcButton(label: '0', type: BtnType.number,
                onTap: () => ctrl.onDigit('0'), widthFactor: 2),
              CalcButton(label: '.', type: BtnType.number, onTap: () => ctrl.onDigit('.')),
              CalcButton(label: 'MC', type: BtnType.special, onTap: ctrl.memoryClear),
              CalcButton(label: 'MR', type: BtnType.special, onTap: ctrl.memoryRecall),
            ]),
            SizedBox(height: 12.h),
          ],
        );
      }),
    );
  }

  Widget _row(List<Widget> children) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: children,
  );
}
