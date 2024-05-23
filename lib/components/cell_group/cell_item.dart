import 'package:flutter/material.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/cell_group/cell_group.dart';

class CellItem extends StatelessWidget {
  final int i;
  final bool bottomBorder;
  final double borderRadius;
  final CellModule item;

  const CellItem({
    super.key,
    required this.i,
    required this.item,
    this.bottomBorder = false,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(i == 0 ? 10 : 0),
          bottom: Radius.circular(bottomBorder ? 10 : 0),
        ),
      ),
      child: InkWell(
        onTap: () {
          item.callback?.call(item);
        },
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(i == 0 ? 10 : 0),
          bottom: Radius.circular(bottomBorder ? 10 : 0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              if (item.leading != null) item.leading!,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.title,
                    style: tx16,
                  ),
                ),
              ),
              item.trailing ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.subTitle != null)
                        Text("${item.subTitle}",
                            style: tx14.copyWith(color: secondaryTextC)),
                      const SizedBox(width: 10),
                      if (item.showArrow)
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: secondaryTextC, size: 14),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
