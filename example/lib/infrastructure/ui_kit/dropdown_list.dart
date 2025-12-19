import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Colors, Icons, Theme;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:overlord/overlord.dart';

class DropdownList<ItemType> extends StatefulWidget {
  const DropdownList({
    super.key,
    this.selectedItem,
    required this.items,
    required this.hint,
    this.buttonItemBuilder,
    required this.listItemBuilder,
    required this.onItemSelected,
  });

  final ItemType? selectedItem;
  final List<ItemType> items;

  /// Hint text displayed on the dropdown button when [selectedItem] is `null`.
  final String hint;

  /// Builds the visual representation of the currently selected item.
  ///
  /// When `null`, [listItemBuilder] is used for this purpose, too.
  final Widget Function(BuildContext, ItemType)? buttonItemBuilder;

  /// Builds each item in the dropdown list.
  final Widget Function(BuildContext, ItemType) listItemBuilder;

  final void Function(ItemType) onItemSelected;

  @override
  State<DropdownList<ItemType>> createState() => DropdownListState<ItemType>();
}

class DropdownListState<ItemType> extends State<DropdownList<ItemType>> {
  late final PopoverController _menuController;

  ItemType? _selectedItem;

  @override
  void initState() {
    super.initState();
    _menuController = PopoverController();
    _selectedItem = widget.selectedItem;
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _onItemSelected(ItemType selectedItem) {
    _menuController.close();

    setState(() {
      _selectedItem = selectedItem;
      widget.onItemSelected(selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopoverScaffold(
      controller: _menuController,
      tapRegionGroupId: "dropdown-list",
      buttonBuilder: (BuildContext context) {
        late final Widget buttonContent;
        if (_selectedItem == null) {
          buttonContent = Text(widget.hint);
        } else {
          buttonContent =
              widget.buttonItemBuilder?.call(context, _selectedItem!) ??
              widget.listItemBuilder(context, _selectedItem!);
        }

        // FIXME: Apply this TapRegion within PopoverScaffold in overlord.
        return TapRegion(
          groupId: "dropdown-list",
          child: _DropdownButton(child: buttonContent, onPressed: () => _menuController.toggle()),
        );
      },
      popoverGeometry: const PopoverGeometry(aligner: DropdownListPopoverAligner(gap: 4)),
      popoverBuilder: (BuildContext context) {
        return _DropdownList(items: widget.items, selectedItem: _selectedItem, onItemSelected: _onItemSelected);
      },
    );
  }
}

class _DropdownList<ItemType> extends StatefulWidget {
  const _DropdownList({super.key, required this.items, this.selectedItem, required this.onItemSelected});

  final List<ItemType> items;

  final ItemType? selectedItem;

  final void Function(ItemType) onItemSelected;

  @override
  State<_DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<_DropdownList> {
  final _listFocusNode = FocusNode();
  final _editConfigurationsKey = GlobalKey();

  late GlobalKey _activeItemKey;

  @override
  void initState() {
    super.initState();

    _listFocusNode.requestFocus();

    _activeItemKey = _editConfigurationsKey;
  }

  @override
  void dispose() {
    _listFocusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode focusNode, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (!const [
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.enter,
    ].contains(event.logicalKey)) {
      return KeyEventResult.ignored;
    }

    int activeIndex = _activeIndex;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp && activeIndex > 0) {
      setState(() {
        _activateItemAt(activeIndex - 1);
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown && activeIndex < _listLength - 1) {
      setState(() {
        _activateItemAt(activeIndex + 1);
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      widget.onItemSelected(widget.items[activeIndex]);
    }

    return KeyEventResult.ignored;
  }

  int get _activeIndex =>
      _activeItemKey ==
          _editConfigurationsKey //
      ? 0
      : widget.items.indexWhere((element) => element.key == _activeItemKey) + 1;

  int get _listLength => widget.items.length + 1;

  void _activateItemAt(int index) {
    if (index == 0) {
      _activeItemKey = _editConfigurationsKey;
      return;
    }

    _activeItemKey = widget.items[index - 1].key;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _listFocusNode,
      onKeyEvent: _onKeyEvent,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final config in widget.items)
              _DropdownListItemRow(
                key: config.key,
                isActive: _activeItemKey == config.key,
                onHoverEnter: () {
                  setState(() {
                    _activeItemKey = config.key;
                  });
                },
                onPressed: () => widget.onItemSelected(config),
                child: DefaultTextStyle(
                  style: _activeItemKey == config.key
                      ? DefaultTextStyle.of(context).style.copyWith(color: Colors.white)
                      : DefaultTextStyle.of(context).style,
                  child: _DropdownListItemContent(
                    icon: config.icon,
                    label: config.name,
                    isSelected: widget.selectedItem == config,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DropdownListItemRow extends StatelessWidget {
  const _DropdownListItemRow({
    super.key,
    required this.isActive,
    this.onHoverEnter,
    this.onHoverExit,
    this.onPressed,
    required this.child,
  });

  /// Whether this list item is currently the active item in the list, e.g.,
  /// the item that's focused, or hovered, and should be visually selected.
  final bool isActive;

  final VoidCallback? onHoverEnter;

  final VoidCallback? onHoverExit;

  final VoidCallback? onPressed;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverEnter?.call(),
      onExit: (_) => onHoverExit?.call(),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: isActive ? Colors.blue : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: child,
        ),
      ),
    );
  }
}

class _DropdownListItemContent extends StatelessWidget {
  const _DropdownListItemContent({this.icon, required this.label, this.isSelected = false});

  final Widget? icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 4),
        if (icon != null) //
          Stack(
            clipBehavior: Clip.none,
            children: [
              icon!,
              if (isSelected) //
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(1.1, 1.1),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _DropdownButton extends StatelessWidget {
  const _DropdownButton({this.onPressed, required this.child});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Button(
      padding: const EdgeInsets.only(left: 6, top: 2, bottom: 2, right: 2),
      background: Theme.of(context).canvasColor,
      backgroundOnHover: Theme.of(context).hoverColor,
      backgroundOnPress: Theme.of(context).canvasColor,
      border: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
      borderRadius: BorderRadius.circular(4),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [child, const Icon(Icons.arrow_drop_down)],
      ),
    );
  }
}

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.focusNode,
    this.padding = EdgeInsets.zero,
    this.background = Colors.transparent,
    this.backgroundOnHover,
    this.backgroundOnPress,
    this.border,
    this.borderOnHover,
    this.borderOnPress,
    this.borderRadius = BorderRadius.zero,
    this.enabled = true,
    this.onPressed,
    required this.child,
  });

  final FocusNode? focusNode;

  final EdgeInsets padding;

  final Color background;

  final Color? backgroundOnHover;

  final Color? backgroundOnPress;

  final BorderSide? border;

  final BorderSide? borderOnHover;

  final BorderSide? borderOnPress;

  final BorderRadius borderRadius;

  final bool enabled;

  final VoidCallback? onPressed;

  final Widget child;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late Color _background;
  BorderSide? _border;

  bool _isHovering = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _background = widget.background;
    _border = widget.border;
  }

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateStyles();
  }

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  void _onHoverEnter(PointerEnterEvent event) {
    if (!_isEnabled) {
      return;
    }

    setState(() {
      _isHovering = true;
      _updateStyles();
    });
  }

  void _onHoverExit(PointerExitEvent event) {
    setState(() {
      _isHovering = false;
      _updateStyles();
    });
  }

  void _onPressDown(TapDownDetails details) {
    if (!_isEnabled) {
      return;
    }

    setState(() {
      _isPressed = true;
      _updateStyles();
    });
  }

  void _onPressUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
      _updateStyles();
    });

    if (_isEnabled) {
      widget.onPressed!();
    }
  }

  void _onPressCancel() {
    setState(() {
      _isPressed = false;
      _updateStyles();
    });
  }

  void _updateStyles() {
    _background = widget.background;
    _border = widget.border;

    if (_isHovering) {
      _background = widget.backgroundOnHover ?? _background;
      _border = widget.borderOnHover ?? _border;
    }

    if (_isPressed) {
      _background = widget.backgroundOnPress ?? _background;
      _border = widget.borderOnPress ?? _border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _onHoverEnter,
        onExit: _onHoverExit,
        hitTestBehavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTapDown: _onPressDown,
          onTapUp: _onPressUp,
          onTapCancel: _onPressCancel,
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: _background,
              borderRadius: widget.borderRadius,
              border: _border != null ? Border.fromBorderSide(_border!) : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
