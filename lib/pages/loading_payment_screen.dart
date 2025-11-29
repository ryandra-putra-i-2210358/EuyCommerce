import 'package:flutter/material.dart';
import 'success_payment_screen.dart';

class LoadingPaymentScreen extends StatefulWidget {
  final String metode;
  final int totalBayar;

  const LoadingPaymentScreen({
    super.key,
    required this.metode,
    required this.totalBayar,
  });

  @override
  State<LoadingPaymentScreen> createState() => _LoadingPaymentScreenState();
}

class _LoadingPaymentScreenState extends State<LoadingPaymentScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 2 detik lalu arahkan ke halaman success
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPaymentScreen(
            metode: widget.metode,
            totalBayar: widget.totalBayar,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),

            SizedBox(height: 25),

            Text(
              "Memproses pembayaran...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
