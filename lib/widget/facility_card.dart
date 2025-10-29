import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/model/facility_model.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({super.key, required this.location, required this.onTap, required this.width});
  final FacilityModelResponse location;
  final void Function() onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return _buildFacilityCard(context, width, location, onTap);
  }

  Widget _buildFacilityCard(BuildContext context, double width, FacilityModelResponse location, void Function() onTap) {
    return Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: InkWell(
            onTap: () { 
              onTap();
            },
            child: Container(
            padding: const EdgeInsets.all(10),
            child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 255, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(location.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          // const Icon(Icons.video_library, size: 36,),
                        ],
                      ),
                    )),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child : Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text('주소: ${location.roadAddress ?? ''} (${_buildDistance(location.distance)})', style: TextStyle(fontSize: 14,),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('운영여부:', style: TextStyle(fontSize: 14,),),
                              Text(location.status ?? '', style: TextStyle(fontSize: 14,),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('TEL:', style: TextStyle(fontSize: 14,),),
                              Text(location.phoneNumber ?? '', style: TextStyle(fontSize: 14,),),
                              ],
                            ),
                        ],),
                      )
                    )
                    
                  ],
                )
              ),
            ),
          )
        );
  }

  String _buildFacilityName(String name) {
    if (name.length > 9) {
      return '${name.substring(0, 14)}...';
    }
    return name;
  }

  String _buildDistance(double? distance) {
    if (distance == null) {
      return '현 위치로부터 알 수 없음';
    }
    return '현 위치로부터 ${(distance / 1000.0).toStringAsFixed(1)}km';
  }
}
