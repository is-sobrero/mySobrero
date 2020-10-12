import 'package:flutter/material.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/snacks/snack_history_model.dart';
import 'package:mySobrero/tiles/date_time_tile.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SnacksHistoryView extends StatefulWidget {
  @override
  _SnacksHistoryState createState() => _SnacksHistoryState();
}

class _SnacksHistoryState extends State<SnacksHistoryView>{
  Future<OrderHistory> _orderHistory;

  @override
  void initState(){
    super.initState();
    _orderHistory = CloudConnector.getSnacksHistory(
      token: reAPI4.instance.getSession(),
    );
  }

  Widget _displayOrder(SnackBit a) {
    return DateTimeTile(
      title: a.snack,
      dateFormat: "yyyy-MM-dd HH:mm:ss",
      date: a.timestamp,
      margin: EdgeInsets.zero,
      showHour: true,
      children: [
        Text(
          Utilities.formatArgumentString(
            AppLocalizations.of(context).translate("SNACKS_ORDER_IDENTIFIER"),
            args: [
              a.id.toString(),
            ]
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return SobreroDetailView(
      title: AppLocalizations.of(context).translate("SNACKS_ORDER_HISTORY"),
      child: FutureBuilder<OrderHistory>(
        future: _orderHistory,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return SobreroLoading(
                loadingStringKey: "SNACKS_LOADING_HISTORY",
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return SobreroError(
                  snapshotError: snapshot.error,
                );
              if (snapshot.data.data.delivered.isEmpty
              & snapshot.data.data.notDelivered.isEmpty)
                return SobreroEmptyState(
                  emptyStateKey: "SNACKS_NO_HISTORY",
                );
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (snapshot.data.data.notDelivered.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 15),
                        child: Text(
                          AppLocalizations.of(context).translate(
                            'SNACKS_NOT_DELIVERED',
                          ),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    if (snapshot.data.data.notDelivered.length > 0)
                      WaterfallFlow.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.data.notDelivered.length,
                        itemBuilder: (_, i) => _displayOrder(
                          snapshot.data.data.notDelivered[i],
                        ),
                        gridDelegate: SliverWaterfallFlowDelegate(
                          crossAxisCount: UIHelper.columnCount(context),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          lastChildLayoutTypeBuilder: (i) =>
                          i == snapshot.data.data.notDelivered.length
                              ? LastChildLayoutType.foot
                              : LastChildLayoutType.none,
                        ),
                      ),
                    if (snapshot.data.data.delivered.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          AppLocalizations.of(context).translate(
                            'SNACKS_DELIVERED',
                          ),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    if (snapshot.data.data.delivered.length > 0)
                      WaterfallFlow.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.data.delivered.length,
                        itemBuilder: (_, i) => _displayOrder(
                          snapshot.data.data.delivered[i],
                        ),
                        gridDelegate: SliverWaterfallFlowDelegate(
                          crossAxisCount: UIHelper.columnCount(context),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          lastChildLayoutTypeBuilder: (i) =>
                          i == snapshot.data.data.delivered.length
                              ? LastChildLayoutType.foot
                              : LastChildLayoutType.none,
                        ),
                      ),
                  ]
              );
          }
          return null;
        },
      ),
    );
  }
}