// import 'package:antizero_jumpin/utils/colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// class FavouriteBox extends StatelessWidget {
//   final String label;
//   final String subCatImage;
//   final Color color;
//
//   const FavouriteBox(
//       {Key key,
//         this.label,
//         this.subCatImage,
//         this.color})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Stack(
//       children: [
//         InkWell(
//           splashColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           focusColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           child: Container(
//             width: size.height * 0.12,
//             height: size.height * 0.12,
//             padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
//             decoration: BoxDecoration(
//                 color: Colors.grey[350],
//                 shape: BoxShape.rectangle,
//                 border: Border.all(color: blueborder),
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 image: DecorationImage(
//                   image: NetworkImage(subCatImage),
//                   fit: BoxFit.cover,
//                 )),
//             // child: Image.network(widget.imgMsg, fit: BoxFit.cover),
//           ),
//         ),
//       ],
//     );
//   }
// }
