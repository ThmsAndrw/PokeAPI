import '../lib/pkmn.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> buscarDados(String input) async {
  final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/${input}/');
  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    var dados = jsonDecode(resposta.body);
    return dados;
  } else {
    throw Exception('Erro: ${resposta.statusCode}');
  }
}

Future<void> listarPesquisas() async {
  final arquivo = File('../meu_backup.json');

  if (arquivo.existsSync()) {
    String conteudo = arquivo.readAsStringSync();
    List<dynamic> dados = jsonDecode(conteudo);
    print("Pesquisas salvas: $dados");
  } else {
    print("Nenhuma pesquisa salva encontrada.");
  }
}

Future<void> pesquisarPkmn() async {
  print("Digite o nome ou o ID do Pokemon: ");
  String input = stdin.readLineSync()!;

  late Pkmn novoItem;

  try {
    Map<String, dynamic> listaInternet = await buscarDados(input);

    // O operador ?? protege contra dados nulos
    int id = listaInternet['id'] ?? 0;
    String name = listaInternet['name'] ?? "";
    int weight = listaInternet['weight'] ?? "";
    int height = listaInternet['height'] ?? "";

    // Criação do objeto e adição na RAM
    novoItem = Pkmn(id, name, weight, height);
  } catch (e) {
    print('Falha ao carregar: $e');
  }

  // Prepara o Arquivo Físico
  final arquivo = File('../meu_backup.json');

  // Lê a lista existente ou cria uma 1 vazia
  List<Map<String, dynamic>> pokemonsExistentes = [];
  if (arquivo.existsSync()) {
    String conteudo = arquivo.readAsStringSync();
    dynamic decodificado = jsonDecode(conteudo);

    // Verifica se é uma lista ou um objeto único
    if (decodificado is List) {
      pokemonsExistentes = List<Map<String, dynamic>>.from(decodificado);
    } else if (decodificado is Map) {
      pokemonsExistentes.add(Map<String, dynamic>.from(decodificado));
    }
  }

  // Adiciona o novo item à lista
  pokemonsExistentes.add(novoItem.toJson());

  // Salva a lista completa
  arquivo.writeAsStringSync(jsonEncode(pokemonsExistentes));

  print("Pokemon pesquisado e adicionado!");
}

Future<void> deletarPesquisa() async {
  final arquivo = File('../meu_backup.json');

  if (arquivo.existsSync()) {
    arquivo.deleteSync();
    print("Pesquisa deletada com sucesso.");
  } else {
    print("Nenhuma pesquisa salva encontrada para deletar.");
  }
}

Future<void> main(List<String> args) async {
  while (true) {
    print(
      "Digite 1 para listar as pesquisas\n" +
          "Digite 2 para pesquisar um pokemon\n" +
          "Digite 3 para deletar uma pesquisa\n" +
          "Digite 4 para sair",
    );
    String? opcao = stdin.readLineSync();

    if (opcao == "4") {
      print("Saindo...");
      break;
    } else if (opcao == "2") {
      await pesquisarPkmn();
    } else if (opcao == "1") {
      await listarPesquisas();
    } else if (opcao == "3") {
      await deletarPesquisa();
    } else {
      print("Opção inválida, tente novamente.");
    }
  }
}
