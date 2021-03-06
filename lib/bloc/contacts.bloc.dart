import 'package:desafio_picpay_mobile/models/contact.model.dart';
import 'package:desafio_picpay_mobile/services/contacts.service.dart';
import 'package:rxdart/rxdart.dart';

class ContactsBloc {
  final ContactsService _service = ContactsService();

  BehaviorSubject<List<Contact>> _contacts = BehaviorSubject<List<Contact>>();
  BehaviorSubject<List<Contact>> _filteredContacts = BehaviorSubject<List<Contact>>();
  BehaviorSubject<Contact> _selectedContact = BehaviorSubject<Contact>();

  Stream<List<Contact>> get contacts => _contacts.stream;
  Stream<List<Contact>> get filteredContacts => _filteredContacts.stream;
  Contact get selectedContact => _selectedContact.stream.value;

  Function(Contact) get select => _selectedContact.sink.add;

  Future getAllContacts() async {
    _contacts.add(await _service.getAllContacts());
    _filteredContacts.add(await _service.getAllContacts());
  }

  void filterContacts(String query) {
    List<Contact> dummySearchList = _filteredContacts.value;
    if(query.isNotEmpty) {
      List<Contact> dummyListData = List<Contact>();
      dummySearchList.forEach((item) {
        if(item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      _filteredContacts.sink.add(dummyListData);
      return;
    } else {
      _filteredContacts.sink.add(_contacts.value);
    }
  }

  void dispose() {
    _contacts.close();
    _filteredContacts.close();
    _selectedContact.close();
  }
}