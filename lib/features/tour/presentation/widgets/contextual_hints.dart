import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/core_export.dart';

class ContextualHints extends StatelessWidget {
  final TourStatus? selectedStatus;
  final VoidCallback onClose;

  const ContextualHints(
      {super.key, required this.selectedStatus, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return HintsPanel(
      items: _itemsForStatus(selectedStatus),
      onClose: onClose,
    );
  }

  static List<HintItem> _itemsForStatus(TourStatus? status) {
    switch (status) {
      case TourStatus.draft:
        return const [
          HintItem(
            icon: FontAwesomeIcons.mapPin,
            iconColor: SemanticColors.info,
            iconBg: SemanticColors.infoBg,
            title: 'Dodaj co najmniej 5 przystanków',
            text:
                'Każdy przystanek potrzebuje obszaru na mapie, opisu i nagrania audio. Możesz dodawać je w dowolnej kolejności.',
          ),
          HintItem(
            icon: FontAwesomeIcons.microphone,
            iconColor: SemanticColors.success,
            iconBg: SemanticColors.successBg,
            title: 'Każdy przystanek potrzebuje audio',
            text:
                'Nagraj lub wgraj plik MP3. Minimalna długość to 15 sekund — krótsze nagrania nie przejdą weryfikacji.',
          ),
          HintItem(
            icon: FontAwesomeIcons.image,
            iconColor: SemanticColors.warning,
            iconBg: SemanticColors.warningBg,
            title: 'Nie zapomnij o zdjęciu okładki',
            text:
                'Trasa bez zdjęcia nie może być wysłana do weryfikacji. Dobra okładka zwiększa szansę na akceptację.',
          ),
        ];

      case TourStatus.pendingReview:
        return const [
          HintItem(
            icon: FontAwesomeIcons.clockRotateLeft,
            iconColor: SemanticColors.warning,
            iconBg: SemanticColors.warningBg,
            title: 'Trasa jest teraz zablokowana',
            text:
                'Podczas weryfikacji nie możesz edytować trasy. Admin ocenia dokładnie tę wersję, którą wysłałeś.',
          ),
          HintItem(
            icon: FontAwesomeIcons.circleInfo,
            iconColor: SemanticColors.info,
            iconBg: SemanticColors.infoBg,
            title: 'Zazwyczaj 1–3 dni robocze',
            text:
                'Po decyzji dostaniesz powiadomienie e-mail. Trasa pojawi się w zakładce "Publiczne" lub wróci do "Odrzucone".',
          ),
          HintItem(
            icon: FontAwesomeIcons.plus,
            iconColor: SemanticColors.success,
            iconBg: SemanticColors.successBg,
            title: 'Możesz już tworzyć kolejną trasę',
            text:
                'Trasa w weryfikacji nie blokuje Ci nowego szkicu. Możesz pracować nad następną trasą równolegle.',
          ),
        ];

      case TourStatus.published:
        return const [
          HintItem(
            icon: FontAwesomeIcons.penToSquare,
            iconColor: SemanticColors.warning,
            iconBg: SemanticColors.warningBg,
            title: 'Edycja = ponowna weryfikacja',
            text:
                'Każda zmiana w opublikowanej trasie powoduje ponowne sprawdzenie. Wcześniejsza akceptacja nie gwarantuje kolejnej.',
          ),
          HintItem(
            icon: FontAwesomeIcons.eyeSlash,
            iconColor: SemanticColors.info,
            iconBg: SemanticColors.infoBg,
            title: 'Możesz ukryć trasę bez utraty statusu',
            text:
                'Przejście do "Prywatne" nie usuwa akceptacji. Trasa wróci do edycji — ale po zapisaniu przejdzie przez weryfikację od nowa.',
          ),
        ];

      case TourStatus.rejected:
        return const [
          HintItem(
            icon: FontAwesomeIcons.triangleExclamation,
            iconColor: SemanticColors.danger,
            iconBg: Color(0xFF2A0A0A),
            title: 'Przeczytaj powód odrzucenia',
            text:
                'Kliknij odrzuconą trasę — zobaczysz komentarz od recenzenta. Odnieś się do każdego punktu zanim wyślesz ponownie.',
          ),
          HintItem(
            icon: FontAwesomeIcons.arrowRotateRight,
            iconColor: SemanticColors.info,
            iconBg: SemanticColors.infoBg,
            title: 'Popraw i wyślij ponownie',
            text:
                'Po edycji trasa wraca do szkiców. Możesz ją poprawić i wysłać do weryfikacji tyle razy ile potrzeba.',
          ),
        ];

      case TourStatus.private:
        return const [
          HintItem(
            icon: FontAwesomeIcons.eyeSlash,
            iconColor: SemanticColors.info,
            iconBg: SemanticColors.infoBg,
            title: 'Trasa niewidoczna dla turystów',
            text:
                'Prywatne trasy nie pojawiają się w aplikacji mobilnej. Tylko Ty możesz je zobaczyć po zalogowaniu.',
          ),
          HintItem(
            icon: FontAwesomeIcons.circleCheck,
            iconColor: SemanticColors.success,
            iconBg: SemanticColors.successBg,
            title: 'Przywrócenie wymaga ponownej weryfikacji',
            text:
                'Jeśli edytowałeś trasę przed przywróceniem, admin sprawdzi ją od nowa. Jeśli nie — może wrócić szybciej.',
          ),
        ];

      default: // null — Wszystkie
        return const [
          HintItem(
            icon: FontAwesomeIcons.circleInfo,
            iconColor: SemanticColors.info,
            iconBg: SemanticColors.infoBg,
            title: 'Jak działa weryfikacja?',
            text:
                'Po wysłaniu trasy nasz zespół sprawdza jakość treści. Zazwyczaj trwa to 1–3 dni robocze.',
          ),
          HintItem(
            icon: FontAwesomeIcons.circleCheck,
            iconColor: SemanticColors.success,
            iconBg: SemanticColors.successBg,
            title: 'Dobra trasa to co najmniej 5 punktów',
            text:
                'Trasy z większą liczbą punktów audio mają wyższy wskaźnik akceptacji i lepsze recenzje turystów.',
          ),
          HintItem(
            icon: FontAwesomeIcons.triangleExclamation,
            iconColor: SemanticColors.warning,
            iconBg: SemanticColors.warningBg,
            title: 'Audio max 3.5 MB na punkt',
            text:
                'Skompresuj nagrania do MP3 128 kbps — brzmią dobrze i ładują się szybko w aplikacji mobilnej.',
          ),
        ];
    }
  }
}
