import 'package:flutter/material.dart';

class LogSyncButton extends StatefulWidget {
  final Future<void> Function()? onSync;

  const LogSyncButton({super.key, this.onSync});

  @override
  State<LogSyncButton> createState() => _LogSyncButtonState();
}

class _LogSyncButtonState extends State<LogSyncButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> syncLog() async {
    if (isSyncing) return;

    setState(() => isSyncing = true);
    _controller.repeat();

    try {
      if (widget.onSync != null) {
        await widget.onSync!();
      } else {
        await Future.delayed(const Duration(milliseconds: 1200));
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 19),
                SizedBox(width: 8),
                Text('Log updated'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 19,
                ),
                SizedBox(width: 8),
                Expanded(child: Text("Couldn't update your log")),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: syncLog,
            ),
          ),
        );
    } finally {
      if (!mounted) return;
      _controller.stop();
      _controller.reset();
      setState(() => isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFEFF1F5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: isSyncing ? null : syncLog,
        padding: EdgeInsets.zero,
        splashRadius: 22,
        tooltip: 'Sync log',
        icon: RotationTransition(
          turns: _controller,
          child: Icon(
            Icons.sync_rounded,
            color: isSyncing
                ? const Color(0xFFA0A8B8)
                : const Color(0xFF17203A),
            size: 21,
          ),
        ),
      ),
    );
  }
}
