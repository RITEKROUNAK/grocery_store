import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShimmerMessageItem extends StatelessWidget {
  final Size size;

  const ShimmerMessageItem({
    @required this.size,
  });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size.width,
//       padding: const EdgeInsets.all(8.0),
//       margin: const EdgeInsets.symmetric(
//         horizontal: 16.0,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 width: size.width * 0.32,
//                 height: size.width * 0.32,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(11.0),
//                 ),
//               ),
//               SizedBox(
//                 width: 12.0,
//               ),
//               Flexible(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Container(
//                       height: 26.0,
//                       width: size.width * 0.32,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                     Container(
//                       height: 26.0,
//                       width: size.width * 0.15,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                     Container(
//                       height: 26.0,
//                       width: size.width * 0.32,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Container(
//                           height: 26.0,
//                           width: size.width * 0.1,
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.3),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5.0,
//                         ),
//                         Container(
//                           height: 26.0,
//                           width: size.width * 0.1,
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.3),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 8.0,
//           ),
//           Container(
//             height: 26.0,
//             width: size.width * 0.3,
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//           SizedBox(
//             height: 5.0,
//           ),
//           Container(
//             height: 26.0,
//             width: size.width * 0.25,
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//           SizedBox(
//             height: 10.0,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                   height: 26.0,
//                   width: 55.0,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10.0,
//               ),
//               Expanded(
//                 child: Container(
//                   height: 26.0,
//                   width: 55.0,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 5.0,
//           ),
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.0,
      width: size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: size.width * 0.25,
                  // height: size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 25.0,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            height: 25.0,
                            width: 28.0,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        height: 23.0,
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 26.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
