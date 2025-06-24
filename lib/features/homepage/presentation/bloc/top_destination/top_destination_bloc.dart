import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/usecase/get_top_destination_usecase.dart';

part 'top_destination_event.dart';
part 'top_destination_state.dart';

class TopDestinationBloc
    extends Bloc<TopDestinationEvent, TopDestinationState> {
  final GetTopDestinationUsecase _usecase;
  TopDestinationBloc(this._usecase) : super(TopDestinationInitial()) {
    on<OnGetTopDestination>((event, emit) async {
      emit(TopDestinationLoading());
      final result = await _usecase.call();
      result.fold(
        (failure) => emit(TopDestinationFailure(failure.message)),
        (data) => emit(TopDestinationLoaded(data)),
      );
    });
  }
}
