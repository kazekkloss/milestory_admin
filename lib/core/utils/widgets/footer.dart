import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(
            height: 2.0,
            color: Color.fromARGB(255, 49, 49, 49),
            thickness: 1.0,
          ),
          const Spacer(),
          SizedBox(
            width: 850,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('© 2025 MileStory. Wszelkie prawa zastrzeżone', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor)),
                Row(
                  children: [
                    Text('contact@milestory.pl  ', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor)),
                    IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white,)),
                    IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white,))
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
