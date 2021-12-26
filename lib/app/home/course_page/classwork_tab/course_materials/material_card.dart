import 'package:flutter/material.dart';

import '../../../../../common_widgets/custom_container.dart';

class MaterialCard extends StatelessWidget {
  const MaterialCard({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: CustomContainer(
              // decorationImage: ,
              containerColor: Colors.white,
              decorationImage: DecorationImage(
                image: AssetImage('assets/images/pdf.png'),
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
