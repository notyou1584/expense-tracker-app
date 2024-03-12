// import 'package:demo222/utils/ui/your_recents.dart';
// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:demo222/utils/ui/recent.dart';

// class HomeScreen extends StatelessWidget {
//   final String? userId;

//   const HomeScreen({Key? key, this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             height: 100,
//             child: SingleChildScrollView(
//               // Wrap ListView with SingleChildScrollView
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.red,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.blue,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.green,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.yellow,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.orange,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric( horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Your expenses',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromRGBO(30, 81, 85, 1),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => recents(userId: userId ?? ''),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'See All',
//                     style: TextStyle(
//                       color: Colors.black, // Adjust the color as needed
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Expense list
//           Expanded(
//             child: ExpenseList(userId: userId ?? ''),
//           ),
//         ],
//       ),
//     );
//   }
// }
