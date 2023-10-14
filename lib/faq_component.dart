import 'package:flutter/material.dart';

class FAQComponent extends StatefulWidget {
  @override
  _FAQComponentState createState() => _FAQComponentState();
}

class _FAQComponentState extends State<FAQComponent> {
  List<Item> _items = [
    Item('نظریه دلبستگی چیست؟',
        'نظریه دلبستگی که توسط روان- تحلیلگری به نام ژان بولبی تدوین شده است، یک نظریه روان‌شناختی درباره روابط بین انسان‌هاست.  مهم ترین اصل این نظریه این است که کودک برای رشد عاطفی و اجتماعی خود نیازمند برقراری ارتباط با والدین یا مراقبین اصلی خود است.'),
    Item('نظریه دلبستگی به خود چیست؟',
        'نظریه دلبستگی به خود، یک روش خودکمکی است که به افراد کمک می‌کند تا احساسات مثبت خود را افزایش و احساسات منفی را کاهش دهند. در این روش دو شخصیت پررنگ وجود دارند. یکی از آنها خودِ کودکی فرد و دیگری خودِ بزرگسالی فرد است. به این ترتیب سعی می‌شود که فرد بتواند توسط خودِ بزرگسالی‌ در نقش یک پدر یا مادر خوب برای خودِ کودکی باشد و به این ترتیب شخص در رفتارها، باورها، تجارب و احساسات خود در این مسیر برای توسعه احساسی کودک بازنگری داشته باشد تا در نهایت به بهبود حال شخصی منجر شود.'),
    Item('چند مرحله در نظریه دلبستگی به خود وجود دارد؟',
        'چهار مرحله‌ی نظریه دلبستگی به خود به شرح زیر هستند: مرحله اول معرفی نظریه دلبستگی و دلبستگی به خود، مرحله دوم ارتباط با کودکِ داخلی یا همان کودک، مرحله سوم عاشق شدن به کودک و در نهایت مرحله چهارم آموزش رشدی و توسعه‌ای برای کودک است.'),
    Item('منظور از کودک و بزرگسال در این نظریه چیست؟',
        'کودک به «خودِ کودکیِ شما»، همانطور که با یک عکس مورد علاقه و یک عکس غیر مورد علاقه‌ از کودکی‌تان نشان داده می‌شود، اشاره دارد که نماینده الگوها و مدارهای احساسی شماست که کمتر از مدارهای فکری شما توسعه یافته اند. در واقع در طول این دوره، کودک نقش یک جوینده مراقبت و محبت را ایفا می نماید. درحالی که بزرگسال به "خودِ بزرگسالیِ شما" اشاره دارد که نماینده توانایی‌های منطقی و شناختی شماست. بزرگسال نقش یک مراقب را ایفا می نماید تا بتواند در بهبود حال کودک موثر باشد.'),
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
