import 'package:flutter/material.dart';
import 'db.dart';
import 'movie.dart';

class EditMovie extends StatelessWidget {
  Movie? movie;


  EditMovie(this.movie);
  DB databaseHelper = DB();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();


  void _save(BuildContext context) async {


    int result;
    if (movie!.id != null) {  // Case 1: Update operation
      result = await databaseHelper.updateMovie(movie!);
      debugPrint("updateMovie Success");
    } else { // Case 2: Insert Operation
      result = await databaseHelper.insertMovie(movie!);
      debugPrint("insertMovie Success");
    }

    if (result != 0) {  // Success
      debugPrint("Save Success");
    } else {  // Failure
      debugPrint("Save Failure");
    }
    moveToLastScreen(context);
  }

  void moveToLastScreen(BuildContext context) {
    Navigator.pop(context, true);
  }
  void updateTitle() async {

    movie!.title = titleController.text;
  }

  void updateDescription() {
    movie!.plot = descriptionController.text;
  }

  void updateImage() {
    movie!.posterUrl = imageController.text;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    titleController.text = movie!.title;
    descriptionController.text = movie!.plot;
    imageController.text = movie!.posterUrl;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle:  TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: imageController,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      debugPrint('Something changed in image Text Field');
                      updateImage();
                    },
                    decoration: InputDecoration(
                        labelText: 'Image URL',
                        labelStyle:  TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.white,
                          textColor: Colors.black,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                              debugPrint("Save button clicked");
                              _save(context);
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
