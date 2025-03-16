// Controller to manage the bottom sheet state
import 'package:flutter/material.dart';

class BottomSheetController {
  VoidCallback? _showCallback;
  VoidCallback? _hideCallback;
  VoidCallback? _toggleCallback;
  ValueGetter<bool>? _isVisibleGetter;

  // Register callbacks
  void _registerCallbacks({
    required VoidCallback showCallback,
    required VoidCallback hideCallback,
    required VoidCallback toggleCallback,
    required ValueGetter<bool> isVisibleGetter,
  }) {
    _showCallback = showCallback;
    _hideCallback = hideCallback;
    _toggleCallback = toggleCallback;
    _isVisibleGetter = isVisibleGetter;
  }

  // Public methods to control the bottom sheet
  void show() {
    if (_showCallback != null) {
      _showCallback!();
    }
  }

  void hide() {
    if (_hideCallback != null) {
      _hideCallback!();
    }
  }

  void toggle() {
    if (_toggleCallback != null) {
      _toggleCallback!();
    }
  }

  // Clean up
  void dispose() {
    _showCallback = null;
    _hideCallback = null;
    _toggleCallback = null;
    _isVisibleGetter = null;
  }

  bool get isVisible => _isVisibleGetter?.call() ?? false;
}

class BottomSheetWithController extends StatefulWidget {
  final Widget child;
  final double sheetHeight;
  final BottomSheetController? controller;
  final bool showButton;
  final bool handleBackButton;

  const BottomSheetWithController({
    Key? key,
    required this.child,
    this.sheetHeight = 300,
    this.controller,
    this.showButton = false,
    this.handleBackButton = true,
  }) : super(key: key);

  @override
  State<BottomSheetWithController> createState() =>
      _BottomSheetWithControllerState();
}

class _BottomSheetWithControllerState extends State<BottomSheetWithController>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _offsetAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    // Register callbacks with controller if provided
    if (widget.controller != null) {
      widget.controller!._registerCallbacks(
        showCallback: show,
        hideCallback: hide,
        toggleCallback: toggle,
        isVisibleGetter: () => _isVisible,
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void show() {
    if (!_isVisible) {
      setState(() {
        _isVisible = true;
        _animController.forward();
      });
    }
  }

  void hide() {
    if (_isVisible) {
      setState(() {
        _isVisible = false;
        _animController.reverse();
      });
    }
  }

  void toggle() {
    setState(() {
      _isVisible = !_isVisible;
      if (_isVisible) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        // The toggle button (optional)
        if (widget.showButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: toggle,
              child: Icon(_isVisible ? Icons.close : Icons.keyboard_arrow_up),
            ),
          ),

        // The bottom sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: widget.sheetHeight,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  InkWell(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    onTap: () {
                      toggle();
                    },
                  ),
                  // Content
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (widget.handleBackButton) {
      return WillPopScope(
        onWillPop: () async {
          if (_isVisible) {
            hide();
            return false; // Prevent app from closing
          }
          return true; // Allow back navigation
        },
        child: content,
      );
    }

    return content;
  }
}

class BottomSheetManager {
  static final BottomSheetManager _instance = BottomSheetManager._internal();
  factory BottomSheetManager() => _instance;
  BottomSheetManager._internal();

  final List<BottomSheetController> _sheetControllers = [];

  void registerSheet(BottomSheetController controller) {
    if (!_sheetControllers.contains(controller)) {
      _sheetControllers.add(controller);
    }
  }

  void unregisterSheet(BottomSheetController controller) {
    _sheetControllers.remove(controller);
  }

  bool handleBackPress() {
    // Find the last visible sheet and hide it
    for (int i = _sheetControllers.length - 1; i >= 0; i--) {
      if (_sheetControllers[i].isVisible) {
        _sheetControllers[i].hide();
        return true; // Back press handled
      }
    }
    return false; // No sheet to hide
  }
}
