// import 'package:demo222/utils/ui/new_group.dart';
// import 'package:flutter/material.dart';

// class GroupScreen extends StatelessWidget {
//   const GroupScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Group Screen')),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back arrow action
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Handle notification bell action
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Bar
//             Container(
//               width: double.infinity,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.search),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search groups...',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Existing Groups
//             const GroupCard(name: 'Group 1'),
//             const SizedBox(height: 8),
//             const GroupCard(name: 'Group 2'),
//             const SizedBox(height: 8),
//             const GroupCard(name: 'Group 3'),
//             // Add more groups as needed
//             const SizedBox(height: 16),
//             // Start a New Group Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CreateGroupScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.black,
//                   backgroundColor: Colors.white, // Black font color
//                   side: const BorderSide(color: Colors.black), // Black border
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16.0,
//                     horizontal: 32.0,
//                   ),
//                 ),
//                 child: const Text(
//                   'Start a New Group',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GroupCard extends StatelessWidget {
//   final String name;

//   const GroupCard({Key? key, required this.name}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(25)),
//             ),
//             child: const Icon(Icons.group, color: Colors.white),
//           ),
//           const SizedBox(width: 16),
//           Text(
//             name,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
