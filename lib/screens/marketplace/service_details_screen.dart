import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceId;

  const ServiceDetailsScreen({Key? key, required this.serviceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: Center(
        child: Text('Details of Service ID: \$serviceId'),
      ),
    );
  }
}
