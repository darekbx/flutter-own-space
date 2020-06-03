
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/book.dart';
import 'package:ownspace/tasks/bloc/task.dart';

class BookDialog extends StatefulWidget {

  final ValueChanged<Book> onBookAdd;
  final Book book;


  BookDialog({this.onBookAdd, this.book = null});

  @override
  _BookDialogState createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {

  final double _cornerRadius = 16.0;

  Map _checkboxStates = {
    "kindle": false,
    "good": false,
    "best": false,
    "inEnglish": false,
  };

  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _bookFormKey = GlobalKey<FormState>();

  @override
  void initState() {

    if (widget.book != null) {
      _authorController.text = widget.book.author;
      _titleController.text = widget.book.title;

      _checkboxStates['kindle'] = widget.book.isFromKindle();
      _checkboxStates['good'] = widget.book.isGood();
      _checkboxStates['best'] = widget.book.isBest();
      _checkboxStates['inEnglish'] = widget.book.isInEnglish();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => _newBookDialog();

  Widget _newBookDialog() {
    return
      Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(_cornerRadius))
          ),
          child: Container(
              width: 200,
              height: 300,
              child: Column(
                children: <Widget>[
                  _createHeader(),
                  Form(
                      key: _bookFormKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _buildInput("Author", _authorController),
                            _buildInput("Title", _titleController),
                            SizedBox(height: 8.0),
                            _buildOptions()
                          ])
                  ),
                  _createButtons()
                ],

              )
          ));
  }

  Widget _buildOptions() {
    return Row(
      children: <Widget>[

        Column(
          children: <Widget>[
            _createCheckBox("Kindle", "kindle"),
            _createCheckBox("Good", "good"),
          ],
        ),

        Column(
            children: <Widget>[
              _createCheckBox("Best", "best"),
              _createCheckBox("In English", "inEnglish"),
            ]),

      ],
    );
  }

  Widget _createCheckBox(String title, String valueKey) =>
      Container(
          width: 140,
          height: 38,
          child: InkWell(
              child: Row(children: <Widget>[
                Checkbox(value: _checkboxStates[valueKey], onChanged: (value) {
                  setState(() {
                    _checkboxStates[valueKey] = value;
                  });
                }),
                Text(title)
              ]),
              onTap: () {
                setState(() {
                  _checkboxStates[valueKey] = !_checkboxStates[valueKey];
                });
              }
          ));

  Widget _buildInput(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: Container(
          height: 44,
          child: TextFormField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 4),
                hintText: hint,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))
            ),
            controller: controller,
          )),
    );
  }

  Container _createButtons() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color.fromARGB(255, 237, 237, 229),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(_cornerRadius),
            bottomRight: Radius.circular(_cornerRadius)
        ),
      ),
      child: Row(children: <Widget>[
        SizedBox(width: 16.0),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 8.0, right: 4.0),
            child: Container(
                width: 120,
                height: 42,
                child: MaterialButton(
                  child: Icon(Icons.done, color: Colors.white),
                  onPressed: () {
                    _addBook();
                    Navigator.pop(context);
                  }
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 89, 196, 188),
                    //borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 68, 147, 142),
                            width: 7.0
                        )
                    )
                )
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 8.0, left: 4.0),
            child: Container(
                width: 120,
                height: 42,
                child: MaterialButton(
                  child: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 103, 102),
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 255, 77, 75),
                            width: 7.0
                        )
                    )
                )
            )
        ),
      ]),
    );
  }

  Container _createHeader() =>
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_cornerRadius),
              topRight: Radius.circular(_cornerRadius)
          ),
        ),
        child: Center(
            child: Text("Add book",
                style: TextStyle(color: Colors.white, fontSize: 18))
        ),
      );

  void _addBook() {
    int id = widget.book != null ?widget.book.id : null;
    String flags = Book.createFlags(
        kindle: _checkboxStates['kindle'],
        good: _checkboxStates['good'],
        best: _checkboxStates['best'],
        inEnglish: _checkboxStates['inEnglish']
    );
    int year = DateTime.now().year;
    Book book = Book(id, _authorController.text, _titleController.text, flags, year);

    widget.onBookAdd(book);
  }
}