
class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title,this._date,this._priority,[this._description]);
  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id => _id;
  String get title => _title;
  String get date => _date;
  int get priority => _priority;
  String get description => _description;

  set title(String newTitle){
    if(newTitle.length <= 255){
      this.title = newTitle;
    }
  }

  set date(String newDate){
      this.date = newDate;
  }

  set description(String newDescription){
    if(newDescription.length <= 255){
      this.description = newDescription;
    }
  }

  set id(int newId){
      this.id = newId;
  }

  set priority(int newPriority){
    if(newPriority >= 1 && newPriority <= 2)
    {
      this.priority = newPriority;
    }
  }

  // Used to store and retrieve data from database

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._date = map['date'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._title = map['title'];
  }
  }