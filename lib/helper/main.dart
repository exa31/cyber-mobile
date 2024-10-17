import 'package:intl/intl.dart';

class Helper {
  static formatPrice(int price) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatCurrency.format(price);
  }
}
