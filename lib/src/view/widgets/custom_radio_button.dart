import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';

import '../../model/radio_model.dart';

class CustomRadio extends StatefulWidget {
  @override
  createState() {
    return new CustomRadioState();
  }
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
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          //highlightColor: Colors.red,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
            });
          },
          child: new RadioItem(sampleData[index]),
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
      padding: new EdgeInsets.symmetric(vertical: 12),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
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
              ? Container(
                  child: new Center(
                      child: Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
                )
              : Container(),
        ],
      ),
    );
  }
}
