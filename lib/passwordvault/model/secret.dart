class Secret {
  String account;
  String password;

  Secret({this.account, this.password});

  Map<String, dynamic> toJson() => {
    'account': account, 
    'password': password
  };

  Secret.fromJson(Map<String, dynamic> json)
      : account = json['account'],
        password = json['password'];
}
