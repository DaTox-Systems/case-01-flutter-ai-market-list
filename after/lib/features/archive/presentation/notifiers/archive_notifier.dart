import 'package:flutter/foundation.dart';
import '../../domain/entities/archived_list_entity.dart';
import '../../domain/repositories/i_archive_repository.dart';
import '../../../../core/utils/ui_message.dart';

class ArchiveNotifier extends ChangeNotifier {
  final IArchiveRepository _repository;

  ArchiveNotifier({required IArchiveRepository repository}) : _repository = repository {
    loadArchivedLists();
  }

  List<ArchivedListEntity> _archivedLists = [];
  bool _isLoading = false;
  bool _sortOldestFirst = false;
  UiMessage? _message;

  List<ArchivedListEntity> get archivedLists => List.unmodifiable(_archivedLists);
  bool get isLoading => _isLoading;
  bool get sortOldestFirst => _sortOldestFirst;
  UiMessage? get message => _message;

  void toggleSortOrder() {
    _sortOldestFirst = !_sortOldestFirst;
    _sortLists();
    notifyListeners();
  }

  void _sortLists() {
    _archivedLists.sort((a, b) {
      return _sortOldestFirst ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
    });
  }

  Future<void> loadArchivedLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _archivedLists = await _repository.getArchivedLists();
      _sortLists();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка архива', description: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteArchivedList(int id, String name) async {
    try {
      await _repository.deleteArchivedList(id);
      _archivedLists.removeWhere((item) => item.id == id);
      _message = UiMessage.info(title: 'Архив удален', description: '$name удален.');
      notifyListeners();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка удаления', description: e.toString());
      notifyListeners();
    }
  }

  void clearMessage() {
    _message = null;
  }
}
