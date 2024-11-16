class UtilityService {
  int getDaysToEnd(int miliseconds) {
    final now = DateTime.now();
    final end = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    final difference = end.difference(now);
    return difference.inDays;
  }

  int getDaysToStart(int miliseconds) {
    final now = DateTime.now();
    final start = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    final difference = start.difference(now);
    return difference.inDays;
  }

  int getTotalDays(int start, int end) {
    final startDate = DateTime.fromMillisecondsSinceEpoch(start);
    final endDate = DateTime.fromMillisecondsSinceEpoch(end);
    final difference = endDate.difference(startDate);
    return difference.inDays;
  }

  int getPastDays(int miliseconds) {
    final now = DateTime.now();
    final start = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    final difference = now.difference(start);
    return difference.inDays;
  }

  String getPastTime(String frequency, int miliseconds) {
    final days = getPastDays(miliseconds);
    switch (frequency) {
      case 'Daily':
        return days.toString();
      case 'Weekly':
        return (days / 7).ceil().toString();
      case 'Monthly':
        return (days / 30).ceil().toString();
      default:
        return "0";
    }
  }

  String getFormattedDate(int miliseconds) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    final String formatedDate = '${date.day} of ${monthNames[date.month - 1]}';

    return formatedDate;
  }

  String getFrequencyName(String frequency) {
    if (frequency == 'Daily') {
      return 'day';
    } else if (frequency == 'Weekly') {
      return 'week';
    } else if (frequency == 'Monthly') {
      return 'month';
    } else {
      return '-';
    }
  }

  String getFrequencyPluralName(String frequency) {
    if (frequency == 'Daily') {
      return 'Days';
    } else if (frequency == 'Weekly') {
      return 'Weeks';
    } else if (frequency == 'Monthly') {
      return 'Months';
    } else {
      return '-';
    }
  }

  List<dynamic> findGoals(List<dynamic> goals, List<dynamic> ids) {
    return goals.where((element) => ids.contains(element[0])).toList();
  }

  List<dynamic> findGoalsInProgress(List<dynamic> goals) {
    return goals
        .where((element) =>
            (element[8].toInt() - DateTime.now().millisecondsSinceEpoch) > 0)
        .toList();
  }

  List<dynamic> findPastGoals(List<dynamic> goals) {
    return goals
        .where((element) =>
            (element[8].toInt() - DateTime.now().millisecondsSinceEpoch) < 0)
        .toList();
  }

  int getTotalMeta(DateTime start, DateTime end, String frequency, int times) {
    final difference = end.difference(start);
    switch (frequency) {
      case 'Daily':
        return difference.inDays + 1;
      case 'Weekly':
        return (difference.inDays / 7).ceil() * times;
      case 'Monthly':
        return (difference.inDays / 30).ceil() * times;
      default:
        return 1;
    }
  }
}
