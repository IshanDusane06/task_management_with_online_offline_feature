import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TasksTile extends StatelessWidget {
  const TasksTile({
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    super.key,
  });

  final String title;
  final String description;
  final String date;
  final String priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pinkAccent,
              border: Border.all(color: Colors.white),
            ),
            child: const Icon(
              Icons.done,
              color: Colors.white,
              size: 15,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                description,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${DateFormat('dd/MM/yyyy h:mm a').format(DateTime.parse(date))},  $priority',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Spacer(),
          // const CircleAvatar(
          //   radius: 5,
          //   backgroundColor: Colors.purpleAccent,
          // )
        ],
      ),
    );
  }
}
