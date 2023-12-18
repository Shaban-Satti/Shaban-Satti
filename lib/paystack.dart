import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:payment_integration/paymentSuccess.dart';

class PayStackPayment extends StatefulWidget {
  const PayStackPayment({super.key});

  @override
  State<PayStackPayment> createState() => _PayStackPaymentState();
}

class _PayStackPaymentState extends State<PayStackPayment> {
  final formkey=GlobalKey<FormState>();
  TextEditingController amountController=TextEditingController();
  TextEditingController emailController=TextEditingController();

  String publicKey = 'pk_test_79878c9dc401ab5dc178c9a4dc1c7fca4038ca32';
  final plugin = PaystackPlugin();
  String message = '';
  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  void makePayment() async {
    int price = int.parse(amountController.text) * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now()}'
      ..email = emailController.text
      ..currency = 'GHS';

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      message = 'Payment was successful. Ref: ${response.reference}';
      if (mounted) {}
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentSuccess(message: message)),
          ModalRoute.withName('/'));
    } else {
      print(response.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title:  Text('PayStack Payment'),),
      body: Padding(
        padding: const EdgeInsets.only(top: 15,left: 15),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: amountController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Please Enter the Amount';
                  }
                  return null;
                },
                decoration:  const InputDecoration(
                  prefix: Text('GHS'),
                  hintText: '1000',
                  labelText: 'Amount',
                  border: OutlineInputBorder(),

                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Please Enter the Email';
                  }
                  return null;
                },
                decoration:  const InputDecoration(

                  hintText: 'email@gmail.com',
                  labelText: 'Email',
                  border: OutlineInputBorder(),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(onPressed: (){
                  makePayment();

                },
                    child: Text('Make Payment')),
              )
            ],
          ),
        ),
      ),
    );

  }
}
