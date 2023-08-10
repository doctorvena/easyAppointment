// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       themeMode: ThemeMode.dark,
//       home: PaymentScreen(),
//     );
//   }
// }

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   Map<String, dynamic>? paymentIntent;

//   String calculateAmount(String amount) {
//     final calculatedAmount = (int.parse(amount)) * 100;
//     return calculatedAmount.toString();
//   }

//   Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     Map<String, dynamic> body = {
//       'amount': calculateAmount(amount),
//       'currency': currency,
//       'payment_method_types[]': 'card'
//     };
//     final response = await http.post(
//       Uri.parse('https://api.stripe.com/v1/payment_intents'),
//       body: body,
//       headers: {
//         'Authorization': 'Bearer YOUR_SECRET_KEY',
//         'Content-Type': 'application/x-www-form-urlencoded'
//       },
//     );

//     print("Payment Intent Body->>> ${response.body.toString()}");

//     return jsonDecode(response.body);
//   }

//   Future<void> makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent('10', 'USD');
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent!['client_secret'],
//         ),
//       );
//       displayPaymentSheet();
//     } catch (e) {
//       print('Error is: $e');
//     }
//   }

//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: const [
//                     Icon(Icons.check_circle, color: Colors.green),
//                     Text("Payment Successful"),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//       paymentIntent = null;
//     } catch (e) {
//       print('Error is: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Payment'),
//       ),
//       body: Center(
//         child: TextButton(
//           child: const Text('Make Payment'),
//           onPressed: makePayment,
//         ),
//       ),
//     );
//   }
// }
