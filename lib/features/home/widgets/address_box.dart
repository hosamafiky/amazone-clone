import 'package:amazon_clone/provides/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Container(
      height: 40.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(225, 114, 226, 221),
            Color.fromARGB(225, 162, 236, 233),
          ],
          stops: [0.5, 1.0],
        ),
      ),
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 20.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'Delivery to ${user.name} - ${user.address}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 5.0, top: 2.0),
            child: Icon(Icons.arrow_drop_down_outlined, size: 18.0),
          ),
        ],
      ),
    );
  }
}
