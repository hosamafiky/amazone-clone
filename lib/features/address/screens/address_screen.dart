import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen(this.totalAmount, {Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();
  final addressServices = AddressServices();
  final flatBuildingController = TextEditingController();
  final areaController = TextEditingController();
  final pinCodeController = TextEditingController();
  final cityController = TextEditingController();

  String address = '';

  @override
  void initState() {
    super.initState();
    _getUserLocation().then((value) {
      addressServices.updateUserAddress(context: context, address: value);
      setState(() {
        address = value;
      });
    });

    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
  }

  List<PaymentItem> paymentItems = [];
  void onGooglePaymentResult(result) {
    addressServices.placeAnOrder(
      context: context,
      address: address,
      totalAmount: double.parse(widget.totalAmount),
    );
  }

  void onApplePaymentResult(result) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.updateUserAddress(context: context, address: address);
    }

    addressServices.placeAnOrder(
      context: context,
      address: address,
      totalAmount: double.parse(widget.totalAmount),
    );
  }

  void onPayPressed(String addressFromProvider) {
    address = '';
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pinCodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        address =
            '${flatBuildingController.text},${areaController.text}, ${cityController.text} - ${pinCodeController.text}';
      } else {
        throw Exception('Please Enter all required fields');
      }
    } else if (addressFromProvider.isNotEmpty) {
      address = addressFromProvider;
    } else {
      showSnackBar(context, message: 'Please Enter all required fields');
    }
  }

  Future<String> _getUserLocation() async {
    Position position = await _determinePosition();
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return '${placeMarks[0].locality}, ${placeMarks[0].administrativeArea}, ${placeMarks[0].country} - ${placeMarks[0].postalCode}';
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: const Text('ADDRESS'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (address.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  address,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'OR',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      controller: pinCodeController,
                      hintText: 'Pin Code',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'City, Town',
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GooglePayButton(
                width: double.infinity,
                height: 50.0,
                onPressed: () => onPayPressed(address),
                paymentConfigurationAsset: 'gpay.json',
                type: GooglePayButtonType.buy,
                onPaymentResult: onGooglePaymentResult,
                paymentItems: paymentItems,
                loadingIndicator:
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Place an Order',
                onPressed: () => addressServices.placeAnOrder(
                  context: context,
                  address: address,
                  totalAmount: double.parse(widget.totalAmount),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ApplePayButton(
                width: double.infinity,
                height: 50.0,
                paymentConfigurationAsset: 'applepay.json',
                type: ApplePayButtonType.buy,
                onPaymentResult: onApplePaymentResult,
                paymentItems: paymentItems,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
