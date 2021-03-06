import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories-cubit/index.dart';
import 'index.dart';

/// Cubit that simplyfies state and repository management. It uses [RequestState]
/// as the main state, with the specific type [T].
/// The repository [R] is also used to download the data.
/// Events are emited from the [loadData] method, to signify the change of state
/// within the network request process.
///
/// Parameters:
/// - R: repository that extends [BaseRepository].
/// - T: model which represents the type of the state.
abstract class RequestCubit<R extends BaseRepository, T>
    extends Cubit<RequestState<T>> {
  final R repository;

  RequestCubit(this.repository)
      : assert(repository != null),
        super(RequestState.init());

  /// Overridable method that handles data load & applying models within
  /// the repository
  Future<void> loadData();
}
