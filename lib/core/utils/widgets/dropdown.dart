import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../core_export.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double maxWidth;
  final List<Widget>? icons;
  final String hintText;
  final String descriptionText;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.descriptionText,
    this.icons,
    this.maxWidth = double.infinity,
    this.hintText = 'Wybierz opcję',
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    if (icons != null && icons!.length != items.length) {
      throw ArgumentError(
          'Liczba ikon (${icons!.length}) musi być równa liczbie elementów (${items.length}).');
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(
        height: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(descriptionText,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            DropdownButtonFormField2<String>(
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: c.bgCard,
                  borderRadius: BorderRadius.circular(c.radiusMd),
                  border: Border.all(color: c.accentBorder, width: 0.5),
                ),
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 12),
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 0),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 42,
              ),
              value: selectedValue,
              onChanged: onChanged,
              hint: Text(
                hintText,
                style: TextStyle(fontSize: 14, color: c.textMuted),
              ),
              items: items
                  .asMap()
                  .entries
                  .map<DropdownMenuItem<String>>((entry) {
                final index = entry.key;
                final value = entry.value;
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    spacing: 10,
                    children: [
                      if (icons != null && icons!.isNotEmpty) ...[
                        _buildIconWithColor(
                          icon: icons![index],
                          color: c.accent,
                        ),
                      ],
                      Text(
                        value,
                        style: TextStyle(color: c.textPrimary, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithColor({required Widget icon, required Color color}) {
    if (icon is Icon) {
      return Icon(
        (icon).icon,
        color: color,
        size: (icon).size,
      );
    }
    return IconTheme(
      data: IconThemeData(color: color),
      child: icon,
    );
  }
}