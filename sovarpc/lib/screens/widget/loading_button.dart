import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool isLoading;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.isLoading,
  });

  @override
  State createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  ButtonStyle _styleButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : _handlePress,
      style: _styleButton(),
      child: widget.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(widget.buttonText),
    );
  }

  void _handlePress() async {
    try {
      setState(() {
        // Встановлюємо стан завантаження кнопки в true перед викликом функції onPressed
        // Це потрібно для блокування кнопки під час завантаження
        // Але текст кнопки не змінюємо тут, оскільки це буде залежати від зовнішніх параметрів
      });
       widget.onPressed();
    } finally {
      setState(() {
        // Після завершення операції знову встановлюємо стан завантаження кнопки в false
        // Це дозволить знову активувати кнопку для натискання
      });
    }
  }
}
