import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(this.label, this.totalAmount, this.amountPercentage,
      {super.key});
  final String label;
  final double totalAmount;
  final double amountPercentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(child: Text('\$${totalAmount.toStringAsFixed(0)}')),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 60,
          width: 10,
          child: Stack(children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0))),
            FractionallySizedBox(
              heightFactor: amountPercentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
          ]),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
