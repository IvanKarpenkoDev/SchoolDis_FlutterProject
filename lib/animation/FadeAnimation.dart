// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';

// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;

//   FadeAnimation(this.delay, this.child);

//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTween()<AnimProps>()
//       ..add(
//         AnimProps.opacity,
//         Tween(begin: 0.0, end: 1.0),
//         Duration(milliseconds: 500),
//       )
//       ..add(
//         AnimProps.translateY,
//         Tween(begin: -30.0, end: 0.0),
//         Duration(milliseconds: 500),
//         curve: Curves.easeOut,
//       );

//     return PlayAnimation<MultiTweenValues<AnimProps>>(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builder: (context, child, value) => Opacity(
//         opacity: value.get(AnimProps.opacity),
//         child: Transform.translate(
//           offset: Offset(0, value.get(AnimProps.translateY)),
//           child: child,
//         ),
//       ),
//     );
//   }
// }

// enum AnimProps { opacity, translateY }
