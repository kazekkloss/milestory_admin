import 'package:flutter/material.dart';
import 'package:milestory_admin/core/core_export.dart';
import 'package:milestory_admin/features/auth/auth_export.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    _scrollController = ScrollController();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -14).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _scrollToInfo() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: GlobalErrorListener(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(children: [
            LoginTab(
              onScrollDown: _scrollToInfo,
              bounceAnimation: _bounceAnimation,
            ),
            const InfoTab(),
          ]),
        ),
      ),
    );
  }
}
