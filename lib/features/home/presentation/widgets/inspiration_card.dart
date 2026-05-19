import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_export.dart';

class InspirationCard extends StatelessWidget {
  const InspirationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final inspiration =
        _inspirations[_currentWeekIndex() % _inspirations.length];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.bgCard,
        border: Border.all(color: c.borderSubtle),
        borderRadius: BorderRadius.circular(c.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: c.accent),
              const SizedBox(width: 8),
              Text('INSPIRACJA', style: ts.sectionLabel),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              inspiration.headline,
              style: ts.cardTitle.copyWith(height: 1.45),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              inspiration.description,
              style: ts.caption.copyWith(color: c.textSecondary, height: 1.55),
            ),
          ),
          if (inspiration.ideas.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: c.accent.withOpacity(0.04),
                border: Border.all(color: c.accent.withOpacity(0.12)),
                borderRadius: BorderRadius.circular(c.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('POMYSŁY NA START', style: ts.sectionLabel),
                  const SizedBox(height: 8),
                  ...inspiration.ideas.map(
                    (idea) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ',
                              style: ts.caption.copyWith(color: c.textSecondary)),
                          Expanded(
                            child: Text(
                              idea,
                              style: ts.caption.copyWith(
                                color: c.textSecondary,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Container(height: 1, color: c.borderSubtle),
          const SizedBox(height: 6),
          _CreateRouteButton(onTap: () => context.go('/dashboard')),
        ],
      ),
    );
  }

  /// Deterministyczna rotacja — każdy tydzień to inna inspiracja.
  /// Wszyscy użytkownicy w danym tygodniu widzą tę samą wskazówkę.
  int _currentWeekIndex() {
    final start = DateTime(2026, 1, 1);
    final days = DateTime.now().difference(start).inDays;
    return days ~/ 7;
  }
}

class _CreateRouteButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CreateRouteButton({required this.onTap});

  @override
  State<_CreateRouteButton> createState() => _CreateRouteButtonState();
}

class _CreateRouteButtonState extends State<_CreateRouteButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? c.bgInput : Colors.transparent,
            borderRadius: BorderRadius.circular(c.radiusSm),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Stwórz nową trasę',
                  style: ts.cardTitle.copyWith(fontSize: 13, color: c.accent),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.chevron_right, size: 16, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _Inspiration {
  final String headline;
  final String description;
  final List<String> ideas;

  const _Inspiration({
    required this.headline,
    required this.description,
    required this.ideas,
  });
}

const List<_Inspiration> _inspirations = [
  _Inspiration(
    headline: 'Trasy tematyczne przyciągają więcej słuchaczy niż geograficzne',
    description:
        'Zamiast „Spacer po Krakowie" spróbuj „Krakowscy artyści XIX wieku" lub „Smaki Kazimierza". Konkretny temat sprawia, że turysta wybiera Twoją trasę zamiast podobnych.',
    ideas: [
      'Lokalna kuchnia i jej historia',
      'Architektura ukryta przed turystami',
      'Trasy nocne i ich klimat',
    ],
  ),
  _Inspiration(
    headline: 'Optymalna długość trasy to 30-60 minut',
    description:
        'Krótsze trasy często znudzą, dłuższe wyczerpią. 30-60 minut to czas, w którym turysta zaangażuje się bez zmęczenia. Jeśli temat jest większy — rozbij go na kilka tras.',
    ideas: [
      '3-5 punktów audio na trasę',
      'Każdy punkt 2-4 minuty',
      'Trasa kończąca się przy kawiarni',
    ],
  ),
  _Inspiration(
    headline: 'Punkty audio z lokalnym kontekstem zatrzymują turystów',
    description:
        'Daty i nazwiska szybko wylatują z głowy. Anegdoty, ciekawostki, plotki z epoki — zostają. Każdy punkt to jedna historia, nie wykład.',
    ideas: [
      'Co się stało w tym miejscu?',
      'Kto tu mieszkał i dlaczego?',
      'Jak to miejsce zmieniało się w czasie?',
    ],
  ),
  _Inspiration(
    headline: 'Pisz scenariusze, nie informacje',
    description:
        '„Tu znajduje się kościół XYZ z XVI wieku" jest słabe. „Stań plecami do bramy. Widzisz tę nierówną cegłę pod oknem?" — to scenariusz, który prowadzi turystę.',
    ideas: [
      'Daj turyście instrukcję, co robi ciałem',
      'Zwróć uwagę na detal',
      'Zakończ punkt zachętą do następnego',
    ],
  ),
  _Inspiration(
    headline: 'Tytuł trasy ma jedną rolę — sprawić, żeby kliknęli',
    description:
        'Ogólny tytuł ginie wśród konkurencji. „Sekretny Kraków" jest słabszy niż „7 miejsc w Krakowie, których nie znajdziesz w przewodnikach". Konkretność wygrywa.',
    ideas: [
      'Konkretna liczba w tytule',
      'Obietnica wiedzy lub doświadczenia',
      'Element zagadki lub kontrowersji',
    ],
  ),
  _Inspiration(
    headline: 'Nagrania w cichym pokoju brzmią lepiej niż w studio',
    description:
        'Profesjonalne studio sprawia, że audio brzmi sterylnie. Nagranie w cichym domu, z lekkim pogłosem pomieszczenia, brzmi bardziej osobiście. Turysta słucha Ciebie, nie spikera radiowego.',
    ideas: [
      'Pokój z dywanem i miękkimi zasłonami',
      'Mikrofon 15-20 cm od ust',
      'Nagraj w ciszy, rano lub późnym wieczorem',
    ],
  ),
  _Inspiration(
    headline: 'Pierwszy punkt audio decyduje czy będą słuchać dalej',
    description:
        'Pierwsze 30 sekund to test. Jeśli zacznie się od „Witam, jestem przewodnikiem...", turysta wyłączy. Zacznij od pytania, intrygującego faktu lub instrukcji — od razu wciągnij w opowieść.',
    ideas: [
      'Otwórz pytaniem retorycznym',
      'Daj fakt, który zaskakuje',
      'Powiedz turyście, co właśnie minął — nie wiedząc',
    ],
  ),
];
