
class validation{


  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    } else if (value.length < 3) {
      return 'يجب أن يكون الاسم أكثر من 3 أحرف';
    }
    return null;
  }
  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الوصف  مطلوب';
    } else if (value.length < 3) {
      return 'يجب أن يكون الوصف  أكثر من 3 أحرف';
    }
    return null;
  }

  static String? id(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الطالب مطلوب';
    } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
      return 'يجب أن يكون رقم الهوية مكونًا من 9 أرقام';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    } else if (value.length < 8) {
      return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير ورقم';
    }
    return null;
  }
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }
}