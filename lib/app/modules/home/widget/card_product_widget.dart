import 'package:cyber/app/routes/app_pages.dart';
import 'package:cyber/helper/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class CardProductWidget extends StatelessWidget {
  CardProductWidget(
      {super.key,
      required this.id,
      required this.imageThumbnail,
      required this.name,
      required this.price});
  final String imageThumbnail;
  final String name;
  final String id;
  final int price;
  final url = dotenv.env['BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('${Routes.HOME}detail-product/$id', arguments: {
        'id': id,
      }),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "$url/images$imageThumbnail",
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/no_image.jpg',
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      );
                    },
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              Helper.formatPrice(price),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
