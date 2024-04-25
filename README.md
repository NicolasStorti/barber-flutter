# Configuração do Projeto Flutter com Firebase

Este guia destina-se a ajudá-lo a configurar seu projeto Flutter para integrar-se perfeitamente com os serviços Firebase.

## Versão Flutter
Certifique-se de estar utilizando a versão Flutter 3.19.3 ou mais recente.

## Dependências Firebase
- Banco de dados Firestore deve ser criado.
- Firestorege também deve ser configurado para o armazenamento de arquivos.

## Node.js
Certifique-se de ter o Node.js instalado para poder executar os comandos Firebase no PowerShell.

## CLI Firebase
Instale o CLI do Firebase globalmente utilizando o comando:
```
npm install -g firebase-tools
```

## Variável de Ambiente
Adicione o seguinte caminho à sua variável de ambiente (no Windows):
```
C:\Users\User\AppData\Local\Pub\Cache\bin
```
ou substitua `User` pelo nome do seu usuário.

## Login no Firebase
Execute o comando abaixo para fazer login no Firebase:
```
firebase login
```

## Teste de Bancos
Verifique seus projetos Firebase com o comando:
```
firebase projects:list
```

## Permissões do CLI
Para permitir o acesso ao CLI, execute o seguinte comando no PowerShell:
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```


## Instalando o FlutterFire CLI
Instale a CLI do FlutterFire globalmente com o comando:
```
dart pub global activate flutterfire_cli
```

## Configurando o Projeto
Finalmente, configure seu projeto Flutter com Firebase utilizando o comando:
```
flutterfire configure
```

Isso deve configurar seu projeto Flutter para integrar-se perfeitamente com os serviços Firebase. Se encontrar algum problema durante o processo, consulte a documentação oficial do Flutter e do Firebase para obter mais assistência.

