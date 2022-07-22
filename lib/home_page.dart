import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Razorpay razorpay;
  int amount = 1000;
  void openCheckout() async {
    var options = {
      "key": "rzp_test_WILXWxUdsDfa9S",
      "amount": 1000,
      "name": "Sakshi Agarwal",
      "description": "Payment For the Service",
      "prefill": {
        "contact": "8527059115",
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    // opening the payment gateway
    try {
      razorpay.open(options);
    } catch (err) {
      print(err.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Login()));
    String _result = await sendSMS(
            message: 'Payment Done ${amount/100}',
            recipients: ["8527059115"],
            sendDirect: true)
        .catchError((onError) {
      print(onError);
    });

    print(_result);
    Fluttertoast.showToast(msg: "Payment Successful");
  }

  void handlerErrorSuccess(PaymentFailureResponse response) {
    print(response.message);
    Fluttertoast.showToast(msg: "Payment UnSuccessful. Some error Occured :(");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: openCheckout, child: Text('Pay')),
            ElevatedButton(onPressed: null, child: Text('Map')),
          ],
        ),
      )),
    );
  }
}
