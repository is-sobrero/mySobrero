import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {

  final Widget child;
  final bool expand;
  final bool debug;
  ExpandedSection({this.expand = false, this.child, this.debug = false});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    if(widget.expand) expandController.forward();
    else expandController.reverse();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  int stateCounter = 0;

  void _runExpandCheck() {
    //expandController.duration = Duration(milliseconds: 500);
    if(widget.expand) expandController.forward();
    else expandController.reverse();
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debug)print("Count rebuild: ${++stateCounter}");
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: animation,
        child: widget.child
    );
  }
}
