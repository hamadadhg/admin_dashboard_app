import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/features/category_products/presentation/manager/bloc/category_products_bloc.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/use_cases/generate_cards_use_case.dart';
import 'package:flutter_admin_dashboard/features/wallet/presentation/manager/bloc/wallet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateCardsDialog extends StatelessWidget {
  GenerateCardsDialog({super.key, required this.bloc});

  final WalletBloc bloc;

  final TextEditingController countController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Count',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            BlocConsumer<WalletBloc, WalletState>(
                bloc: bloc,
                listener: (context, state) {
                  if (state.generateCardsStatus == BLocStatus.success) {
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      bloc.add(GenerateCardsEvent(params: WalletParams(count: countController.text, amount: amountController.text)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purpleAccent,
                      ),
                      padding: const EdgeInsetsDirectional.all(20),
                      child: state.generateCardsStatus == BLocStatus.loading
                          ? const Center(child: CircularProgressIndicator.adaptive())
                          : const Center(
                              child: Text(
                                'Generate Cards',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
