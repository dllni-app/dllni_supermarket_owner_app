import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryState()) {
    on<InventoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
