import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/orders/domain/cancellation_reason_state.dart';
import 'package:superfleet_courier/model/order/notifiers/order_notifiers.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/close_button.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/dividers/sf_horizontal_divider.dart';
import 'package:superfleet_courier/widgets/unfocuser.dart';

class CancelOrderView extends ConsumerWidget {
  const CancelOrderView({Key? key, required this.orderId}) : super(key: key);
  final int orderId;

  @override
  Widget build(BuildContext context, ref) {
    final order = ref.watch(orderByIdNotifierProvider(orderId)).value;
    if (order == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final cancellationState = ref.watch(cancellationReasonStateProvider);
    return Unfocuser(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Cancel Order #${order.id}'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          leading: SFCloseButton(
            onClosed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          titleTextStyle:
              context.text14w700.copyWith(height: 16 / 14, color: Colors.black),
          toolbarHeight: 48,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SFHorizontalDivider(),
                    const _WhyDidYouCancel(),
                    const SFHorizontalDivider(),
                    for (int i = 0; i < cancellationState.reasons.length; i++)
                      Column(
                        children: [
                          _CancellationReason(
                            key: ValueKey(i),
                            value: cancellationState.selectedReaonsIndex == i,
                            text: cancellationState.reasons[i],
                            onChanged: () {
                              ref
                                  .read(
                                      cancellationReasonStateProvider.notifier)
                                  .toggle(i);
                            },
                          ),
                          const SFHorizontalDivider(),
                        ],
                      ),
                    const _CustomReason(),
                  ],
                ),
              ),
            ),
            const SFHorizontalDivider(),
            Container(
              height: 73,
              alignment: Alignment.center,
              child: SFButton(
                text: 'Cancel Order',
                width: 304,
                onPressed: () {
                  SuccessPageRoute(
                          $extra:
                              'Order $orderId has been sucessfully completed!')
                      .go(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WhyDidYouCancel extends StatelessWidget {
  const _WhyDidYouCancel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      height: 96,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Why did you cancel the order?',
        maxLines: 2,
        textAlign: TextAlign.center,
        style: context.text16w700.copyWith(fontSize: 20),
      ),
    );
  }
}

class _CancellationReason extends StatelessWidget {
  const _CancellationReason({
    required super.key,
    required this.value,
    required this.text,
    required this.onChanged,
  });

  final bool value;
  final String text;
  final Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            Checkbox(
              //TODO figma specs
              value: value,
              onChanged: (_) => onChanged!.call(),
              fillColor: const MaterialStatePropertyAll<Color>(superfleetBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(text, style: context.text16)
          ],
        ),
      ),
    );
  }
}

class _CustomReason extends HookConsumerWidget {
  const _CustomReason({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final focusNode = useFocusNode();
    final hasFocusValue = useState(false);
    useEffect(() {
      focusNode.addListener(() {
        hasFocusValue.value = focusNode.hasFocus;
      });
      return null;
    });
    return Container(
      height: 106,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 40),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CUSTOM REASON', style: context.text12w700),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Why did you cancel the order?',
                hintStyle: context.text16
                    .copyWith(color: context.superfleetGreyOpacity),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: superfleetBlue,
                      width: 2,
                    )),
                fillColor:
                    focusNode.hasFocus ? Colors.white : const Color(0xFFF0F0F0),
                contentPadding: const EdgeInsets.all(16),
                filled: true,
              ),
              maxLines: 30,
            ),
          )
        ],
      ),
    );
  }
}
