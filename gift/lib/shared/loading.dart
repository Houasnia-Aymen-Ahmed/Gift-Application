import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xF2191622).withOpacity(0.5),
      child: const Center(
        child: SpinKitWaveSpinner(
          color: Color(0xEE9388A2),
          size: 100.0,
        ),
      ),
    );
  }
}
