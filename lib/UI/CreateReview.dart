import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/UI/ViewRatingForm.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

// void main() => runApp(CreateForm());

class CreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formAppBarTitle = "What do you think about the product?";

    return MaterialApp(title: formAppBarTitle, home: AddReviewForm());
  }
}

class AddReviewForm extends StatefulWidget {
  @override
  AddReviewFormState createState() {
    return AddReviewFormState();
  }
}

class AddReviewFormState extends State<AddReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final reference = Firestore.instance.collection('reviews').reference();
  double rating = 0.0;
  String review = '';
  DateTime ratingDate = DateTime.now();

  Future<Null> _selectReviewDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: ratingDate,
        firstDate: DateTime(1997, 12),
        lastDate: DateTime(2099, 12));

    if (selectedDate != null && selectedDate != ratingDate) {
      setState(() {
        ratingDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const edgeInsetValue = 8.0;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
           image: Image.network('https://wonderfulengineering.com/wp-content/uploads/2016/01/phone-wallpaper-HD-17-610x1084.jpg').image,
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('What do you think?'),
          elevation: 0,
          backgroundColor: Colors.amber,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(
              edgeInsetValue, edgeInsetValue, edgeInsetValue, edgeInsetValue),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      
                      height: 30.0,
                    ),
                    Padding(
                       padding: EdgeInsets.all(3.0),
                      child: Text(
                        'Tell us something',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      
                      maxLines: 5,
                      validator: (value) {
                        setState(() {
                          this.review = value;
                        });
                        if (value.isEmpty) {
                          return 'Please add a review';
                        }
                        return null;
                      },
                      
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 5.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "What do you think?",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Your Ratings',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SmoothStarRating(
                        allowHalfRating: true,
                        onRatingChanged: (val) {
                          setState(() {
                            rating = val;
                            print('The rating is $rating');
                          });
                        },
                        starCount: 5,
                        rating: this.rating,
                        size: 40,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        color: Colors.orangeAccent,
                        borderColor: Colors.orange,
                        spacing: 0.0,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        IconButton(
                          icon:Icon( Icons.date_range,color: Colors.white,),
                          onPressed: () => _selectReviewDate(context),
                          //child: Text('Select Date'),
                        ),
                        Text(
                          "${ratingDate.toLocal()}".split(' ')[0],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            addReviewToDb(review, rating, ratingDate);
                          }
                        },
                        child: (Text('Submit')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewRatingApp()));
                        },
                        child: Text('View all Reviews'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addReviewToDb(String review, double rating, DateTime ratingDate) {
    Map<String, dynamic> data = Map();
    data['review'] = review;
    data['rating'] = rating;
    data['date'] = ratingDate;
    //if u want to print uncomment
    //     print(data['review']);
    //     print(data['rating']);
    /////////////////////////////

    reference.add(data);
  }
}
