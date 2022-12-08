// import 'package:antizero_jumpin/handler/vibe_calculator.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/utils/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
//
// class VibeCard extends StatefulWidget {
//   final JumpInUser userToCompare;
//   final bool fromProfile;
//   const VibeCard({Key key, this.userToCompare, this.fromProfile = false})
//       : super(key: key);
//
//   @override
//   _VibeCardState createState() => _VibeCardState();
// }
//
// class _VibeCardState extends State<VibeCard> {
//   double vibeCount;
//
//   @override
//   void initState() {
//     calculateUserVibe();
//     super.initState();
//   }
//
//   calculateUserVibe() async {
//     double vibe = await calculateVibe(widget.userToCompare, context);
//     vibeCount = vibe;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Row(
//       children: [
//         Container(
//           width: size.height * 0.055,
//           height: size.height * 0.055,
//           child: LiquidCircularProgressIndicator(
//             value: vibeCount == null
//                 ? 50.0 / 100
//                 : vibeCount / 100, // Defaults to 0.5.
//             valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
//             backgroundColor: Colors.white,
//             borderColor: Colors.blue[300],
//             borderWidth: 2.0,
//             direction: Axis.vertical,
//             center: Text(
//               vibeCount == null ? '...' : vibeCount.toInt().toString() + "%",
//               textScaleFactor: 1,
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: size.height * 0.02,
//                   fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//         if (widget.fromProfile == false)
//           Column(
//             children: [
//               Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     " Vibe",
//                     textScaleFactor: 1,
//                     style: TextStyle(
//                         fontSize: SizeConfig.blockSizeHorizontal * 4,
//                         color: Colors.black.withOpacity(0.8)),
//                   )),
//               Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Text(
//                       "Meter",
//                       textScaleFactor: 1,
//                       style: TextStyle(
//                           fontSize: SizeConfig.blockSizeHorizontal * 3.1,
//                           color: Colors.black.withOpacity(0.8)),
//                     ),
//                   ))
//             ],
//           ),
//       ],
//     );
//   }
// }
