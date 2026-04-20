import 'package:flutter/material.dart';
import '../models/post.dart';

class ResponseCard extends StatelessWidget {
  final Post post;

  const ResponseCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Post created successfully!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Response body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Response từ server:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                _ResponseRow(label: 'ID', value: '#${post.id}', highlight: true),
                const SizedBox(height: 8),
                _ResponseRow(label: 'User ID', value: '${post.userId}'),
                const SizedBox(height: 8),
                _ResponseRow(label: 'Title', value: post.title),
                const SizedBox(height: 8),
                _ResponseRow(label: 'Body', value: post.body),

                const SizedBox(height: 16),

                // Raw JSON display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '// Raw JSON Response',
                        style: TextStyle(
                          color: Color(0xFF6C7086),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '{\n'
                            '  "id": ${post.id},\n'
                            '  "userId": ${post.userId},\n'
                            '  "title": "${post.title}",\n'
                            '  "body": "${post.body}"\n'
                            '}',
                        style: const TextStyle(
                          color: Color(0xFFA6E3A1),
                          fontSize: 12,
                          fontFamily: 'monospace',
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponseRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ResponseRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
              highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.green.shade700 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}