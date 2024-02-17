import 'package:cloud_firestore/cloud_firestore.dart';
class diseaseDatabaseService {
  final String? uid;
  diseaseDatabaseService({this.uid});

  //collection reference
  final CollectionReference diseaseCollection = FirebaseFirestore.instance.collection('KidneyDiseases');

  Future createKidneyDiseaseData(String name, String icon, double maxProteinLimit, double maxWaterLimit) async {
    return await diseaseCollection.doc(uid).set({
      'name': name,
      'icon': icon,
      'maxProteinLimit': maxProteinLimit,
      'maxWaterLimit': maxWaterLimit,

    });
  }
Future deleteKidneyDiseaseData() async {
    return await diseaseCollection.doc(uid).delete();
  }
  //get user doc stream
  Stream<DocumentSnapshot> get diseaseDoc {
    return diseaseCollection.doc(uid).snapshots();
  }

}