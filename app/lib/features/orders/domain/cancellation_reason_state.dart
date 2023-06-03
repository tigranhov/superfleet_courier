import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cancellation_reason_state.g.dart';

@riverpod
class CancellationReasonState extends _$CancellationReasonState {
  @override
  ({List<String> reasons, int? selectedReaonsIndex}) build() {
    return (
      reasons: [
        'Reason 1',
        'Reason 2',
        'Reason 3',
        'Reason 4',
        'Reason 3',
      ],
      selectedReaonsIndex: null,
    );
  }

  void toggle(int index) {
    var selectedIndex = index == state.selectedReaonsIndex ? null : index;
    state = (selectedReaonsIndex: selectedIndex, reasons: state.reasons);
  }
}
