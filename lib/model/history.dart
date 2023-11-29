
class History {
    String? id;
    String? idUser;
    String? type;
    String? date;
    String? total;
    String? details;
    String? createdAt;
    String? updatedAt;

    History({
        this.id,
        this.idUser,
        this.type,
        this.date,
        this.total,
        this.details,
        this.createdAt,
        this.updatedAt,
    });

    factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        idUser: json["id_user"],
        type: json["type"],
        date: json["date"],
        total: json["total"],
        details: json["details"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "type": type,
        "date": date,
        "total": total,
        "details": details,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}