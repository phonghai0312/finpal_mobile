import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Placeholder for the wallet image
              Image.asset(
                'assets/image/logo_finpal.png', // Assuming this is the wallet image
                height: 200,
              ),
              const SizedBox(height: 32),
              const Text(
                'FinPal',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF22573B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Quản lý tài chính cá nhân thông minh & an toàn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              _buildFeatureCard(
                iconPath: 'assets/icons/category_service/ai_sparkle.svg', // Placeholder
                text: 'Phân loại tự động với AI',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                iconPath: 'assets/icons/category_service/chart_up.svg', // Placeholder
                text: 'Thống kê chi tiêu thông minh',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                iconPath: 'assets/icons/category_service/shield_check.svg', // Placeholder
                text: 'Kết nối Sepay an toàn',
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.login);
                  },
                  child: const Text(
                    'Next >',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22573B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required String iconPath, required String text}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(Color(0xFF22573B), BlendMode.srcIn),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF22573B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
