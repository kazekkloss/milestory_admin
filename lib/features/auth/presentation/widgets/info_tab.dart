import 'package:flutter/material.dart';
import 'package:milestory_admin/core/core_export.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final narrow = SizeConfig.isNarrow(context);
    final mobile = SizeConfig.isMobile(context);
    final px = mobile
        ? 16.0
        : narrow
            ? 32.0
            : 56.0;
    final vy = mobile ? 56.0 : 80.0;

    return Container(
      width: double.infinity,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: c.accentBorder))),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: px, vertical: vy),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(children: [
                const _Header(),
                SizedBox(height: mobile ? 36 : 48),
                _StepsBlock(narrow: narrow, mobile: mobile),
                SizedBox(height: mobile ? 56 : 88),
                _CreatorShowcase(narrow: narrow, mobile: mobile),
                SizedBox(height: mobile ? 56 : 88),
                _AppShowcase(narrow: narrow, mobile: mobile),
              ]),
            ),
          ),
        ),
        const FooterWidget(),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final narrow = SizeConfig.isNarrow(context);
    return Column(children: [
      Text('JAK TO DZIAŁA', style: ts.sectionLabel),
      const SizedBox(height: 14),
      Text('Trzy proste kroki',
          textAlign: TextAlign.center,
          style: ts.sectionTitle.copyWith(fontSize: narrow ? 28 : 36)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════
// STEPS — wide: cards in a row + horizontal connector
//         narrow: vertical timeline with dots on the left
// ═══════════════════════════════════════════════════════════════════

class _StepsBlock extends StatelessWidget {
  final bool narrow;
  final bool mobile;
  const _StepsBlock({required this.narrow, required this.mobile});

  static const _data = <(String, String, String)>[
    (
      '01',
      'Tworzysz trasę',
      'W kreatorze dodajesz punkty na mapie i przypisujesz audio w wybranych miejscach.'
    ),
    (
      '02',
      'Publikujesz',
      'Publikujesz trasę i czekasz na pozytywną weryfikację przez nasz zespół.'
    ),
    (
      '03',
      'Podróżnicy słuchają',
      'Podróżnicy automatycznie odsłuchują Twoje audio w wybranych przez Ciebie miejscach.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (narrow) return _StepsTimeline(data: _data, mobile: mobile);
    return _StepsRow(data: _data);
  }
}

// ───── wide ─────

class _StepsRow extends StatelessWidget {
  final List<(String, String, String)> data;
  const _StepsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // łącznik — subtelna pozioma linia pod numerami
        Positioned(
          top: 56, // wysokość mniej-więcej pod numerem 01/02/03
          left: 80,
          right: 80,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                c.accent.withValues(alpha: 0),
                c.accent.withValues(alpha: 0.35),
                c.accent.withValues(alpha: 0.35),
                c.accent.withValues(alpha: 0),
              ]),
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data
                .map((d) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _StepCard(
                            num: d.$1, title: d.$2, desc: d.$3),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String num;
  final String title;
  final String desc;
  const _StepCard(
      {required this.num, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num,
              style: TextStyle(
                fontFamily: AppColors.fontDisplay,
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: c.accent.withValues(alpha: 0.50),
                height: 1,
              )),
          const SizedBox(height: 16),
          Text(title, style: ts.cardTitle),
          const SizedBox(height: 10),
          Text(desc, style: ts.body.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

// ───── narrow / mobile ─────

class _StepsTimeline extends StatelessWidget {
  final List<(String, String, String)> data;
  final bool mobile;
  const _StepsTimeline({required this.data, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final dotSize = 10.0;
    final lineLeft = dotSize / 2; // środek kropki

    return Stack(
      children: [
        // pionowa linia
        Positioned(
          left: lineLeft,
          top: 8,
          bottom: 8,
          child: Container(
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  c.accent.withValues(alpha: 0.45),
                  c.accent.withValues(alpha: 0.15),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: data
              .map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _StepTimelineRow(
                        num: d.$1,
                        title: d.$2,
                        desc: d.$3,
                        dotSize: dotSize,
                        mobile: mobile),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _StepTimelineRow extends StatelessWidget {
  final String num;
  final String title;
  final String desc;
  final double dotSize;
  final bool mobile;
  const _StepTimelineRow({
    required this.num,
    required this.title,
    required this.desc,
    required this.dotSize,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // kropka na linii
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.accent,
              boxShadow: [
                BoxShadow(
                  color: c.accent.withValues(alpha: 0.18),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: HoverCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(num,
                        style: TextStyle(
                          fontFamily: AppColors.fontDisplay,
                          fontSize: mobile ? 26 : 30,
                          fontWeight: FontWeight.w700,
                          color: c.accent.withValues(alpha: 0.5),
                          height: 1,
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(title,
                            style: ts.cardTitle
                                .copyWith(fontSize: mobile ? 16 : 18)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(desc,
                    style: ts.body.copyWith(fontSize: mobile ? 13 : 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SHOWCASE A — Kreator tras (tekst lewa, screen prawa na desktop)
// ═══════════════════════════════════════════════════════════════════

class _CreatorShowcase extends StatelessWidget {
  final bool narrow;
  final bool mobile;
  const _CreatorShowcase({required this.narrow, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = _ShowcaseText(
      eyebrow: 'DLA TWÓRCY',
      title: 'Kreator tras w przeglądarce',
      desc:
          'Mapa, audio, zdjęcia i ustawienia kierunków w jednym miejscu. Bez instalacji, bez kombinowania.',
      bullets: const [
        'Punkty z audio na mapie',
        'Galeria zdjęć z lokalizacji',
        'Ustawienia kierunków odsłuchu',
      ],
      narrow: narrow,
      mobile: mobile,
    );

    final visual = _CreatorVisual(narrow: narrow, mobile: mobile);

    return Container(
      padding: EdgeInsets.only(top: narrow ? 36 : 56),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.accentBorder)),
      ),
      child: narrow
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              text,
              const SizedBox(height: 28),
              visual,
            ])
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 9, child: text),
                  const SizedBox(width: 48),
                  Expanded(flex: 11, child: visual),
                ],
              ),
            ),
    );
  }
}

class _CreatorVisual extends StatelessWidget {
  final bool narrow;
  final bool mobile;
  const _CreatorVisual({required this.narrow, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final h = mobile ? 180.0 : (narrow ? 220.0 : 280.0);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(c.radiusMd),
        border: Border.all(color: c.accentBorder),
        color: c.bgCard,
      ),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(c.radiusMd - 4),
        child: Image.asset(
          'assets/images/info_1.png',
          height: h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: h,
            color: c.bgCard,
            child: Icon(Icons.image_outlined, color: c.textMuted),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SHOWCASE B — Aplikacja (telefony lewa, tekst prawa na desktop)
// ═══════════════════════════════════════════════════════════════════

class _AppShowcase extends StatelessWidget {
  final bool narrow;
  final bool mobile;
  const _AppShowcase({required this.narrow, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = _ShowcaseText(
      eyebrow: 'DLA PODRÓŻNIKA',
      title: 'MileStory w aplikacji',
      desc:
          'Podróżnik otwiera aplikację i słucha Twojego audio dokładnie w miejscu które zaznaczysz — bez klikania, automatycznie.',
      narrow: narrow,
      mobile: mobile,
    );

    final visual = _PhonesGroup(narrow: narrow, mobile: mobile);

    return Container(
      padding: EdgeInsets.only(top: narrow ? 36 : 56),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.accentBorder)),
      ),
      child: narrow
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              text,
              const SizedBox(height: 28),
              visual,
            ])
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 11, child: visual),
                  const SizedBox(width: 48),
                  Expanded(flex: 9, child: text),
                ],
              ),
            ),
    );
  }
}

class _PhonesGroup extends StatelessWidget {
  final bool narrow;
  final bool mobile;
  const _PhonesGroup({required this.narrow, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final phoneW = mobile ? 130.0 : (narrow ? 150.0 : 180.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PhoneMockup(path: 'assets/images/screen1.png', width: phoneW),
        const SizedBox(width: 18),
        _PhoneMockup(path: 'assets/images/screen2.png', width: phoneW),
      ],
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  final String path;
  final double width;
  const _PhoneMockup({required this.path, required this.width});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        path,
        width: width,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: width * 2,
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.accentBorder),
          ),
          child: Icon(Icons.phone_android, color: c.textMuted, size: 28),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Wspólny blok tekstowy showcase'a (eyebrow + tytuł + opis + bullets)
// ═══════════════════════════════════════════════════════════════════

class _ShowcaseText extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String desc;
  final List<String>? bullets;
  final bool narrow;
  final bool mobile;
  const _ShowcaseText({
    required this.eyebrow,
    required this.title,
    required this.desc,
    this.bullets,
    required this.narrow,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final align = narrow ? TextAlign.center : TextAlign.start;
    final cross =
        narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          eyebrow,
          style: ts.sectionLabel.copyWith(fontSize: 11),
          textAlign: align,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: align,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: c.accent,
                fontSize: mobile ? 22 : (narrow ? 24 : 28),
              ),
        ),
        const SizedBox(height: 14),
        Text(
          desc,
          textAlign: align,
          style: ts.body.copyWith(fontSize: mobile ? 14 : 15, height: 1.6),
        ),
        if (bullets != null && bullets!.isNotEmpty) ...[
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: cross,
            children: bullets!
                .map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize:
                            narrow ? MainAxisSize.min : MainAxisSize.max,
                        children: [
                          Text('→',
                              style: TextStyle(
                                  color: c.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(b,
                                style: ts.body
                                    .copyWith(fontSize: mobile ? 13 : 14)),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}