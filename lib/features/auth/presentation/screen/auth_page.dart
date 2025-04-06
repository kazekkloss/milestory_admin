import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_crm/core/core_export.dart';
import 'package:milestory_crm/core/utils/widgets/error_listener.dart';
import 'package:milestory_crm/features/auth/auth_export.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    context.read<AuthBloc>().add(CheckAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GlobalErrorListener<AuthBloc, AuthState>(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 100.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 120),
                      child: const Center(
                        child: LogoWidget(),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 569),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const LoginTab(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              'assets/images/image_auth.png',
                              height: 569,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleMedium!,
                            children: [
                            const TextSpan(text: "Do kreatora mogą zalogować się tylko użytkownicy posiadający konto przewodnika. Dowiedz się "),
                            TextSpan(
                              text: "jak uzyskać konto przewodnika.",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  color: Colors.amber,
                  child: SizedBox(
                    height: 100.h,
                  )),
            ],
          ),
        ),
      ),
    ));
    //bottomNavigationBar: const FooterWidget());
  }
}
