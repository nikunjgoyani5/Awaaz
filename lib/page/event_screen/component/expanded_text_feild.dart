import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';

class ExpandedTextField extends StatefulWidget {
  const ExpandedTextField(
      {super.key,
        this.height = 100,
        this.maxHeight = 300,
        this.dividerHeight = 20,
        this.dividerSpace = 2,
      required this.child});

  final double height;
  final double maxHeight;
  final double dividerHeight;
  final double dividerSpace;
  final Widget child;

  @override
  State<ExpandedTextField> createState() => _ExpandedTextFieldState();
}

class _ExpandedTextFieldState extends State<ExpandedTextField> {
  double? _height, _maxHeight, _dividerHeight, _dividerSpace;

  @override
  void initState() {
    super.initState();
    _height = widget.height;
    _maxHeight = widget.maxHeight;
    _dividerHeight = widget.dividerHeight;
    _dividerSpace = widget.dividerSpace;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: _maxHeight,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: _height,
            child: widget.child,
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _height = _height! + details.delta.dy;
              
                    // prevent overflow if height is more/less than available space
                    var maxLimit = _maxHeight! - _dividerHeight! - _dividerSpace!;
                    // var minLimit = _height!;
                    var minLimit = 100.00;
              
                    if (_height! > maxLimit) {
                      _height = maxLimit;
                    } else if (_height! < minLimit){
                      _height = minLimit;
                    }
                  });
                },
                child: SizedBox(
                  height: _dividerHeight,
                  width: 15,
                  child: Assets.icons.icDragIcon.svg( width: 15,height: 15,colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
