/// Helper class để dịch tên category sang ngôn ngữ tự nhiên
/// Mapping từ category name (backend) sang localization key
class CategoryTranslator {
  /// Map category name từ backend sang display name tiếng Việt
  static String getCategoryDisplayName(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) {
      return 'Không xác định';
    }

    // Map các tên category từ backend sang tên hiển thị tiếng Việt
    // Hỗ trợ cả tiếng Việt và tiếng Anh từ backend
    final categoryMap = <String, String>{
      // Tiếng Việt - Chi phí
      'an_uong': 'Ăn uống',
      'ăn uống': 'Ăn uống',
      'mua_sam': 'Mua sắm',
      'mua sắm': 'Mua sắm',
      'di_chuyen': 'Di chuyển',
      'di chuyển': 'Di chuyển',
      'giai_tri': 'Giải trí',
      'giải trí': 'Giải trí',
      'y_te': 'Y tế',
      'y tế': 'Y tế',
      'giao_duc': 'Giáo dục',
      'giáo dục': 'Giáo dục',
      'tien_ich': 'Tiện ích',
      'tiện ích': 'Tiện ích',
      'nha_o': 'Nhà ở',
      'nhà ở': 'Nhà ở',
      'cham_soc_ca_nhan': 'Chăm sóc cá nhân',
      'chăm sóc cá nhân': 'Chăm sóc cá nhân',
      'du_lich': 'Du lịch',
      'du lịch': 'Du lịch',
      'bao_hiem': 'Bảo hiểm',
      'bảo hiểm': 'Bảo hiểm',
      'qua_tang': 'Quà tặng',
      'quà tặng': 'Quà tặng',

      // Tiếng Việt - Thu nhập
      'luong': 'Lương',
      'lương': 'Lương',
      'thu_nhap': 'Thu nhập',
      'thu nhập': 'Thu nhập',
      'dau_tu': 'Đầu tư',
      'đầu tư': 'Đầu tư',
      'tien_thuong': 'Tiền thưởng',
      'tiền thưởng': 'Tiền thưởng',
      'lai_suat': 'Lãi suất',
      'lãi suất': 'Lãi suất',
      'co_tuc': 'Cổ tức',
      'cổ tức': 'Cổ tức',
      'kinh_doanh': 'Kinh doanh',
      'loi_nhuan': 'Lợi nhuận',
      'lợi nhuận': 'Lợi nhuận',

      // Tiếng Việt - Khác
      'khac': 'Khác',
      'khác': 'Khác',
      'khong_xac_dinh': 'Không xác định',
      'không xác định': 'Không xác định',

      // Tiếng Anh - Chi phí
      'food_drink': 'Ăn uống',
      'food & drink': 'Ăn uống',
      'food and drink': 'Ăn uống',
      'shopping': 'Mua sắm',
      'transportation': 'Di chuyển',
      'entertainment': 'Giải trí',
      'healthcare': 'Y tế',
      'education': 'Giáo dục',
      'utilities': 'Tiện ích',
      'housing': 'Nhà ở',
      'personal_care': 'Chăm sóc cá nhân',
      'personal care': 'Chăm sóc cá nhân',
      'travel': 'Du lịch',
      'insurance': 'Bảo hiểm',
      'gifts': 'Quà tặng',

      // Tiếng Anh - Thu nhập
      'salary': 'Lương',
      'income': 'Thu nhập',
      'investment': 'Đầu tư',
      'bonus': 'Tiền thưởng',
      'interest': 'Lãi suất',
      'dividend': 'Cổ tức',
      'dividends': 'Cổ tức',
      'business': 'Kinh doanh',
      'profit': 'Lợi nhuận',
      'revenue': 'Doanh thu',

      // Tiếng Anh - Khác
      'other': 'Khác',
      'others': 'Khác',
      'unknown': 'Không xác định',
      'miscellaneous': 'Khác',

      // Các biến thể khác
      'food': 'Ăn uống',
      'drink': 'Ăn uống',
      'transport': 'Di chuyển',
      'health': 'Y tế',
      'medical': 'Y tế',
      'school': 'Giáo dục',
      'study': 'Giáo dục',
      'house': 'Nhà ở',
      'home': 'Nhà ở',
      'wage': 'Lương',
      'invest': 'Đầu tư',
      'beauty': 'Chăm sóc cá nhân',
      'tourism': 'Du lịch',
      'gift': 'Quà tặng',
      'present': 'Quà tặng',
      'earning': 'Thu nhập',
      'earnings': 'Thu nhập',
    };

    // Tìm kiếm không phân biệt hoa thường và khoảng trắng
    final normalizedName = categoryName.toLowerCase().trim();

    // Thử tìm exact match trước
    if (categoryMap.containsKey(normalizedName)) {
      return categoryMap[normalizedName]!;
    }

    // Thử tìm partial match
    for (final entry in categoryMap.entries) {
      if (normalizedName.contains(entry.key) ||
          entry.key.contains(normalizedName)) {
        return entry.value;
      }
    }

    // Nếu không tìm thấy, trả về tên gốc với chữ cái đầu viết hoa
    return _capitalizeFirst(categoryName);
  }

  /// Viết hoa chữ cái đầu
  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
