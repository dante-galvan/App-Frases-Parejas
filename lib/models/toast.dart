enum ToastType { success, info, error }

class ToastMessage {
  final String id;
  final String message;
  final ToastType type;

  const ToastMessage({
    required this.id,
    required this.message,
    this.type = ToastType.success,
  });
}
