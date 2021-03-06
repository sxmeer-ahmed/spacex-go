import 'package:bloc_test/bloc_test.dart';
import 'package:cherry/cubits/base/index.dart';
import 'package:cherry/cubits/index.dart';
import 'package:cherry/models/index.dart';
import 'package:cherry/repositories-cubit/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLaunchesRepository extends Mock implements LaunchesRepository {}

void main() {
  group('LaunchesCubit', () {
    LaunchesCubit cubit;
    MockLaunchesRepository repository;

    setUp(() {
      repository = MockLaunchesRepository();
      cubit = LaunchesCubit(repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('fails when null service is provided', () {
      expect(() => LaunchesCubit(null), throwsAssertionError);
    });

    test('initial state is RequestState.init()', () {
      expect(cubit.state, RequestState<List<Launch>>.init());
    });

    group('fetchData', () {
      blocTest<LaunchesCubit, RequestState>(
        'fetches data correctly',
        build: () {
          when(repository.fetchData()).thenAnswer(
            (_) => Future.value(const [Launch(id: '1')]),
          );
          return cubit;
        },
        act: (cubit) async => cubit.loadData(),
        verify: (_) => verify(repository.fetchData()).called(1),
        expect: [
          RequestState<List<Launch>>.loading(),
          RequestState<List<Launch>>.loaded(const [Launch(id: '1')]),
        ],
      );

      blocTest<LaunchesCubit, RequestState>(
        'can throw an exception',
        build: () {
          when(repository.fetchData()).thenThrow(Exception('wtf'));
          return cubit;
        },
        act: (cubit) async => cubit.loadData(),
        verify: (_) => verify(repository.fetchData()).called(1),
        expect: [
          RequestState<List<Launch>>.loading(),
          RequestState<List<Launch>>.error(Exception('wtf').toString()),
        ],
      );
    });
  });
}
