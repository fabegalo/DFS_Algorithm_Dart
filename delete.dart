Future<List<int>> getRandomNumbersLegit(int qtd) async {
  // produces a request object
  // sends the request
  final response = await http.post(
      'https://www.random.org/sequences/?min=0&max=$qtd&col=1&format=plain&rnd=new',
      headers: {
        "content-type": 'text/plain;charset=UTF-8',
        "accept-charset": "UTF-8"
      });

  //print(response.body);

  return await convertParaListaInteiro(response.body);
}

Future<List<int>> convertParaListaInteiro(responseData) async {
  var teste = responseData.trim();

  var t = jsonEncode(teste);

  var gg = t.replaceAll('n', '');

  var g2 = gg.replaceAll(new RegExp(r'[^0-9]'), ',');

  var fim = g2.split(",");

  //print('a: $fim');
  List<int> aa = new List<int>();

  for (var t in fim) {
    var aux = int.tryParse(t);

    if (aux != null) {
      aa.add(aux);
    }
  }

  return aa;
}

String format(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days}d');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours}h');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes}m');
  }
  tokens.add('${seconds}s');

  return tokens.join(':');
}