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

Future<void> main(List<String> args) async {
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

    // 1. Converte a Lista de Objetos -> Lista de Mapas
  Map<String, dynamic> listaParaSalvar = novoItem.toJson();
  print(listaParaSalvar);

  // 2. Prepara o Arquivo Físico
  final arquivo = File('../meu_backup.json');

  // 3. Converte para Texto e Salva!
  arquivo.writeAsStringSync(jsonEncode(listaParaSalvar));

  print('Backup concluído com sucesso! Verifique a pasta do seu projeto.');
}
