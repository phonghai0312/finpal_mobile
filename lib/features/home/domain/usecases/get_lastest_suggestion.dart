import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/suggestions.dart';
import '../repositories/home_repository.dart';

class GetLatestSuggestionUseCase {
  final HomeRepository repository;
  GetLatestSuggestionUseCase(this.repository);

  Future<Suggestions?> call() {
    return repository.getLatestSuggestion();
  }
}
