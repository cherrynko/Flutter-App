import 'package:flutter/material.dart';

class FAQComponent extends StatefulWidget {
  @override
  _FAQComponentState createState() => _FAQComponentState();
}

class _FAQComponentState extends State<FAQComponent> {
  List<Item> _items = [
    Item('اٹیچمنٹ تھیوری کیا ہے؟',
        'ماہر نفسیات جین بولبی کے ذریعہ تیار کردہ منسلک نظریہ انسانی تعلقات کے بارے میں ایک نفسیاتی نظریہ ہے۔ اس نظریہ کا سب سے اہم اصول یہ ہے کہ بچے کو اپنی جذباتی اور سماجی نشوونما کے لیے اپنے والدین یا بنیادی دیکھ بھال کرنے والوں کے ساتھ بات چیت کرنے کی ضرورت ہے۔'),
    Item('خود سے منسلک نظریہ کیا ہے؟',
        'سیلف اٹیچمنٹ تھیوری ایک سیلف ہیلپ طریقہ ہے جو لوگوں کو ان کے مثبت جذبات کو بڑھانے اور ان کے منفی جذبات کو کم کرنے میں مدد کرتا ہے۔ اس طریقے میں، دو بولڈ حروف ہیں۔ ان میں سے ایک کا بچپن کا نفس ہے اور دوسرا بالغ نفس۔ اس طرح سے یہ کوشش کی جاتی ہے کہ وہ شخص جوانی میں ہی بچے کے لیے ایک اچھا باپ یا ماں بن سکے اور اس طرح وہ شخص اپنے طرز عمل، عقائد، تجربات اور احساسات پر نظر ثانی کر کے بچے کی جذباتی نشوونما کر سکے۔ ، تاکہ آخر کار ذاتی بہتری کا باعث بنے۔.'),
    Item('سیلف اٹیچمنٹ تھیوری میں کتنے مراحل ہیں؟',
        'سیلف اٹیچمنٹ تھیوری کے چار مراحل درج ذیل ہیں: پہلا مرحلہ نظریہ اٹیچمنٹ اور سیلف اٹیچمنٹ کا تعارف ہے، دوسرا مرحلہ اندرونی بچے یا بچے کے ساتھ بات چیت کا ہے، تیسرا مرحلہ اس کے ساتھ محبت میں پڑنا ہے۔ بچہ، اور آخر میں چوتھا مرحلہ بچے کے لیے ترقیاتی اور ترقیاتی تعلیم ہے۔.'),
    Item('اس نظریہ میں بچے اور بالغ سے کیا مراد ہے؟',
        'چائلڈ سے مراد آپ کا "بچپن کی ذات" ہے، جیسا کہ آپ کے بچپن کی ایک پسندیدہ اور غیر پسندیدہ تصویر سے ظاہر ہوتا ہے، جو آپ کے جذباتی نمونوں اور سرکٹس کی نمائندگی کرتا ہے جو آپ کے فکری سرکٹس سے کم ترقی یافتہ ہیں۔ درحقیقت، اس مدت کے دوران، بچہ دیکھ بھال اور پیار کے متلاشی کا کردار ادا کرتا ہے۔ جبکہ بالغ سے مراد "آپ کا بالغ خود" ہے جو آپ کی منطقی اور علمی صلاحیتوں کی نمائندگی کرتا ہے۔ بالغ بچے کی حالت کو بہتر بنانے میں موثر ہونے کے لیے دیکھ بھال کرنے والے کا کردار ادا کرتا ہے۔'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: _items.map<Widget>((Item item) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 750, // Adjust the width as needed
            decoration: BoxDecoration(
              color: Colors.grey[300], // Background color
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
            child: Directionality(
              textDirection:
                  TextDirection.rtl, // Set text direction to right-to-left
              child: ExpansionPanelList.radio(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.all(16.0),
                children: [
                  ExpansionPanelRadio(
                    value: item.question,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          item.question,
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth < 600 ? 15 : 17, // Text size
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        item.answer,
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: screenWidth < 600 ? 15 : 17, // Text size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class Item {
  Item(this.question, this.answer);

  final String question;
  final String answer;
}
