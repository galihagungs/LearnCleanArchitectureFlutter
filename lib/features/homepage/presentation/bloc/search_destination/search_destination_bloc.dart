import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/usecase/get_search_destination_usecase.dart';

part 'search_destination_event.dart';
part 'search_destination_state.dart';

class SearchDestinationBloc
    extends Bloc<SearchDestinationEvent, SearchDestinationState> {
  final GetSearchDestinationUsecase _usecase;
  SearchDestinationBloc(this._usecase) : super(SearchDestinationInitial()) {
    on<OnSearchDestination>((event, emit) async {
      emit(SearchDestinationLoading());
      final result = await _usecase.call(event.query);
      result.fold(
        (failure) => emit(SearchDestinationFailure(failure.message)),
        (data) => emit(SearchDestinationLoaded(data)),
      );
    });
  }
}
