import 'package:flutter/material.dart';

import '../constaints.dart';
import 'trucksize_modal.dart';
import 'package:http/http.dart';

class DeliveryStatus4 extends StatelessWidget {
  final bool isHover;

  const DeliveryStatus4({
    Key? key,
    required this.isHover,
  }) : super(key: key);

  void _showTruckSizeModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => TruckSizeModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "담당 구역",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isHover ? Colors.white : primary,
                ),
              ),
              Text(
                "봉명 1동",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isHover ? Colors.white : primary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "컨베이어벨트",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isHover ? Colors.white : primary,
                ),
              ),
              Text(
                "3번 라인",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isHover ? Colors.white : primary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            "화물차량(mm)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isHover ? Colors.white : primary,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            "3700 X 1700 X 2100",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isHover ? Colors.white : primary,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () => _showTruckSizeModal(context),
            child: Container(
              width: double.infinity, // 전체 너비
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
                color: isHover ? Colors.white : primary,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(137, 181, 162, 0.56),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Text(
                "화물차량 규격 확인",
                style: TextStyle(
                  color: isHover ? primary : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// API 받아오는 코드 


