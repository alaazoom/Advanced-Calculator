import 'dart:math' as math;
import 'dart:ui';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryItem {
  final String expression;
  final String result;
  final DateTime time;
  HistoryItem({required this.expression, required this.result, required this.time});
}

enum CalcMode { standard, scientific }

class CalculatorController extends GetxController {
  final display      = '0'.obs;
  final expression   = ''.obs;
  final history      = <HistoryItem>[].obs;
  final mode         = CalcMode.standard.obs;
  final isDegree     = true.obs;        
  final isInverse    = false.obs;  
  final hasResult    = false.obs;     
  final memory       = 0.0.obs;   
  String _currentInput = '0';
  String _operator     = '';
  double _operand1     = 0;
  bool   _startNew     = false;
  String _fullExpr     = '';

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void onDigit(String digit) {
    if (hasResult.value || _startNew) {
      _currentInput = digit;
      hasResult.value = false;
      _startNew = false;
    } else {
      if (_currentInput == '0' && digit != '.') {
        _currentInput = digit;
      } else {
        if (digit == '.' && _currentInput.contains('.')) return;
        if (_currentInput.length >= 16) return;
        _currentInput += digit;
      }
    }
    display.value = _currentInput;
  }

  void onOperator(String op) {
    final val = double.tryParse(_currentInput) ?? 0;

    if (_operator.isNotEmpty && !_startNew) {
      final res = _calculate(_operand1, val, _operator);
      _operand1 = res;
      display.value = _formatResult(res);
      _currentInput = display.value;
    } else {
      _operand1 = val;
    }

    _operator = op;
    _fullExpr = '${_formatResult(_operand1)} ${_opSymbol(op)}';
    expression.value = _fullExpr;
    _startNew = true;
    hasResult.value = false;
  }

  void onEquals() {
    if (_operator.isEmpty) return;
    final val2 = double.tryParse(_currentInput) ?? 0;
    _fullExpr = '${expression.value} ${_formatResult(val2)} =';

    final res = _calculate(_operand1, val2, _operator);
    final resStr = _formatResult(res);

    history.insert(0, HistoryItem(
      expression: _fullExpr,
      result: resStr,
      time: DateTime.now(),
    ));
    _saveHistory();

    display.value = resStr;
    expression.value = _fullExpr;
    _currentInput = resStr;
    _operator = '';
    _operand1 = res;
    hasResult.value = true;
    _startNew = true;
  }

  void onClear() {
    _currentInput = '0';
    _operator = '';
    _operand1 = 0;
    _startNew = false;
    _fullExpr = '';
    display.value = '0';
    expression.value = '';
    hasResult.value = false;
    isInverse.value = false;
  }

  void onBackspace() {
    if (hasResult.value || _currentInput.length <= 1) {
      _currentInput = '0';
      hasResult.value = false;
    } else {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      if (_currentInput.isEmpty || _currentInput == '-') _currentInput = '0';
    }
    display.value = _currentInput;
  }

  void onToggleSign() {
    if (_currentInput.startsWith('-')) {
      _currentInput = _currentInput.substring(1);
    } else if (_currentInput != '0') {
      _currentInput = '-$_currentInput';
    }
    display.value = _currentInput;
  }

  void onPercent() {
    final val = double.tryParse(_currentInput) ?? 0;
    final res = _operator.isNotEmpty ? (_operand1 * val / 100) : (val / 100);
    _currentInput = _formatResult(res);
    display.value = _currentInput;
    hasResult.value = true;
  }

 
  void onScientific(String fn) {
    final val = double.tryParse(_currentInput) ?? 0;
    final rad = isDegree.value ? val * math.pi / 180 : val;
    double res;
    String exprStr;

    switch (fn) {
      case 'sin':
        res = isInverse.value ? _asin(val) : math.sin(rad);
        exprStr = isInverse.value ? 'arcsin($val)' : 'sin($val°)';
      case 'cos':
        res = isInverse.value ? _acos(val) : math.cos(rad);
        exprStr = isInverse.value ? 'arccos($val)' : 'cos($val°)';
      case 'tan':
        res = isInverse.value ? _atan(val) : math.tan(rad);
        exprStr = isInverse.value ? 'arctan($val)' : 'tan($val°)';
      case 'log':
        res = isInverse.value ? math.pow(10, val).toDouble() : (val > 0 ? math.log(val) / math.ln10 : double.nan);
        exprStr = isInverse.value ? '10^($val)' : 'log($val)';
      case 'ln':
        res = isInverse.value ? math.exp(val) : (val > 0 ? math.log(val) : double.nan);
        exprStr = isInverse.value ? 'e^($val)' : 'ln($val)';
      case 'sqrt':
        res = isInverse.value ? val * val : (val >= 0 ? math.sqrt(val) : double.nan);
        exprStr = isInverse.value ? '($val)²' : '√($val)';
      case 'x2':
        res = val * val;
        exprStr = '($val)²';
      case 'x3':
        res = val * val * val;
        exprStr = '($val)³';
      case 'inv':
        res = val != 0 ? 1 / val : double.nan;
        exprStr = '1/($val)';
      case 'exp':
        res = math.exp(val);
        exprStr = 'e^($val)';
      case 'abs':
        res = val.abs();
        exprStr = '|$val|';
      case 'fact':
        res = _factorial(val.toInt()).toDouble();
        exprStr = '$val!';
      case 'pi':
        res = math.pi;
        exprStr = 'π';
      case 'e':
        res = math.e;
        exprStr = 'e';
      case 'pow10':
        res = math.pow(10, val).toDouble();
        exprStr = '10^($val)';
      default:
        return;
    }

    if (res.isNaN || res.isInfinite) {
      display.value = 'خطأ';
      expression.value = '$exprStr = خطأ';
      _currentInput = '0';
    } else {
      final resStr = _formatResult(res);
      history.insert(0, HistoryItem(
        expression: '$exprStr =',
        result: resStr,
        time: DateTime.now(),
      ));
      _saveHistory();
      _currentInput = resStr;
      display.value = resStr;
      expression.value = '$exprStr =';
      hasResult.value = true;
    }
  }

 
  void memoryAdd()  { memory.value += double.tryParse(_currentInput) ?? 0; _showMemorySnack('+'); }
  void memorySub()  { memory.value -= double.tryParse(_currentInput) ?? 0; _showMemorySnack('-'); }
  void memoryRecall(){ _currentInput = _formatResult(memory.value); display.value = _currentInput; hasResult.value = true; }
  void memoryClear(){ memory.value = 0; }

  void _showMemorySnack(String op) {
    Get.snackbar('الذاكرة', 'M = ${_formatResult(memory.value)}',
      duration: const Duration(seconds: 1),
      backgroundColor: const Color(0xFF1E1E2A),
      colorText: const Color(0xFF00E5FF),
      snackPosition: SnackPosition.TOP,
    );
  }


  void toggleMode() {
    mode.value = mode.value == CalcMode.standard
        ? CalcMode.scientific : CalcMode.standard;
  }

  void toggleDegRad() => isDegree.value = !isDegree.value;
  void toggleInverse() => isInverse.value = !isInverse.value;

  void clearHistory() { history.clear(); _saveHistory(); }

  void useHistoryItem(HistoryItem item) {
    _currentInput = item.result;
    display.value = _currentInput;
    hasResult.value = true;
  }


  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+': return a + b;
      case '-': return a - b;
      case '×': return a * b;
      case '÷': return b != 0 ? a / b : double.nan;
      case 'xʸ': return math.pow(a, b).toDouble();
      case 'ʸ√x': return math.pow(b, 1 / a).toDouble();
      default:   return b;
    }
  }

  String _formatResult(double val) {
    if (val.isNaN)      return 'خطأ';
    if (val.isInfinite) return val > 0 ? '∞' : '-∞';
    if (val == val.roundToDouble() && val.abs() < 1e15) {
      return val.toInt().toString();
    }
    String s = val.toStringAsPrecision(10);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  String _opSymbol(String op) => op;

  double _asin(double v) => math.asin(v.clamp(-1, 1)) * (isDegree.value ? 180 / math.pi : 1);
  double _acos(double v) => math.acos(v.clamp(-1, 1)) * (isDegree.value ? 180 / math.pi : 1);
  double _atan(double v) => math.atan(v) * (isDegree.value ? 180 / math.pi : 1);

  int _factorial(int n) {
    if (n < 0 || n > 20) return -1;
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = history.take(50).map((h) =>
          '${h.expression}||${h.result}||${h.time.toIso8601String()}').toList();
      await prefs.setStringList('calc_history', list);
    } catch (_) {}
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('calc_history') ?? [];
      history.value = list.map((s) {
        final p = s.split('||');
        return HistoryItem(
          expression: p[0], result: p[1],
          time: DateTime.tryParse(p[2]) ?? DateTime.now(),
        );
      }).toList();
    } catch (_) {}
  }
}
