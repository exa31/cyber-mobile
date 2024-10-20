import 'package:cyber/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBarSearchWidget extends StatelessWidget {
  const TopBarSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Hero(
            tag: 'searchField',
            child: Material(
              child: TextField(
                onTap: () {
                  Get.toNamed(Routes.SEARCH_PRODUCT);
                },
                decoration: InputDecoration(
                  hintText: 'Search Products...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
