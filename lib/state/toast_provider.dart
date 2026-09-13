import 'package:flutter/foundation.dart';
import '../models/toast.dart';

class ToastProvider extends ChangeNotifier {
  final List<ToastMessage> _toasts = [];

  List<ToastMessage> get toasts => List.unmodifiable(_toasts);

  void show(String message, {ToastType type = ToastType.success}) {
    final id = '${DateTime.now().millisecondsSinceEpoch}_${_toasts.length}';
    _toasts.add(ToastMessage(id: id, message: message, type: type));
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 3200), () {
      dismiss(id);
    });
  }

  void dismiss(String id) {
    _toasts.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void showSuccess(String message) => show(message, type: ToastType.success);
  void showInfo(String message) => show(message, type: ToastType.info);
  void showError(String message) => show(message, type: ToastType.error);
}
