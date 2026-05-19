import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/colors.dart';
import '../size_extensions.dart';

class FooterWidget extends StatelessWidget {
  final bool isFullContext;
  const FooterWidget({super.key, this.isFullContext = true});
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = SizeConfig.isMobile(context);
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 33),
        decoration: BoxDecoration(
            color: c.bg,
            border: Border(top: BorderSide(color: c.accentBorder))),
        child: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: mobile ? _mobile(context, c) : _desktop(context, c))));
  }

  Widget _desktop(BuildContext context, AppColors c) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      if (isFullContext) _logo(c),
      if (isFullContext) const Spacer(),
      Text('© 2025 MileStory. All rights reserved.', style: tt.labelSmall),
      const Spacer(),
      Row(mainAxisSize: MainAxisSize.min, children: [
        _link('Polityka prywatności',
            'https://milestory.pl/privacy_policy_creator.html', c, tt),
        const SizedBox(width: 24),
        _link('Regulamin', 'https://milestory.pl/regulations_creator.html', c, tt),
        const SizedBox(width: 24),
        _email(c, tt),
        const SizedBox(width: 16),
        if (isFullContext)
          _social(FontAwesomeIcons.instagram,
              'https://instagram.com/milestory.pl', c),
        const SizedBox(width: 8),
        if (isFullContext)
          _social(
              FontAwesomeIcons.facebook, 'https://facebook.com/milestory', c),
      ]),
    ]);
  }

  Widget _mobile(BuildContext context, AppColors c) {
    final tt = Theme.of(context).textTheme;
    return Column(children: [
      if (isFullContext) _logo(c),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _link('Polityka prywatności',
            'https://milestory.pl/privacy_policy_creator.html', c, tt),
        const SizedBox(width: 20),
        _link('Regulamin', 'https://milestory.pl/regulations_creator.html', c, tt)
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _email(c, tt),
        const SizedBox(width: 16),
        if (isFullContext)
          _social(FontAwesomeIcons.instagram,
              'https://instagram.com/milestory.pl', c),
        const SizedBox(width: 8),
        if (isFullContext) _social(FontAwesomeIcons.facebook, 'https://facebook.com/milestory', c)
      ]),
      const SizedBox(height: 8),
      Text('© 2025 MileStory. All rights reserved.',
          style: tt.labelSmall!.copyWith(fontSize: 12)),
    ]);
  }

  Widget _logo(AppColors c) => Row(mainAxisSize: MainAxisSize.min, children: [
        Image.asset('assets/images/logo_milestory3.png',
            height: 28,
            errorBuilder: (_, __, ___) => Container(
                width: 28,
                height: 28,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: c.accent),
                alignment: Alignment.center,
                child: Text('M',
                    style: TextStyle(
                        fontFamily: AppColors.fontDisplay,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: c.bg)))),
        const SizedBox(width: 8),
        Text('MileStory',
            style: TextStyle(
                fontFamily: AppColors.fontDisplay,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: c.textPrimary)),
      ]);

  Widget _link(String label, String url, AppColors c, TextTheme tt) =>
      MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              onTap: () => launchUrl(Uri.parse(url)),
              child: Text(label,
                  style: tt.labelSmall!
                      .copyWith(fontSize: 13, color: c.textMuted))));

  Widget _email(AppColors c, TextTheme tt) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => launchUrl(Uri.parse('mailto:contact@milestory.pl')),
          child: Text('contact@milestory.pl',
              style: tt.labelSmall!.copyWith(fontSize: 13, color: c.accent))));

  Widget _social(IconData icon, String url, AppColors c) => IconButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      icon: FaIcon(icon, color: c.textPrimary, size: 18),
      splashRadius: 20,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints());
}
