import 'package:flutter/material.dart';
class Right_Animation extends PageRouteBuilder{
  final Widget child;
  final AxisDirection direction;
  Right_Animation({
    required this.child,
    this.direction=AxisDirection.right,
  }): super(
    pageBuilder: (context,animation,secondaeyanimation)=>child,
  );

  @override
  Widget buildTransitions(BuildContext context,Animation<double> animation,
      Animation<double> secondaeyanimation, Widget child)=>
      SlideTransition(
        position: Tween<Offset>(
          begin:getBeginOffset(),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  Offset getBeginOffset(){
    switch(direction){
      case AxisDirection.up:
        return(Offset(0, 1));
      case AxisDirection.down:
        return(Offset(0, -1));
      case AxisDirection.right:
        return(Offset(-1, 0));
      case AxisDirection.left:
        return(Offset(1, 0));
    }
  }

}