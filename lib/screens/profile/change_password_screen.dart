import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void handleChangePassword() {
    final String currentPassword = currentPasswordController.text.trim();
    final String newPassword = newPasswordController.text.trim();
    final String repeatPassword = repeatPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || repeatPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm şifre alanlarını doldurun.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (newPassword != repeatPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yeni şifreler birbiriyle eşleşmiyor.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Şifre güncelleme isteği AuthService üzerinden backend bağlantısına yönlendirilir.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Şifre değiştirme isteği hazırlanacak.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.card,
                    fixedSize: const Size(36, 36),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.accentBlue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Şifremi Değiştir',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.07),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppTextField(
                    label: 'Mevcut Şifre',
                    hintText: 'Mevcut şifreni yaz',
                    controller: currentPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 18),
                  AppTextField(
                    label: 'Yeni Şifre',
                    hintText: 'Yeni şifreni yaz',
                    controller: newPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 18),
                  AppTextField(
                    label: 'Yeni Şifre Tekrar',
                    hintText: 'Yeni şifreni tekrar yaz',
                    controller: repeatPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Şifreyi Güncelle',
                    onPressed: handleChangePassword,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
