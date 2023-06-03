enum OrderStatus {
  open,
  inProcess,
  delivered,
  cancelled;

  @override
  String toString() => switch (this) {
        open => 'OPEN',
        inProcess => 'IN_PROCESS',
        delivered => 'DELIVERED',
        cancelled => 'CANCELLED',
      };
}
