import 'package:SMP/model/inventory_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/colors_utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryGridViewCard extends StatelessWidget {
  final Function(Value) press;
  final List<Value> goodsInvList;
  final String baseImageIssueApi;

  const InventoryGridViewCard(
      {super.key,
      required this.goodsInvList,
      required this.baseImageIssueApi,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: goodsInvList.length,
      itemBuilder: (context, index) {
        final user = goodsInvList[index];
        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: FontSizeUtil.SIZE_10,
                horizontal: FontSizeUtil.SIZE_05),
            child: Container(
              decoration: AppStyles.decoration(context),
              padding: EdgeInsets.only(
                top: FontSizeUtil.SIZE_05,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                    child: Container(
                      padding: EdgeInsets.zero,
                      decoration:
                      BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            SmpAppColors.white,
                            SmpAppColors.white
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(FontSizeUtil.SIZE_01),
                            spreadRadius: FontSizeUtil.SIZE_01,
                            blurRadius: FontSizeUtil.SIZE_05,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size:  Size.fromRadius(FontSizeUtil.CONTAINER_SIZE_50), // Image radius
                          child: (user.image != null && user.image!.isNotEmpty)
                              ? Image.network(
                                  '$baseImageIssueApi${user.image.toString()}',
                                  fit: BoxFit.cover,
                                  height: FontSizeUtil.CONTAINER_SIZE_100,
                                  width: FontSizeUtil.CONTAINER_SIZE_100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/no-img.png",
                                      fit: BoxFit.fill,
                                      height: FontSizeUtil.CONTAINER_SIZE_100,
                                      width: FontSizeUtil.CONTAINER_SIZE_100,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/images/no-img.png",
                                  fit: BoxFit.fill,
                                  height: FontSizeUtil.CONTAINER_SIZE_100,
                                  width: FontSizeUtil.CONTAINER_SIZE_100,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: FontSizeUtil.SIZE_10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.goodsName!,
                          style: AppStyles.blockText(context),
                        ),
                        SizedBox(height: FontSizeUtil.SIZE_05),
                        Text(
                          DateFormat('y-MM-dd hh:mm:ss a')
                              .format(DateTime.parse(user.inTime as String)),
                          style: AppStyles.blockText(context),
                        ),
                        SizedBox(height: FontSizeUtil.SIZE_05),
                        Padding(
                          padding: EdgeInsets.only(top: FontSizeUtil.SIZE_03),
                          child: Text(
                            user.quantity!,
                            style: AppStyles.blockText(context),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              user.movementType!,
                              style: AppStyles.blockText(context),
                            ),
                            user.movementType == Strings.INVENTORYOUTGOING
                                ? Icon(
                                    Icons.arrow_upward,
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    size: FontSizeUtil.CONTAINER_SIZE_25,
                                  )
                                : Icon(
                                    Icons.arrow_downward,
                                    color:
                                        const Color.fromARGB(255, 81, 255, 0),
                                    size: FontSizeUtil.CONTAINER_SIZE_25,
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: FontSizeUtil.SIZE_05,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
