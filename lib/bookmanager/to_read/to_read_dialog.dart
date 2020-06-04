
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/to_read.dart';

class ToReadDialog extends StatefulWidget {

  final ValueChanged<ToRead> onToReadAdd;
  final ToRead toRead;

  ToReadDialog({this.onToReadAdd, this.toRead = null});

  @override
  _ToReadDialogState createState() => _ToReadDialogState();
}

class _ToReadDialogState extends State<ToReadDialog> {

  final double _cornerRadius = 16.0;

  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _toReadFormKey = GlobalKey<FormState>();

  @override
  void initState() {

    if (widget.toRead != null) {
      _authorController.text = widget.toRead.author;
      _titleController.text = widget.toRead.title;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => _newToReadDialog();

  Widget _newToReadDialog() {
    return
      Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(_cornerRadius))
          ),
          child: Container(
              width: 200,
              height: 228,
              child: Column(
                children: <Widget>[
                  _createHeader(),
                  Form(
                      key: _toReadFormKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _buildInput("Author", _authorController),
                            _buildInput("Title", _titleController),
                          ])
                  ),
                  SizedBox(height: 12),
                  _createButtons()
                ],

              )
          ));
  }

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
                    _addToRead();
                    Navigator.pop(context);
                  }
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 89, 196, 188),
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
            child: Text("Add toRead",
                style: TextStyle(color: Colors.white, fontSize: 18))
        ),
      );

  void _addToRead() {
    int id = widget.toRead != null ? widget.toRead.id : null;
    ToRead toRead = ToRead(id, _authorController.text, _titleController.text);
    widget.onToReadAdd(toRead);
  }
}