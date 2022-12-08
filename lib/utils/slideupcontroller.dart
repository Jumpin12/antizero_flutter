// import 'package:antizero_jumpin/provider/slideup.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// class SlideUpController {
//   SlideUpController._private();
//
//   static final SlideUpController instance = SlideUpController._private();
//
//   factory SlideUpController() => instance;
//
//   BuildContext _providerContext;
//
//   set providerContext(BuildContext context) {
//     if (_providerContext != context) {
//       _providerContext = context;
//     }
//   }
//
//   void toggle() {
//     if (_providerContext != null) {
//       final provider = _providerContext.read<SlideUpProvider>();
//       provider.updateState(!provider.isShow);
//     } else {
//       print('Need init provider context');
//     }
//   }
// }