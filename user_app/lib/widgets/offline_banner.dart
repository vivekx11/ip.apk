import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/network_service.dart';

class OfflineBanner extends StatelessWidget {
  final Widget child;

  const OfflineBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, networkService, _) {
        return Column(
          children: [
            if (networkService.isOffline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'You are offline. Connect to internet.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}