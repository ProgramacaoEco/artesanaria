<h1 align=left>#Loja_Eco</h1>

Aplicativo de Loja em Flutter

<h1 align=left>#Sobre</h1>

Aplicativo de Loja para compra de produtos físicos

<h1 align=left>#Tabela de Conteúdos</h1>

<p align="center">
 <a href="#sobre">Sobre</a> •
 <a href="#tabela-de-conteudo">Tabela de Conteúdos</a> • 
 <a href="#instalacao">Instalação</a> • 
 <a href="#features">Features</a> • 
 <a href="#objetos-flutter">Objetos Flutter</a>
 <a href="#objetos-e-variaveis">Objetos e Variáveis</a> • 

</p>

<h1 align=left>#Instalação</h1>

  Para realizar a instalção do projeto em sua máquina, utiliza-se o gitbash integrado ao VsCode,
além de ser necessário realizar a instalação do flutter na sua versão 2.5.3 (https://docs.flutter.dev/get-started/install).
  Também é necessário instalar algumas 
   <a href="https://br.atsit.in/archives/45648#:~:text=Dart%20e%20As%20extens%C3%B5es%20Flutter,programa%C3%A7%C3%A3o%20Dart%20no%20VS%20Code.&text=Desenvolvidas%20e%20mantidas%20pela%20pr%C3%B3pria,e%20v%C3%A1rias%20op%C3%A7%C3%B5es%20de%20depura%C3%A7%C3%A3o">
 extensões
    </a>
     do VsCode.

  Após ter tudo instalado, deve-se puxar o código do github para sua máquina, através do gitbash.
  Abrindo o código, deve-se baixar os dados do arquivo pubspeck.yalm(get pub).
  Para rodar o projeto, você deve ter o AndroidStudio instalado, podendo rodar o aplicativo em
  uma página web ou em um emulador android propriamente dito.
  
  <h1 align=left>#Features</h1>
  
- [x] Listar Produtos
- [x] Carrinho de Compras
- [x] Editar item do Carrinho de Compras
- [x] Realizar Compras
- [ ] Cadastrar Usuário
- [ ] Logar Usuário


  <h1 align=left>#Objetos Flutter</h1>
  
 - Shared Preferences: 
O App utiliza o SharedPreferences em algumas situações, nesse caso, é nele em que se passa as 
informações de uma tela para outra, já que o mesmo guarda na memória alguns valores. Porém o uso
dele é limitado. 

  <h1 align=left>#Objetos e variáveis</h1>

 - Carrinho:
O Carrinho é um objeto do sistema que tem como funções carregar os itens (banco de dados local), 
armazenando valores como (id_produto, quantidade, valor e tamanho) de cada item (card) do carrinho.
Também é responsável por alterações em seus objetos-filhos (os itens) e também por comprá-los ou excluí-los
do banco.

 - Produto:
Os Objetos que se referenciam ao produto são os Cards que carregam as informações do mesmo. Utilizam
http para fazer requisições de informações. Ao clicar nos cards de produtos, você é direcionado à uma
página do produto, carregada com as informações do SharedPreferences. Finalizando a tela do produto,
se o mesmo for comprado ele é enviado para o carrinho, onde essas informações irão popular o banco.

 - Classe Cores:
Esta classe serve unicamente para atribuir valores à váriaveis que irão ser responsáveis por carregar
as informações referente as cores do App, sendo assim, alterando estas variáveis você altera as cores
tema do projeto.
