import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ownspace/notepad/bloc/notes.dart';
import 'package:ownspace/notepad/model/note.dart';
import 'package:ownspace/notepad/notepainter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class NotepadPage extends StatefulWidget {

  NotepadPage({Key key}) : super(key: key);

  @override
  _NotepadPageState createState() => _NotepadPageState();
}

class NoFadeBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _NotepadPageState extends State<NotepadPage> with WidgetsBindingObserver {

  NoteBloc _noteBloc;
  int _maxNoteIndex = -1;

  Map<int, TextEditingController> _controllers = Map();

  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _saveNotes();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _noteBloc = NoteBloc();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _saveNotes() {
    _controllers.forEach((index, controller) {
      _noteBloc.add(UpdateNote(index, controller.text));
    });
  }

  void addNote() async {
    _noteBloc.add(AddNote(Note(null, "Empty", _maxNoteIndex + 1)));
  }

  void _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void dispose() {
    _saveNotes();
    _scrollController.removeListener(_scrollListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _noteBloc,
      child: buildContainer(),
    );
  }

  Container buildContainer() {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state is Loading) {
                return showStatus("Loading...");
              } else if (state is InitialNoteState) {
                _noteBloc.add(FetchNotes());
                return showStatus("Loading...q");
              } else if (state is Finished) {
                return showStatus("Finished?");
              } else if (state is Error) {
                return showStatus("Error, while loading notes: ${state.message}");
              } else if (state is NotesLoaded) {
                if (state.notes.isEmpty) {
                  return showStatus("No notes present, please add.");
                } else {

                  _obtainControllers(state);
                  _obtainMaxIndex(state);

                  return showNoteTabs(state);
                }
              }
            },
          ),
        )
    );
  }

  void _obtainControllers(NotesLoaded state) {
    _controllers.clear();
    state.notes.forEach((note) {
      var controller = TextEditingController()
        ..text = note.contents;
      _controllers[note.index] = controller;
    });
  }

  void _obtainMaxIndex(NotesLoaded state) {
    _maxNoteIndex = state.notes
        .map((note) => note.index)
        .reduce(max);
  }

  Widget showStatus(String status) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => addNote(),
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Text(
              status, style: TextStyle(color: Colors.black87, fontSize: 14)),
        )
    );
  }

  DefaultTabController showNoteTabs(NotesLoaded state) {
    return DefaultTabController(
      length: state.notes.length,
      child: Scaffold(
        backgroundColor: Colors.green,
        floatingActionButton: FloatingActionButton(
          onPressed: () => addNote(),
          child: Icon(Icons.add),
        ),
        appBar: TabBar(
          indicatorColor: Colors.black38,
          labelStyle: TextStyle(color: Colors.white),
          isScrollable: false,
          tabs: state.notes.map((Note note) => Tab(text: "${note.index + 1}")).toList(),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: state.notes.map((Note note) {
              return createCard(note);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget createCard(Note note) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ScrollConfiguration(
                behavior: NoFadeBehavior(),
                  child: CustomPaint(
                      painter: NotePainter(_scrollPosition),
                      child: TextField(
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                          scrollController: _scrollController,
                          keyboardType: TextInputType.multiline,
                          expands: true,
                          maxLines: null,

                          controller: _controllers[note.index],

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          )
                      ))
              )
          ),
        )
    );
  }
}