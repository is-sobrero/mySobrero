import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/toggle.dart';

class CompitiView extends StatefulWidget {
  List<CompitoStructure> compiti;
  List<CompitoStructure> settimana;

  CompitiView({Key key, @required this.compiti, @required this.settimana}) {}

  @override
  _CompitiState createState() => _CompitiState();
}

class _CompitiState extends State<CompitiView> {
  Map<int, Widget> _children = const <int, Widget> {
    0: Text('Settimana', style: TextStyle(color: Colors.black)),
    1: Text('Tutti i compiti', style: TextStyle(color: Colors.black)),
  };

  int selezioneCompiti = 0;



  @override
  Widget build(BuildContext context) {
    List<CompitoStructure> _selectedAssignments = selezioneCompiti == 0 ? widget.settimana : widget.compiti;
    return SobreroDetailView(
      title: "Compiti",
      child: Column(
        children: [
          SobreroToggle(
            values: ["Settimana", "Tutti"],
            onToggleCallback: (val) => setState(() => selezioneCompiti = val),
            selectedItem: selezioneCompiti,
            width: 200,
            margin: EdgeInsets.only(bottom: 20, top: 10),
          ),
          PageTransitionSwitcher2(
            reverse: selezioneCompiti == 0,
            layoutBuilder: (_entries) => Stack(
              children: _entries
                  .map<Widget>((entry) => entry.transition)
                  .toList(),
              alignment: Alignment.topLeft,
            ),
            duration: Duration(milliseconds: UIHelper.pageAnimDuration),
            transitionBuilder: (c, p, s) => SharedAxisTransition(
              fillColor: Colors.transparent,
              animation: p,
              secondaryAnimation: s,
              transitionType: SharedAxisTransitionType.horizontal,
              child: c,
            ),
            child: Container(
              key: ValueKey<int>(selezioneCompiti),
              child: _selectedAssignments.length > 0 ? ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _selectedAssignments.length,
                itemBuilder: (_, i) {
                  return SobreroFlatTile(
                    margin: EdgeInsets.only(bottom: 15),
                    children: [
                      Text(_selectedAssignments[i].materia,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.black)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Text("Data: " + _selectedAssignments[i].data.split(" ")[0],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black)),
                      ),
                      Text(_selectedAssignments[i].compito,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black)),
                    ],
                  );
                },
              ) : SobreroEmptyState(
                emptyStateKey: "noAssignments",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
