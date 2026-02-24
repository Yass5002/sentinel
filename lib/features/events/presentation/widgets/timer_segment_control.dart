import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class TimerSegmentControl extends StatefulWidget {
  final bool isDurationMode;
  final ValueChanged<bool> onModeChanged;
  final Function(int?, int?, int?) onDurationChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final DateTime? date; // Current selected date

  const TimerSegmentControl({
    super.key,
    required this.isDurationMode,
    required this.onModeChanged,
    required this.onDurationChanged,
    required this.onDateChanged,
    this.date,
  });

  @override
  State<TimerSegmentControl> createState() => _TimerSegmentControlState();
}

class _TimerSegmentControlState extends State<TimerSegmentControl> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Segmented Control
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.darkSurface,
            border: Border.all(color: AppTheme.darkSurface),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildSegmentButton(
                  label: AppLocalizations.of(context)!.duration,
                  isSelected: widget.isDurationMode,
                  onTap: () => widget.onModeChanged(true),
                ),
              ),
              Container(width: 1, color: Colors.black),
              Expanded(
                child: _buildSegmentButton(
                  label: AppLocalizations.of(context)!.date,
                  isSelected: !widget.isDurationMode,
                  onTap: () => widget.onModeChanged(false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Inputs
        if (widget.isDurationMode)
          _buildDurationInputs()
        else
          _buildDateInput(),
      ],
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationInputs() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          _buildTimeBox(
            _hoursController,
            'HH',
            (v) => widget.onDurationChanged(v, null, null),
          ),
          const SizedBox(width: 8),
          const Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          _buildTimeBox(
            _minutesController,
            'MM',
            (v) => widget.onDurationChanged(null, v, null),
          ),
          const SizedBox(width: 8),
          const Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          _buildTimeBox(
            _secondsController,
            'SS',
            (v) => widget.onDurationChanged(null, null, v),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(
    TextEditingController controller,
    String hint,
    ValueChanged<int?> onChanged,
  ) {
    return Expanded(
      child: Container(
        height: 64,
        color: AppTheme.darkSurface,
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 24,
              fontFamily: 'Courier',
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          onChanged: (value) {
            onChanged(int.tryParse(value) ?? 0);
          },
        ),
      ),
    );
  }

  Widget _buildDateInput() {
    final date = widget.date ?? DateTime.now();
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final timeStr =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => _pickDate(context),
              child: Container(
                height: 64,
                color: AppTheme.darkSurface,
                alignment: Alignment.center,
                child: Text(
                  dateStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Courier',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => _pickTime(context),
              child: Container(
                height: 64,
                color: AppTheme.darkSurface,
                alignment: Alignment.center,
                child: Text(
                  timeStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Courier',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.darkSurface,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final current = widget.date ?? now;
      final newDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        current.hour,
        current.minute,
      );
      widget.onDateChanged(newDate);
    }
  }

  void _pickTime(BuildContext context) async {
    final now = DateTime.now();
    final current = widget.date ?? now;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.darkSurface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final newDate = DateTime(
        current.year,
        current.month,
        current.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      widget.onDateChanged(newDate);
    }
  }
}
