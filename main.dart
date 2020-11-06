import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

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

void main() async {
  for (int z = 0; z < 10; z++) {
    var inicio = new DateTime.now();

    int tamanhoGrafo = 1000000; //Tamanho do grafo

    Grafo grf = new Grafo(tamanhoGrafo);

    grf.adicionaArestasAleatorias();

    // insere as arestas
    //grf.addArest(0, 1);
    //grf.addArest(0, 2);
    //grf.addArest(1, 3);
    //grf.addArest(1, 4);
    //grf.addArest(2, 5);
    //grf.addArest(2, 6);
    //grf.addArest(6, 7);
    //grf.addArest(7, 10);
    //grf.addArest(10, 9);
    //grf.addArest(9, 15);
    //grf.addArest(15, 90);

    //executa o algoritmo DFS
    grf.dfs(0);

    var now = new DateTime.now();
    var tempo = now.difference(inicio);

    var tot = format(tempo);

    print("Tempo de execução: $tot");

    print("------------------------------------------------------------------");
  }
}

class Vertice {
  int valor;
  String conteudo;

  Vertice(this.valor, this.conteudo);
}

class Grafo {
  int lenght;
  bool achei = false;

  List<List<Vertice>> adj = new List<List<Vertice>>();

  Grafo(int tamanhoGrafo) {
    this.lenght = tamanhoGrafo;
    adj = List<List<Vertice>>(lenght);
  }

  void adicionaArestasAleatorias() {
    List<int> repetidosR1 = new List<int>();
    Random random = new Random();

    for (int i = 0; i < this.lenght; i++) {
      int r1 = random.nextInt(this.lenght);
      int v1;
      int v2;

      if (repetidosR1.contains(r1)) {
        i--;
      } else {
        v1 = r1;
      }

      v2 = random.nextInt(this.lenght);
      //List<int> randoms = await getRandomNumbersLegit(tamanhoGrafo - 1);
      //print("Ind  "+ randoms[0].toString() + " " + randoms[1].toString());
      //grf.addArest(randoms[0], randoms[1]);

      //print("Ind  "+ v1.toString() + " " + v2.toString());

      if(this.adj[v1] != null){
        if (this.adj[v1].length >= 10) {
          i--;
        }else{
          this.addArest(v1, v2);
        }
      }else{
        this.addArest(v1, v2);
      }

    }
  }

  void addArest(int val1, int val2) {
    List<Vertice> aux = this.adj[val1] ?? new List<Vertice>();

    if (this.achei == false) {
      this.achei = true;
      aux.add(new Vertice(val2, "ACHEI"));
    } else {
      aux.add(new Vertice(val2, "Unicesumar"));
    }

    this.adj[val1] = aux;
  }

  void dfs(int v) {
    List<int> pilha = new List<int>();

    List<bool> visitados = new List<bool>(this.lenght);

    for (int i = 0; i < this.lenght; i++) {
      visitados[i] = false;
    }

    while (true) {
      if (!visitados[v]) {
        print("procurando arestas em $v \n");
        visitados[v] = true;
        pilha.add(v);
        print(pilha);
      }

      bool encontrou = false;
      Vertice it;
      int itValor;
      String itConteudo;

      if (adj[v] != null) {
        for (it in adj[v]) {
          if (!visitados[it.valor]) {
            encontrou = true;
            itValor = it.valor;
            itConteudo = it.conteudo;
            break;
          }
        }
      }

      if (encontrou) {
        if (itConteudo == "ACHEI") {
          print('Achei!');
          break;
        }
        v = itValor;
      } else {
        pilha.removeLast();

        if (pilha.isEmpty) {
          break;
        }

        v = pilha[pilha.length - 1];
      }
    }

    print('Fim!');
  }
}
