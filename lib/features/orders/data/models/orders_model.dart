OrdersModel ordersModelFromJson(str) => OrdersModel.fromJson(str);

class OrdersModel {
  List<Order>? orders;
  Order? order;

  OrdersModel({this.orders, this.order});

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        orders: json['orders'] == null ? [] : List<Order>.from(json['orders']!.map((x) => Order.fromJson(x))),
        order: json['order'] == null ? null : Order.fromJson(json['order']),
      );
}

class Order {
  int? id;
  String? username;
  String? price;
  String? orderType;
  User? user;

  Order({this.id, this.username, this.price, this.orderType, this.user});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        username: json['username'],
        price: json['total_price'],
        orderType: json['order_type'],
        user: json['user'] == null ? null : User.fromJson(json['user']),
      );
}

class User {
  String? username;
  String? phone;

  User({this.username, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        phone: json['mobile'],
      );
}
