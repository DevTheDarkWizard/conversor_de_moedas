/*Realiza a importação das bibliotecas*/

/*Biblioteca para desenvolvimento de Flutter*/
import 'package:flutter/material.dart';

/*Biblioteca de requisições web (GET,POST,PUT,DELETE) etc...*/
import 'package:http/http.dart' as http;

/*Biblioteca codificador e decodificador de textos incluindo JSON*/
import 'dart:convert';

/*Biblioteca para utilização de métodos assíncronos*/
import 'dart:async';

/*Link da requisição*/
const request = "https://api.hgbrasil.com/finance?format=json&key=f9a4ec03";

/*Método main()*/
/*Descrição: Inicia o programa*/
void main() {
  /*Inicia o aplicativo*/
  runApp(
    /*Cria uma instancia do MaterialApp*/
    MaterialApp(
      /*Remove o banner de debug*/
      debugShowCheckedModeBanner: false,
      /*Define a tela inicial*/
      home: Home(),
      /*Define um tema customizado*/
      theme: ThemeData(
          /*Muda a cor da dica (tips)*/
          hintColor: Colors.white,
          /*Muda a cor do tema primário*/
          primaryColor: Colors.white,
          /*Define um tema para os botões*/
          buttonTheme: ButtonThemeData(
            /*Muda a altura padrão do botão*/
            height: 25.0,
            /*Muda a cor do botão*/
            buttonColor: Colors.orange,
          ),
          /*Define uma decoração para as caixas de entrada*/
          inputDecorationTheme: InputDecorationTheme(
            /*Define uma borda quando o campo está sem foco*/
            enabledBorder: OutlineInputBorder(
              /*Define uma borda com uma cor específica*/
              borderSide: BorderSide(color: Colors.orange),
            ),
            /*Define uma borda quando o campo está com foco*/
            focusedBorder: OutlineInputBorder(
              /*Define uma borda com uma cor específica*/
              borderSide: BorderSide(color: Colors.white),
            ),
            /*Muda a cor da dica (tips) na caixa de entrada*/
            hintStyle: TextStyle(color: Colors.black45),
          )),
    ),
  );
}

/*Método getData()*/
/*Descrição: Faz uma requisição GET e retorna um resultado JSON de forma assíncrona*/
Future<Map> getData() async {
  /*async define que esse método terá uma funcionalidade assíncrona*/
  /*try (tente fazer)*/
  try {
    /*Faz uma requisição GET assíncrona pegando a URL na variável 'request'*/
    http.Response response = await http.get(request);
    /*Caso retorne que foi bem sucedida(não aconteceu nenhum problema na requisição)*/
    if (response.statusCode == 200) {
      /*Converte o retorno recebido para JSON*/
      return json.decode(response.body); /*Retorna o JSON*/
    } else {
      /*Caso de algum código de status diferente que 200*/
      return null; /*Retorna nulo*/
    }
  } catch (Exception) {
    /*caso encontre algum problema faça*/
    return null; /*Retorna nulo*/
  }
}

/*Cria uma classe chamada 'Home' com herança da classe 'StatefulWidget'*/
class Home extends StatefulWidget {
  /*Substitui o método createState()*/
  @override
  _HomeState createState() => _HomeState();
}

/*Cria uma chasse chamada '_HomeState' com herança da classe 'State<T>' sendo T a classe Home */
class _HomeState extends State<Home> {
  /*Define uma variável do tipo 'Future<T>' sendo T a classe Map para um armazenamento assíncrono*/
  /*Map é uma classe que armazena uma chave e dentro dessa chave um valor*/
  Future<Map> _dados;

  /*Substitui o método initState()*/
  @override
  void initState() {
    /*Chama o método original*/
    /*quando usa-se super, será referente a classe herdada*/
    super.initState();
    /*Armazena os dados retornados da função getData() para uso futuro*/
    _dados = getData();
  }

  /*Controladores de caixa de texto*/
  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  /*Cria uma chave para formulário*/
  /*É usada para acessar outros objetos associados com esse elemento*/
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /*Define os valores padrões das variáves*/
  /*São usadas para realizar o calculo da conversão*/
  double dolar = 1.0, euro = 1.0;

  /*Método _numberValidator()*/
  /*Descrição: Verificar se o texto contido na caixa é um valor decimal caso contrário retornará uma mensagem*/
  String _numberValidator(String valor) {
    /*Verifica se o texto é um valor decimal, caso não seja a variável recebera o valor 'null'*/
    double valor_double = num.tryParse(valor)?.toDouble();
    /*Caso esteja vazia, ou não seja decimal*/
    if (valor.isEmpty || valor_double == null) {
      return "Digite algum valor válido!"; /*Retorne a mensagem*/
    } else if (valor_double < 0) {
      /*Caso seja um valor decimal abaixo de zero*/
      return "Digite um valor acima de zero!"; /*Retorne a mensagem*/
    }
  }

  /*Método _resetFields()*/
  /*Descrição: Limpar as caixas de texto e esconder o teclado*/
  void _resetFields() {
    /*Limpa as caixas de texto*/
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    /*Retorna a validação para o estado inicial*/
    if (_formKey.currentState != null) _formKey.currentState.reset();
    /*Esconde o teclado*/
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /*Método _realChanged()*/
  /*Descrição: Ação chamada quando a caixa de texto 'Real' muda algum valor*/
  void _realChanged(String valor) {
    /*Verifica se o texto é um valor decimal, caso não seja a variável recebera o valor 'null'*/
    double real = num.tryParse(valor)?.toDouble();

    /*Verifica se não existe nenhum valor nas outras caixas*/
    if (dolarController.text.length == 0) dolarController.text = "0";
    /*Muda o texto da caixa 'Dolar'*/
    if (euroController.text.length == 0) euroController.text = "0";
    /*Muda o texto da caixa 'Euro'*/

    /*Valida as caixas de texto*/
    if (_formKey.currentState.validate()) {
      /*Faz o calculo de conversão da moeda e formata o texto para 2 casas decimais(caso não tenha ficará .00)*/
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    }
  }

  /*Método _dolarChanged()*/
  /*Descrição: Ação chamada quando a caixa de texto 'Dolar' muda algum valor*/
  void _dolarChanged(String valor) {
    /*Verifica se o texto é um valor decimal, caso não seja a variável recebera o valor 'null'*/
    double dolar = num.tryParse(valor)?.toDouble();

    /*Verifica se não existe nenhum valor nas outras caixas*/
    if (realController.text.length == 0) realController.text = "0";
    /*Muda o texto da caixa 'Real'*/
    if (euroController.text.length == 0) euroController.text = "0";
    /*Muda o texto da caixa 'Euro'*/

    /*Valida as caixas de texto*/
    if (_formKey.currentState.validate()) {
      /*Faz o calculo de conversão da moeda e formata o texto para 2 casas decimais(caso não tenha ficará .00)*/
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
    }
  }

  /*Método _euroChanged()*/
  /*Descrição: Ação chamada quando a caixa de texto 'Euro' muda algum valor*/
  void _euroChanged(String valor) {
    /*Verifica se o texto é um valor decimal, caso não seja a variável recebera o valor 'null'*/
    double euro = num.tryParse(valor)?.toDouble();

    /*Verifica se não existe nenhum valor nas outras caixas*/
    if (realController.text.length == 0) realController.text = "0";
    /*Muda o texto da caixa 'Real'*/
    if (dolarController.text.length == 0) dolarController.text = "0";
    /*Muda o texto da caixa 'Dolar'*/

    /*Valida as caixas de texto*/
    if (_formKey.currentState.validate()) {
      /*Faz o calculo de conversão da moeda e formata o texto para 2 casas decimais(caso não tenha ficará .00)*/
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
    }
  }

  /*Substitui o método build()*/
  @override
  Widget build(BuildContext context) {
    /*Scaffold é usado para ter uma estrutura com alguns Widgets já predefinidos*/
    /*Nele poderá adicionar a barra superior, inferior, botões entre outras coisas*/
    return Scaffold(
        /*Define a barra superior*/
        appBar: AppBar(
          /*Centraliza o texto do título*/
          centerTitle: true,
          /*Adiciona um título*/
          title: Text(
            /*Define o texto*/
            "\$ Conversor de Moedas \$",
            /*Muda a cor do texto*/
            style: TextStyle(color: Colors.white),
          ),
          /*Muda a cor do fundo*/
          backgroundColor: Colors.orange,
          /*Define que essa barra terá botões*/
          actions: <Widget>[
            /*Adiciona um botão do tipo IconButton*/
            IconButton(
              /*Ação quando for precionado*/
              onPressed: _resetFields,
              /*Define o icone*/
              icon: Icon(
                /*Icone representativo*/
                Icons.autorenew,
                /*Tamanho do icone*/
                size: 30,
                /*Cor do icone*/
                color: Colors.white,
              ),
            )
          ],
        ),
        /*Muda a cor do fundo do corpo*/
        backgroundColor: Colors.orangeAccent,
        /*Define o corpo*/
        /*O widget FutureBuilder é usado quando existe uma operação assíncrona*/
        body: FutureBuilder<Map>(
          /*Executa uma função ou recebe os dados do tipo Future<T>*/
          future: _dados,
          /*Define as operações*/
          builder: (context, snapshot) {
            /*Define o retorno*/
            Widget retorno = Container();
            /*Verifica a situação do processo*/
            switch (snapshot.connectionState) {
              /*Caso não seja nenhuma ou esteja esperando*/
              case ConnectionState.none:
              case ConnectionState.waiting:
                /*Armazena o retorno*/
                retorno = Center(
                  /*Centraliza tudo que estiver dentro do "filho"(child)*/
                  child: Text(
                    /*Define o texto*/
                    "Carregando Dados...",
                    /*Define o estilo do texto*/
                    style: TextStyle(
                      /*Muda o tamanho do texto*/
                      fontSize: 30.0,
                      /*Muda a cor do texto*/
                      color: Colors.black54,
                    ),
                    /*Muda o alinhamento do texto*/
                    textAlign: TextAlign.center,
                  ),
                );
                break;
              /*Caso o estado sejá qualquer outro*/
              default:
                /*Verifica se acontenceu algum erro*/
                if (snapshot.hasError) {
                  /*Armazena o retorno*/
                  retorno = Center(
                    /*Centraliza tudo que estiver dentro do "filho"(child)*/
                    child: Text(
                      /*Define o texto*/
                      "Não foi possível receber os dados! Erro: " +
                          snapshot.error.toString(),
                      /*Define o estilo do texto*/
                      style: TextStyle(
                        /*Muda o tamanho do texto*/
                        fontSize: 25.0,
                        /*Muda a cor do texto*/
                        color: Colors.red,
                      ),
                      /*Muda o alinhamento do texto*/
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData) {
                  /*Verifica se não foi recebido nada*/
                  /*Armazena o retorno*/
                  retorno = Center(
                    /*Centraliza tudo que estiver dentro do "filho"(child)*/
                    child: Text(
                      /*Define o texto*/
                      "Não foi possível receber os dados!",
                      /*Define o estilo do texto*/
                      style: TextStyle(
                        /*Muda o tamanho do texto*/
                        fontSize: 25.0,
                        /*Muda a cor do texto*/
                        color: Colors.red,
                      ),
                      /*Muda o alinhamento do texto*/
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  /*Caso encontre dados do recebimento*/
                  /*Pega os valores do JSON recebido e armazena nas variáveis*/
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  /*Escreve uma mensagem no debug*/
                  debugPrint("Dolar: "+dolar.toString());
                  debugPrint("Euro: "+euro.toString());
                  /*Armazena o retorno*/
                  retorno = SingleChildScrollView(
                    /*SingleChildScrollView é um widget que armazena um
                    conteúdo e caso esse conteúdo for muito grande, você conseguirá "rolar" para baixo
                    ou para cima para ver o conteúdo, o conteúdo receberá o efeito de "scrollbar"*/
                    /*Define o conteúdo*/
                    child: Column(
                      /*Define uma conteúdo que cada "filho" dentro dele ficará vertical(um em baixo do outro)*/
                      /*Define que todos os filhos ficaram no centro*/
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      /*Define os filhos*/
                      children: <Widget>[
                        /*Adiciona um icone*/
                        Icon(
                          /*Icone representativo*/
                          Icons.monetization_on,
                          /*Tamanho do icone*/
                          size: 150.0,
                          /*Cor do icone*/
                          color: Colors.white,
                        ),
                        /*Adiciona um preenchimento interno*/
                        Padding(
                          /*Define a margem interna*/
                          padding: EdgeInsets.only(
                            left: 15.0,
                            //Adiciona 15.0 no preenchimento da esquerda
                            top: 25.0,
                            //Adiciona 25.0 no preenchimento de cima
                            right: 15.0,
                            //Adiciona 15.0 no preenchimento da direita
                            bottom:
                                25.0, //Adiciona 25.0 no preenchimento de baixo*/
                          ),
                          /*Adiciona o conteúdo*/
                          child: Form(
                            /*Uma das utilidades do 'Form' é validar os campos*/
                            /*Define uma chave única de identificação*/
                            key: _formKey,
                            /*Defi*/
                            child: Column(
                              /*Define uma conteúdo que cada "filho" dentro dele ficará vertical(um em baixo do outro)*/
                              /*Define os filhos*/
                              children: <Widget>[
                                /*Chama o método para construir a caixa de texto*/
                                buildFormInputNumber(
                                  /*Passa o parâmetro do texto*/
                                  label: "Real",
                                  /*Passa o parâmetro do prefixo*/
                                  prefix: "R\$",
                                  /*Passa o controlador*/
                                  controller: realController,
                                  /*Passa o método de quando algum valor for alterado*/
                                  onChanged: _realChanged,
                                  /*Passa o validador do campo*/
                                  validator: _numberValidator,
                                ),
                                /*Widget de separação*/
                                Divider(),
                                /*Chama o método para construir a caixa de texto*/
                                buildFormInputNumber(
                                  /*Passa o parâmetro do texto*/
                                  label: "Dolar",
                                  /*Passa o parâmetro do prefixo*/
                                  prefix: "US\$",
                                  /*Passa o controlador*/
                                  controller: dolarController,
                                  /*Passa o método de quando algum valor for alterado*/
                                  onChanged: _dolarChanged,
                                  /*Passa o validador do campo*/
                                  validator: _numberValidator,
                                ),
                                /*Widget de separação*/
                                Divider(),
                                /*Chama o método para construir a caixa de texto*/
                                buildFormInputNumber(
                                  /*Passa o parâmetro do texto*/
                                  label: "Euro",
                                  /*Passa o parâmetro do prefixo*/
                                  prefix: "€",
                                  /*Passa o controlador*/
                                  controller: euroController,
                                  /*Passa o método de quando algum valor for alterado*/
                                  onChanged: _euroChanged,
                                  /*Passa o validador do campo*/
                                  validator: _numberValidator,
                                ),
                                /*Adiciona um preenchimento interno*/
                                Padding(
                                  /*Define a margem interna para todos os lados*/
                                  padding: EdgeInsets.all(15),
                                  /*Define o conteúdo*/
                                  child: Container(
                                    /*Define a altura*/
                                    height: 50.0,
                                    /*Define o conteúdo*/
                                    child: RaisedButton(
                                      /*Cria um botão do tipo RaisedButton*/
                                      /*Define o conteúdo*/
                                      child: Text(
                                        /*Define o texto*/
                                        "Limpar",
                                        /*Define o estilo do texto*/
                                        style: TextStyle(
                                            /*Muda a cor do texto*/
                                            color: Colors.white,
                                            /*Muda o tamanho do texto*/
                                            fontSize: 20.0),
                                      ),
                                      /*Ação quando o botão for precionado*/
                                      onPressed: _resetFields,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                break;
            }

            /*Retorna o conteúdo para mostrar na tela*/
            return retorno;
          },
        ));
  }
}

/*Método buildFormInputNumber()*/
/*Descrição: Cria e retorna uma caixa de texto padrão com algumas definições*/
Widget buildFormInputNumber(
    {String label,
    String prefix,
    TextEditingController controller,
    Function onChanged,
    Function validator}) {
  /*Retorna uma caixa de texto do tipo 'TextFormField'*/
  return TextFormField(
    /*Ação chamada quando o valor da caixa é alterado*/
    onChanged: onChanged,
    /*"Remove o foco automático"*/
    autofocus: false,
    /*Define o tipo que o teclado vai ter quando a caixa estiver focada*/
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    /*Define o controlador*/
    controller: controller,
    /*Define o validador*/
    validator: validator,
    /*Define as decorações*/
    decoration: InputDecoration(
      /*Define o texto representativo da caixa*/
      labelText: (label ?? ""),
      /*Define o estilo do texto representativo*/
      labelStyle: TextStyle(
        /*Muda a cor para branco*/
        color: Colors.white,
        /*Muda o tamanho do texto*/
        fontSize: 20.0,
      ),
      /*Define um prefixo quando existe algum valor na caixa*/
      prefixText: (prefix ?? ""),
      /*Define o estilo do prefixo*/
      prefixStyle: TextStyle(
        /*Muda a cor para branco*/
        color: Colors.white,
        /*Muda o tamanho do texto*/
        fontSize: 20.0,
      ),
    ),
    /*Define o estilo do texto dentro da caixa*/
    style: TextStyle(
      /*Muda a cor para branco*/
      color: Colors.white,
      /*Muda o tamanho do texto*/
      fontSize: 20.0,
    ),
  );
}
