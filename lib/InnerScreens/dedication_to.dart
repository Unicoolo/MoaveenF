import 'package:flutter/material.dart';

import '../Services/global_variables.dart';

class Dedication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Dedication',
            style: TextStyle(color: appBarTitleColor),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradient1, gradient2],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          'This MOAVEEN App is dedicated to Miss Sana Ayub(Late) Connecting people with disabilities (PWDs) with attendant services is the major goal of the app,PWDs constantly require assistance with movement personal care, shopping, and travel. The apps original concept was provided by Sana Ayub.Sana Ayub was born with muscular dystrophy disability. Due to disability, she had to face immense sympathy from her surrounding persons.  But she decided to convert her life from sympathy to dignity. She pursued her studies in traditional settings. She received her MBA from Riphah University in textile design. She started her career in AZguard9 as a textile designer. During her job, she faced discrimination due to her disability. After that, she joined Punjab Education Foundation (PEF). She was the founder of Empower Welfare Foundation (EWF) for Special Persons.The major goal of her life is to raise awareness of disability issues in society by organizing events that will empower a variety of impaired people. She died in her house in October 2021 as a result of a short circuit and a large fire. We shall never forget her passion to uplift people with disabilities. May Allah Bless Her WIth Highest Rank at Jannat ul Firdous Ameen I would say thanks to the strong collaboration between me, teachers, and the whole academia. Therefore, I learned many things on this journey that challenged me deeply.I am grateful to my advisor Ms Uzma Farooq  for guiding me throughout and always standing by me through thick and thin. I am completely indebted to her whose support, stimulating suggestions and encouragement helped me all the time during the project and the writing of this documentation.I would say thanks to all those who helped me in completing my project. I would also like to say thanks to my sister and parents for encouraging me, their support has always made me strong.Truthfully thanks to my family, friends, and colleagues for being a great source of support and encouragement to complete this work',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                          ),
                        ),
                        Image.asset(
                          'assets/images/dimg.jpeg'
                        )

                      ]))),
        ),
      ),
    );
  }
}
