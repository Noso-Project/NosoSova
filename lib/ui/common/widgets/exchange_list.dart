import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/ui/common/widgets/empty_list_widget.dart';

import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/rest_api/exhcange_data.dart';
import '../../../repositories/network_repository.dart';
import '../../theme/style/icons_style.dart';
import '../../theme/style/text_style.dart';

class ExchangeList extends StatefulWidget {
  const ExchangeList({Key? key}) : super(key: key);

  @override
  State createState() => _ExchangeListState();
}

class _ExchangeListState extends State<ExchangeList> {
  Future<List<CoinData>> _fetchExchangeList() async {
    final restApi = locator<NetworkRepository>();
    var response = await restApi.fetchExchangeList();
    if (response.errors == null) {
      List<CoinData> list = response.value;

      return list.isEmpty
          ? throw Exception('Failed to load exchanges list')
          : list;
    } else {
      throw Exception('Failed to load exchanges list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CoinData>>(
        future: _fetchExchangeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Theme.of(context).colorScheme.primary,
                  size: 80,
                )));
          } else if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: EmptyWidget(
                  title: AppLocalizations.of(context)!.errorLoading,
                  descrpt:
                      "Our api is not available for maintenance. \n Please try again later",
                ));
          } else {
            var listData = snapshot.data ?? [];
            listData.sort((a, b) => b.price.compareTo(a.price));
            return ListView.builder(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final item = listData[index];
                return ListTile(
                    leading: AppIconsStyle.icon3x2(Assets.iconsExchange),
                    title: Text(
                      item.getName(),
                      style: AppTextStyles.walletHash,
                    ),
                    trailing: Text(
                      "${item.price.toStringAsFixed(5)}\$",
                      style: AppTextStyles.walletHash.copyWith(fontSize: 16),
                    ),
                    subtitle: Text(
                      "Volume 24hr: ${item.volume24h.toString()}\$",
                      style: AppTextStyles.infoItemTitle.copyWith(fontSize: 14),
                    ));
              },
            );
          }
        });
  }
}
