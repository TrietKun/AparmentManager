import 'package:apartment_manager_user/models/aparment.dart';
import 'package:apartment_manager_user/services/api_aparment.dart';

class Aparmentcontroller {
  final ApiAparment apiAparment = ApiAparment();
  late Aparment aparment;

  void getAparmentById(String id) async {
    try {
      aparment = await apiAparment.getAparmentById(id);
      print(aparment);
    } catch (e) {
      print(e);
    }
  }

  void create() {
    print('Create Aparment');
  }

  void read() {
    print('Read Aparment');
  }

  void update() {
    print('Update Aparment');
  }

  void delete() {
    print('Delete Aparment');
  }
}