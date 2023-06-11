import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

final _dateFormat = DateFormat('EEEE, MMMM dd, yyyy');

class HistoryDateTile extends StatelessWidget {
  const HistoryDateTile({super.key, required this.date, this.margin});

  final DateTime? date;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final text = date == null ? 'No Date' : _dateFormat.format(date!);
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
      margin: margin,
      child: Text(text,
          style: context.text16w700
              .copyWith(fontSize: 20, color: Colors.black.withAlpha(122))),
    );
  }
}
