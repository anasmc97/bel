class Jadwal {
  int _id;
  String _hari;
  String _jam;
  String _bunyi;

  // konstruktor versi 1
  Jadwal(this._hari, this._jam, this._bunyi);

  // konstruktor versi 2: konversi dari Map ke Jadwal
  Jadwal.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._hari = map['hari'];
    this._jam = map['jam'];
    this._bunyi = map['bunyi'];
  }
  //getter dan setter (mengambil dan mengisi data kedalam object)
  // getter
  int get id => _id;
  String get hari => _hari;
  String get jam => _jam;
  String get bunyi => _bunyi;

  // setter  
  set hari(String value) {
    _hari = value;
  }

  set jam(String value) {
    _jam = value;
  }

  set bunyi(String value){
    _bunyi = value;
  }

  // konversi dari Jadwal ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['hari'] = hari;
    map['jam'] = jam;
    map['bunyi'] = bunyi;
    return map;
  }  

}