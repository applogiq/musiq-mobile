import 'package:flutter/material.dart';
import 'package:musiq/src/model/radio_model.dart';

import '../constants/color.dart';

class CustomRadio extends StatefulWidget {
  const CustomRadio({Key? key}) : super(key: key);

  @override
  createState() => CustomRadioState();
  
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> sampleData = [];

  @override
  void initState() {
    sampleData.add(RadioModel(false, 'Low'));
    sampleData.add(RadioModel(false, 'Medium'));
    sampleData.add(RadioModel(false, 'High'));
    sampleData.add(RadioModel(true, 'Automatic'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return  InkWell(
          //highlightColor: Colors.red,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
            });
          },
          child:  RadioItem(sampleData[index]),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(vertical: 12),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           Container(
            // margin: new EdgeInsets.only(left: 10.0),
            child: Text(
              _item.text,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color:
                      _item.isSelected ? Colors.white : CustomColor.subTitle),
            ),
          ),
          _item.isSelected
              ? const Center(
                  child:  Icon(
                Icons.check,
                color: Colors.white,
              ))
              : Container(),
        ],
      ),
    );
  }
}
