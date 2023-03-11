class UserWithOrders {
  final String name;
  final String id;
  final String email;
  final String phone;
  final OrderDetail orderDetail;

  UserWithOrders({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.orderDetail
  });
}

class OrderDetail{
    final String Fuel;
    final String Liter;
    final String id;
    OrderDetail({
    required this.Fuel,
    required this.Liter,
    required this.id,
  });
}