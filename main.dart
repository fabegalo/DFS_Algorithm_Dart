import 'lib/mersenne.dart';

//Classe para gerar a lista de achados
class Achados {
  int vertice;
  Duration tempo;
  String tipo;

  Achados(this.vertice, this.tempo, this.tipo);
}

//função inicial
void main() async {
  //lista de achados
  List<Achados> achados = new List<Achados>();

  //executa e cria 10 grafos
  for (int z = 0; z < 10; z++) {
    int tamanhoGrafo = 1000000; //Tamanho do grafo

    Grafo grf = new Grafo(tamanhoGrafo); // Instancia o grafo

    await grf.adicionaArestasAleatorias(); //adiciona Arestas Aleatorias com Mersenne Twister

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

    await grf.addAchei(); // adiciona a palavara "ACHEI" em um vertice aleatorio com Mersenne Twister

    //executa o algoritmo DFS
    print('----------------Executa DFS-------------'); // começa o DFS

    var inicioDfs = new DateTime.now(); //pega o tempo de inicio DFS
    await grf.dfs(0); //EXECUTA O DFS
    var now = new DateTime.now(); // PEGA o tempo atual
    var tempoDfs = now.difference(inicioDfs); // pega a diferença

    //var totDfs = format(tempoDfs);

    print("Tempo de execução: ${tempoDfs.inMilliseconds}ms"); // mostra o tempo em milisegundos

    print("------------------------------------------------------------------");
    if (grf.achei == true) {// se achou o vertice "ACHEI" ele coloca nos achados o vertice
      achados.add(Achados(grf.achadoVertice, tempoDfs, 'DFS'));
    } else {
      achados
          .add(Achados(0, tempoDfs, 'DFS - Não Encontrado')); //se não ele coloca não encontrado
    }

    grf.achei = false; //define achei como falso para iniciar o BFS
    grf.achadoVertice = null; // null para iniciar o BFS

    print("-------------COMEÇA BFS ------------------"); // inicia o BFS
    var inicioBfs = new DateTime.now(); // pega o tempo de inicio BFS
    await grf.bfs(2); //executa o BFS
    var noww = new DateTime.now(); // pega o tempo atual
    var tempoBfs = noww.difference(inicioBfs); // pega a diferença

    //var totBfs = format(tempoBfs);

    print("Tempo de execução: ${tempoBfs.inMilliseconds}ms"); // mostra em milisegundos

    print("------------------------------------------------------------------");

    if (grf.achei == true) { //coloca os achados na lista
      achados.add(Achados(grf.achadoVertice, tempoBfs, 'BFS'));
    } else {
      achados
          .add(Achados(0, tempoBfs, 'BFS - Não Encontrado'));
    }
  }

  print("--------- Achados -------------"); //imprime os achados
  int duracaoTotDfs = 0;
  int achadosDfs = 0;

  int duracaoTotBfs = 0;
  int achadosBfs = 0;

  for (Achados a in achados) {
    if (a.tipo == 'DFS' || a.tipo == 'DFS - Não Encontrado') {
      achadosDfs++;
      duracaoTotDfs = duracaoTotDfs + a.tempo.inMilliseconds;
    }

    if (a.tipo == 'BFS' || a.tipo == 'BFS - Não Encontrado') {
      achadosBfs++;
      duracaoTotBfs = duracaoTotBfs + a.tempo.inMilliseconds;
    }

    print(
        "Vertice: ${a.vertice}     -     Tempo: ${a.tempo.inMilliseconds}ms     -     ${a.tipo}");
  }
  print("-------------------------------");

  if (duracaoTotDfs != null && achados != null) { //calcula a media aritmetica DFS
    var mediaAritimeticaDfs = (duracaoTotDfs / achadosDfs);
    print("Media Aritmetica DFS: ${mediaAritimeticaDfs}ms");
  }

  if (duracaoTotBfs != null && achados != null) {  //calcula a media aritmetica BFS
    var mediaAritimeticaBfs = (duracaoTotBfs / achadosBfs);
    print("Media Aritmetica BFS: ${mediaAritimeticaBfs}ms");
  }
}

//Classe para armazenar conteudo no vertice
class Vertice {
  int valor;
  String conteudo;

  Vertice(this.valor, this.conteudo);
}

//Classe do grafo
class Grafo {
  int lenght; //tamanho do grafo
  bool achei = false; // se achou "ACHEI"
  int achadoVertice; //valor do "ACHEI"

  List<List<Vertice>> adj = new List<List<Vertice>>(); //lista de adjacentes

  Grafo(int tamanhoGrafo) { //construtor do grafo
    this.lenght = tamanhoGrafo;
    adj = List<List<Vertice>>(lenght);
  }

  void adicionaArestasAleatorias() { //adiciona arestas aleatorias com Mersenne Twister
    List<int> repetidosR1 = new List<int>();
    var mt = new MersenneTwister();

    for (int i = 0; i < this.lenght; i++) {
      int r1 = mt.rand(this.lenght);
      int v1;
      int v2;

      if (repetidosR1.contains(r1)) {
        i--;
      } else {
        v1 = r1;
      }

      v2 = mt.rand(this.lenght);
      //List<int> randoms = await getRandomNumbersLegit(tamanhoGrafo - 1);
      //print("Ind  "+ randoms[0].toString() + " " + randoms[1].toString());
      //grf.addArest(randoms[0], randoms[1]);

      //print("Ind  "+ v1.toString() + " " + v2.toString());

      if (this.adj[v1] == null) {
        this.addArest(v1, v2);
      } else {
        if (this.adj[v1].length >= 10) {
          i--;
        } else {
          this.addArest(v1, v2);
        }
      }
    }
  }

  void addArest(int val1, int val2) { // adiciona a aresta como filha do vertice
    List<Vertice> aux = this.adj[val1] ?? new List<Vertice>();

    
    aux.add(new Vertice(val2, "Unicesumar")); // insere o valor padrao Unicesumar
    

    this.adj[val1] = aux;
  }

  void addAchei() async { //insere o "ACHEI" aleatoriamente
    MersenneTwister mt = new MersenneTwister();
    bool achei = true;

    while (achei) {
      int random = mt.rand(lenght);

      if (this.adj[random] != null) {
        var rand = this.adj[random].length;
        this.adj[random][mt.rand(rand)].conteudo = "ACHEI";
        achei = false;
      }
    }
  }

  void dfs(int v) { // Função do DFS
    List<int> pilha = new List<int>(); //cria a pilha

    List<bool> visitados = new List<bool>(this.lenght); //verificação de vertices visitados

    for (int i = 0; i < this.lenght; i++) { // inicialza tudo como falso
      visitados[i] = false;
    }

    while (true) {
      if (!visitados[v]) {
        print("procurando arestas em vertice $v \n");
        visitados[v] = true; // visitou!
        pilha.add(v); // adicinha na pilha
        print(pilha); // mostra a pilha
      }

      bool encontrou = false;
      Vertice it;
      int itValor;
      String itConteudo;

      if (adj[v] != null) { //se tiver vazio n busca
        for (it in adj[v]) {
          if (!visitados[it.valor]) { //visita todos os filhos
            encontrou = true;
            itValor = it.valor;
            itConteudo = it.conteudo;
            break;
          }
        }
      }

      if (encontrou) { 
        if (itConteudo == "ACHEI") { // verifica se encontrou o "ACHEI"
          print('------------------ACHEI!!!!-----------------');
          print('- Vertice: $v    Achei!   Aresta: $itValor -');
          print('--------------------------------------------');
          this.achei = true;
          this.achadoVertice = itValor;
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
    !achei ? print('Encontrado todas as arestas!') : '';
  }

  void bfs(v) { // função BFS
    List<int> visited = new List<int>(); // visitados
    List<int> queue = new List<int>(); //lista

    visited.add(v);

    queue.add(v);

    while (queue.isNotEmpty) { // enquanto n tiver vazio continua executando
      var s = queue.removeAt(0);
      print("${s}");

      if (this.adj[s] != null) {
        for (var it in this.adj[s]) {
          if (!visited.contains(it.valor)) {
            if (it.conteudo == "ACHEI") { // verifica se encontrou o "ACHEI"
              print('------------------ACHEI!! BFS-----------------');
              print('- Vertice: $s    Achei!   Aresta: ${it.valor} -');
              print('--------------------------------------------');
              this.achei = true;
              this.achadoVertice = it.valor;
              queue.clear();
              break;
            }
            visited.add(it.valor);
            queue.add(it.valor);
          }
        }
      }
    }
  }
}
