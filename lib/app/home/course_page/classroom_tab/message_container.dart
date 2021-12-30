import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/custom_container.dart';
import '../../../utils/format_date.dart';

class MessageContainer extends CustomContainer {
  MessageContainer(
    BuildContext context, {
    Key? key,
    required String message,
    required Color borderColor,
    required Widget leadingAvatar,
    required String sender,
    required Timestamp time,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          onPressed: onPressed,
          borderRadius: 5.0,
          maxWidth: 400.0,
          maxHeight: 500.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 11.0, horizontal: 15.0),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  title: Text(
                    sender,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 16.0),
                  ),
                  subtitle: Text(FormatDate.getDate(time)),
                  leading: leadingAvatar,
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 11.0, horizontal: 15.0),
                child: Text(message,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                        )),
              ),
              const Divider(
                thickness: 1.0,
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 11.0, horizontal: 15.0),
                child: Text(
                  'Add comment...',
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                ),
              ),
            ],
          ),
          borderColor: borderColor,
        );
  // initializeDateFormatting();
}
