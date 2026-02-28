part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeLoadEvent extends HomeEvent {
  final int storeId;
  HomeLoadEvent({required this.storeId});
}

class HomeRefreshEvent extends HomeEvent {
  final int storeId;
  HomeRefreshEvent({required this.storeId});
}

class HomeAcceptOrderEvent extends HomeEvent {
  final int orderId;
  HomeAcceptOrderEvent({required this.orderId});
}

class HomeRejectOrderEvent extends HomeEvent {
  final int orderId;
  final String reason;
  final String rejectionType;
  HomeRejectOrderEvent({
    required this.orderId,
    required this.reason,
    required this.rejectionType,
  });
}
