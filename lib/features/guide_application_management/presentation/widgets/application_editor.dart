import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

class GuideApplicationEditor extends StatelessWidget {
  const GuideApplicationEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuideApplicationBloc, GuideApplicationState>(
      builder: (context, state) {
        return Column(
          children: [
            const Divider(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Imię: ${state.selectedApplication?.firstName ?? ""}",
                      style: CustomTextTheme.textTheme.labelMedium!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Nazwisko: ${state.selectedApplication?.lastName ?? ""}",
                      style: CustomTextTheme.textTheme.labelMedium!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Id: ${state.selectedApplication?.userId ?? ""}",
                      style: CustomTextTheme.textTheme.labelMedium!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 20,
                      children: [
                        EditorTab(question: "Doświadczenie", answer: state.selectedApplication?.q1 ?? "Odpowiedź..."),
                        EditorTab(question: "Motywacja", answer: state.selectedApplication?.q2 ?? "Odpowiedź..."),
                        EditorTab(question: "Przykładowa historia", answer: state.selectedApplication?.q3 ?? "Odpowiedź..."),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomElevatedButton(onPressed: state.selectedApplication!.id.isNotEmpty ? () {} : null, text: "Akceptuj", isLoading: false),
                        const SizedBox(width: 20),
                        CustomElevatedButton(
                          onPressed: state.selectedApplication!.id.isNotEmpty ? () {} : null,
                          text: "Usuń",
                          isLoading: state.deleteApplicationLoading,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EditorTab extends StatelessWidget {
  final String question;
  final String answer;
  const EditorTab({required this.answer, required this.question, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: const Color.fromARGB(255, 49, 49, 49)),
        height: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question, style: CustomTextTheme.textTheme.bodyMedium!),
                const SizedBox(height: 8),
                Text(answer, style: CustomTextTheme.textTheme.labelMedium!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
