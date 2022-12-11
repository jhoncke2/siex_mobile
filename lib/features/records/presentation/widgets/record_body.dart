import 'package:flutter/material.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import '../../../../app_theme.dart';

class RecordBody extends StatelessWidget {
  final Record record;
  const RecordBody({
    required this.record,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Padding(
      padding: EdgeInsets.only(
        left: dimens.getWidthPercentage(0.04),
        right: dimens.getWidthPercentage(0.04),
        top: dimens.getHeightPercentage(0.0075),
        bottom: dimens.getHeightPercentage(0.015)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${record.price}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black
                ),
              ),
              Text(
                '${record.date.year}-${record.date.month}-${record.date.day}',
                style: const TextStyle(
                  fontSize: 14.5,
                  color: Colors.black54
                ),
              )
            ],
          ),
          const SizedBox(height: 7.5),
          Text(
            record.cdpName,
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}