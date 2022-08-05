import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/category_products_chart.dart';
import 'package:amazon_clone/models/sales.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final adminServices = AdminServices();
  dynamic totalEarnings = 0;
  List<Sale> sales = [];

  @override
  void initState() {
    super.initState();
    adminServices.getAnalytics(context).then((value) {
      setState(() {
        totalEarnings = value['totalEarnings'];
        sales = value['sales'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Earning',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$$totalEarnings',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 250.0,
          child: CategoryProductsChart(seriesList: [
            charts.Series(
              id: 'Sales',
              data: sales,
              domainFn: (Sale sale, _) => sale.label,
              measureFn: (Sale sale, _) => sale.earnings,
            ),
          ]),
        ),
      ],
    );
  }
}
