import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/di/injection.dart';
import 'package:flutter_admin_dashboard/features/wallet/presentation/widgets/generate_cards_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../category_products/presentation/manager/bloc/category_products_bloc.dart';
import '../manager/bloc/wallet_bloc.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'مستخدمة',
      'غير مستخدمة',
    ];

    return BlocProvider<WalletBloc>(
      create: (context) => getIt<WalletBloc>()..add(FetchCardsEvent(isUsed: true)),
      child: Scaffold(
        floatingActionButton: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => GenerateCardsDialog(bloc: context.read<WalletBloc>()));
              },
              backgroundColor: Colors.purpleAccent,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          },
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  return Row(
                    spacing: 20,
                    children: List.generate(
                        2,
                        (i) => Expanded(
                              child: InkWell(
                                onTap: () {
                                  context.read<WalletBloc>().add(FetchCardsEvent(isUsed: i == 0));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.purpleAccent),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      titles[i],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  );
                },
              ),
            ),
            Expanded(child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                switch (state.fetchCardsStatus) {
                  case null:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case BLocStatus.init:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case BLocStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case BLocStatus.success:
                    if (state.fetchCards!.vouchers!.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد بطاقات'),
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.fetchCards!.vouchers![index].code!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      state.fetchCards!.vouchers![index].amount!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      itemCount: state.fetchCards!.vouchers!.length,
                    );
                  case BLocStatus.error:
                    return Center(
                      child: Text(state.errorMessage!),
                    );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
