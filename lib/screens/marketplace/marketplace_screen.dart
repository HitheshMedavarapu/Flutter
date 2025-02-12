import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/marketplace/products');
              },
              child: const Text('Browse Products'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/marketplace/services');
              },
              child: const Text('Browse Services'),
            ),
          ],
        ),
      ),
    );
  }
}
