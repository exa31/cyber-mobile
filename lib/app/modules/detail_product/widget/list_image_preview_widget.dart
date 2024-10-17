import 'dart:developer';

import 'package:cyber/app/modules/detail_product/controllers/detail_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class ListImagePreview extends StatelessWidget {
  ListImagePreview(
      {super.key, required this.index, required this.detailProductController});

  final url = dotenv.env['BASE_URL'].toString();
  final int index;
  final DetailProductController detailProductController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: detailProductController,
        builder: (controller) {
          return InkWell(
            onTap: () {
              log("changeActiveImage ListImagePreview ${detailProductController.imageDetails![index]}");
              return detailProductController.changeActiveImage(
                detailProductController.imageDetails![index],
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Opacity(
                opacity: detailProductController.activeImage ==
                        detailProductController.imageDetails![index]
                    ? 1
                    : 0.5,
                child: Image.network(
                  "$url/images/${detailProductController.imageDetails![index]}",
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/no_image.jpg',
                      width: detailProductController.activeImage ==
                              detailProductController.imageDetails![index]
                          ? 80
                          : 60,
                      height: detailProductController.activeImage ==
                              detailProductController.imageDetails![index]
                          ? 80
                          : 60,
                      fit: BoxFit.cover,
                    );
                  },
                  width: detailProductController.activeImage ==
                          detailProductController.imageDetails![index]
                      ? 80
                      : 60,
                ),
              ),
            ),
          );
        });
  }
}
