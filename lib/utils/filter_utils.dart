class FilterUtils {
  /// Calculates total or average log based on the selected range.
  static double calculateAvgTotal(
      List<dynamic> selectedRecords, String selectedRange, String logKey, String timestampKey) {
    if (selectedRecords.isEmpty) return 0.0;

    double totalLog = 0.0;
    Set<String> uniqueDays = {}; // To count unique dates
    // if(logKey == "heart_rate_bpm"){
    //   totalLog = double.tryParse(selectedRecords.last["heart_rate_bpm"].toString()) ?? 0.0;
    // }else{
      for (var record in selectedRecords) {
        double? log = double.tryParse(record[logKey]?.toString() ?? '0');
        String? date = record[timestampKey]?.toString();
        if (log != null && log > 0) {
          totalLog += log;
          if (selectedRange == "week" || selectedRange == "month") {
            uniqueDays.add(date ?? '');
          }
        }
      }

      if (selectedRange == "week" || selectedRange == "month") {
        int daysCount = uniqueDays.length;
        return (daysCount > 0) ? (totalLog / daysCount) : 0.0;
      }
    // }
    return totalLog;
  }

  /// Calculates the total log value for a given range.
  static double calculateTotal(
      List<dynamic> selectedRecords, String selectedRange, String logKey, String timestampKey) {
    if (selectedRecords.isEmpty) return 0.0;

    double totalLog = 0.0;

    for (var record in selectedRecords) {
      double? log = double.tryParse(record[logKey]?.toString() ?? '0');
      if (log != null && log > 0) {
        totalLog += log;
      }
    }

    return totalLog;
  }
}