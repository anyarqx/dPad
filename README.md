# Do Papel Ao Digital

Gestão de pastas de alunos, matrículas, documentos, solicitações e rotina acadêmica. O cliente Flutter usa a API de um servidor Dart com SQLite e armazenamento local dos arquivos.

## Executar

Use Flutter 3.47 e Dart 3.13. O desktop Linux requer as dependências GTK do Flutter.

```bash
cd apps/server
dart pub get
dart run bin/dPad_server.dart --data ../../data
```

Em outro terminal:

```bash
cd apps/client
flutter pub get
flutter run -d linux
```

Crie a primeira conta de administração no computador do servidor. A instalação começa vazia. Em **Contas e acessos**, gerencie os perfis e os vínculos de alunos e responsáveis. Na pasta do aluno, **Criar acesso** reaproveita o cadastro. A senha é escolhida durante a criação.

O servidor escuta em `0.0.0.0:8080`. Use `--host 127.0.0.1` para limitar à própria máquina e `--port` para alterar a porta. No cliente, **Servidor → Conexão e hospedagem** conecta a uma instalação ou inicia o servidor no desktop. Informe a porta no endereço, como `http://127.0.0.1:8090`. A rota `/health` verifica disponibilidade.

## Rotinas

- **Pastas de alunos** reúne dados, documentos, matrículas, solicitações e boletim por pessoa. A matrícula é opcional no cadastro e usa uma turma existente. Defina as exigências em **Modelos de pasta**. O arquivo `assets/templates/pasta-escolar.json` é um exemplo editável.
- **Cursos e turmas** reúne matrículas e horários. A matriz por fase, em **Org. Acadêmica**, gera os diários. No diário, **Docentes** permite atribuir professores por vigência. A grade semanal usa modelos de períodos e verifica conflitos de turma, professor e sala na API.
- **Diários** reúne frequência mensal, avaliações e notas. O boletim mostra os registros publicados. As faltas podem ser registradas por dia ou por aula. A análise da justificativa preserva a falta registrada.
- **Arquivo de documentos** organiza as pastas administrativas. Importe PDF, JPEG, PNG ou WebP de até 30 MB. A digitalização recorta, gira e ordena imagens num único PDF. Use seleção múltipla para mover, conferir, associar ou excluir.
- **Solicitações** acompanha pedidos por protocolo. **Atendimento** organiza início, encaminhamento, complemento, resposta e conclusão.
- **Ajuda → Atalhos de teclado** mostra a tabela de teclas e ações. No desktop, F11 alterna tela cheia.

## Dados e manutenção

Banco, documentos e backups ficam em `database.sqlite`, `files/` e `backups/` no diretório indicado por `--data`. Em **Servidor → Manutenção**, a administração define a instituição e o modelo padrão, gera backups e confere o conteúdo antes de restaurar. A troca conserva uma cópia da instalação anterior.

Para uma instância isolada com dados fictícios:

```bash
cd apps/server
dart run bin/dPad_server.dart --data ../../data --test --port 8081
```

Conecte em `http://127.0.0.1:8081`. Os dados ficam em `data.test` e podem ser repostos em **Servidor → Manutenção → Restaurar dados fictícios**. Esse ambiente usa perfis de teste. A instalação normal exige conta e senha.

O esquema SQLite é 1. Para recriar **somente** um banco de desenvolvimento descartável, pare o servidor e use `--reset-data RECRIAR` com o diretório escolhido. A operação apaga o banco e os documentos desse diretório.

## Empacotar

- **Linux** — `bash tools/build/linux.sh`. Distribua o bundle com o servidor.
- **Windows** — `tools/build/windows.ps1` em PowerShell com Flutter e Visual Studio C++. O ZIP inclui executável, DLLs, assets e servidor.
- **Android** — `bash tools/build/android.sh arm64 debug`. Conecte pelo endereço LAN do servidor. O emulador acessa o computador hospedeiro em `10.0.2.2`. O APK de release exige assinatura e HTTPS.
- **Web** — em `apps/client`, execute `flutter build web --no-web-resources-cdn`. Inicie o servidor com `--web ../client/build/web` para servir interface e API na mesma origem. Outra origem exige configurar `--cors-origin`.

Para compilar só o servidor, execute `dart build cli --target bin/dPad_server.dart -o build/server` em `apps/server`. Execute `build/server/bundle/bin/dPad_server` e preserve as pastas `bin` e `lib` do bundle.

## Verificar

- **Servidor** — em `apps/server`, execute `dart analyze` e `dart test`.
- **Cliente** — em `apps/client`, execute `flutter analyze`. Na raiz, `python3 tools/test-client.py` executa a suíte com servidores e preferências temporários no Linux. Defina `DPAD_SCREENSHOT_DIR` para registrar capturas.
- **Integração** — após os builds do servidor e da Web, execute `python3 tools/smoke-server.py`. A verificação inclui restauração, isolamento dos dados fictícios e persistência.
- **Latência local** — em `apps/server`, execute `dart run bin/benchmark.dart`.
