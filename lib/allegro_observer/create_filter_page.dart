import 'package:flutter/material.dart';
import 'package:ownspace/allegro_observer/category_choose_page.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/allegro/model/category.dart';

class CreateFilterPage extends StatefulWidget {
  CreateFilterPage({Key key}) : super(key: key);

  @override
  _CreateFilterPageState createState() => _CreateFilterPageState();
}

class _CreateFilterPageState extends State<CreateFilterPage> {

  final keywordTextController = TextEditingController();
  final categoryTextController = TextEditingController();
  final priceFromController = TextEditingController();
  final priceToController = TextEditingController();
  bool _inDescriptionState = false;
  bool _isUsedState = true;
  bool _isNewState = true;

  Category _selectedCategory = null;
  String _chooseCategoryLabel = "Choose category";

  BuildContext _scaffoldContext;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new filter'),
      ),
      body: Builder(
          builder: (BuildContext context) {
            _scaffoldContext = context;
            return _body(context);
          }
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child:
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _createKeywordInput(),
            _createPriceInput(),
            _createIsUsedCheckbox(),
            _createInDescriptionCheckbox(),
            _createCategoriesButton(),
            Expanded(child: Container()),
            _createSaveButton(context)
          ],
        ),
      ),
    );
  }

  Widget _applyInputStyle(Widget input,
      {double radius = 8.0, double borderRadius = 4.0}) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [new BoxShadow(
            color: Color.fromARGB(70, 0, 0, 0),
            blurRadius: 2.0,
          )
          ],
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))
      ),
      child: Padding(
          padding: EdgeInsets.all(radius),
          child: input
      ),
    );
  }

  Widget _createKeywordInput() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: _applyInputStyle(
            TextFormField(
              controller: keywordTextController,
              validator: (value) {
                if (value.length > 100) {
                  return "Keyword is too long";
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: "Keyword",
              ),
            )
        ));
  }

  Widget _createPriceInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
            child:
            Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
                child: _applyInputStyle(
                    TextFormField(
                      controller: priceFromController,
                      validator: (value) {
                        double price = double.tryParse(value);
                        if (price != null && price < 0) {
                          return "Value is invalid";
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                          hintText: "Price from"
                      ),
                    )
                )
            )
        ),

        Flexible(
            child:
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: _applyInputStyle(
                    TextFormField(
                      controller: priceToController,
                      validator: (value) {
                        double priceTo = double.tryParse(value);
                        double priceFrom = double.tryParse(
                            priceFromController.text);
                        if (priceTo != null) {
                          if (priceTo < 0) {
                            return "Value is invalid";
                          } else if (priceFrom != null && priceFrom > priceTo) {
                            return "Price to is to small";
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                          hintText: "Price to"
                      ),)
                )
            )
        )

      ],
    );
  }

  Widget _createIsUsedCheckbox() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isUsedState,
                      onChanged: (value) {
                        setState(() {
                          _isUsedState = value;
                        });
                      },
                    ), Text("Search for used")
                  ]
              )
          ),

          Flexible(
              child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isNewState,
                      onChanged: (value) {
                        setState(() {
                          _isNewState = value;
                        });
                      },
                    ), Text("Search for new")
                  ]
              )
          ),

          Container(
            padding: EdgeInsets.all(16.0),
          )
        ]);
  }

  Widget _createInDescriptionCheckbox() {
    return Row(
        children: <Widget>[
          Checkbox(
            value: _inDescriptionState,
            onChanged: (value) {
              setState(() {
                _inDescriptionState = value;
              });
            },
          ), Text("Search in description")
        ]
    );
  }

  Widget _createCategoriesButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child:
              Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: RaisedButton(
                    child: Text(
                        _chooseCategoryLabel,
                        style: TextStyle(color: Colors.white)),
                    color: Colors.orange,
                    onPressed: () {
                      _openCategoriesPage(context);
                    },
                  )
              )
          )
        ]);
  }

  Widget _createSaveButton(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: RaisedButton(
                    child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white)),
                    color: Colors.green,
                    onPressed: () {
                      _saveFilter(context);
                    },
                  )
              )
          )
        ]);
  }

  void _openCategoriesPage(BuildContext context) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryChoosePage()));
    if (result is Category) {
      _selectedCategory = result;
      setState(() {
        _chooseCategoryLabel = "Category: " + result.name;
      });
    }
  }

  void _saveFilter(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (_selectedCategory == null) {
        _showMessage("Please select category");
        return;
      }
      var filter = Filter(
          keyword: keywordTextController.text,
          priceFrom: double.tryParse(priceFromController.text),
          priceTo: double.tryParse(priceToController.text),
          searchInDescription: _inDescriptionState,
          searchUsed: _isUsedState,
          searchNew: _isNewState,
          category: _selectedCategory);

      Navigator.pop(context, filter);
    }
  }

  void _showMessage(String message) {
    Scaffold.of(_scaffoldContext).showSnackBar(
        SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    keywordTextController.dispose();
    super.dispose();
  }
}