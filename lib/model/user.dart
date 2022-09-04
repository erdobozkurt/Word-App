class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  User(
      {required this.uid,
      required this.email,
      this.displayName,
      this.photoURL});

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': displayName,
        'profileImage': photoURL,
        'uid': uid,
      };
}
