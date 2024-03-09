import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list/data/repo/repository.dart';

import '../../../data/data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Repository<Task> repository;

  HomeBloc(this.repository) : super(HomeStateInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeEventStarted || event is HomeEventSerarch) {
        final String searchTerm;
        emit(HomeStateLoading());
       

        if (event is HomeEventSerarch) {
          searchTerm = event.serarchTerm;
        } else {
          searchTerm = '';
        }
        try {
          final items = await repository.getAll(searchKeyword: searchTerm);

          if (items.isNotEmpty) {
            emit(HomeStateSuccess(items));
          } else {
            emit(HomeStateEmpty());
          }
        } catch (e) {
          emit(HomeStateError('خطای نا مشخص'));
        }
      } else if (event is HomeEventDeletAll) {
        await repository.deleteAll();
        emit(HomeStateEmpty());
      }else if (event is HomeEventDelet){
          
        await repository.delete(event.task);
        emit(HomeStateEmpty());
      }
    });
  }
}
