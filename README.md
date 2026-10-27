# Do Papel ao Digital

Flutter, servidor Dart/Shelf, SQLite/Drift e arquivos locais. Uma pasta reúne a identificação e os documentos de um aluno; cursos, períodos, turmas, matrículas, diários e solicitações mantêm vínculos reais no servidor. A instalação começa sem alunos, cursos ou arquivos fictícios.

## Executar

Ambiente verificado: Flutter 3.47.5, Dart 3.13.4, Java 21 e Android SDK 36. Linux requer as dependências de desenvolvimento GTK do Flutter.

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

Na primeira conexão, crie o administrador no computador do servidor. Não existe senha padrão. Depois, em **Contas e acessos**, cadastre administração, secretaria, coordenação, professores, grêmio, alunos e responsáveis. Os dois últimos recebem vínculos explícitos com as pastas dos alunos. Contas podem ser desativadas, senhas redefinidas e sessões revogadas. O cliente solicita nova entrada ao ser reiniciado; não grava senhas nem tokens em preferências.

O servidor escuta `127.0.0.1:8080`; `/health` verifica disponibilidade. Aceita `--data`/`DPAD_DATA`, `--port`, `--host` e `--web`. Banco e documentos ficam em `<data>/database.sqlite` e `<data>/files/`, fora dos builds. LAN exige `--host` explícito. Para dados institucionais, HTTPS, backup/restauração e revisão de acesso ainda são necessários.

## Organização e uso

1. Crie **modelos de pasta**: documentos e informações exigidas, sem listas fixas aplicadas a todos. O JSON `assets/templates/pasta-escolar.json` é um exemplo importável e editável, baseado na lista informada pela escola.
2. Cadastre **curso e modalidade**, opcionalmente com modelo documental padrão.
3. Cadastre **turmas** por curso, ano, período, etapa, turno e capacidade. A lateral agrupa curso → período → turma, com filtro de ano.
4. Cadastre o aluno selecionando uma turma existente e o modelo. A pasta e a matrícula em análise são criadas na mesma transação.
5. Receba e confira documentos. A ativação considera dados exigidos, documentos e vagas; uma exceção documental exige justificativa registrada. Mudar turma, transferir, cancelar e encerrar o período preserva histórico. A renovação abre matrícula em outro período, reutilizando a pasta. Exigências adicionais do modelo do curso são somadas à pasta ao abrir outra matrícula.
6. Em **Organização acadêmica**, cadastre disciplinas e componentes por curso/fase, com carga horária e duração da hora-aula. Complete os dados profissionais dos professores (a conta é criada pela administração). Configure **diários** selecionando componente da matriz e docente. Registre conteúdo, quantidade de aulas e frequência; envie para revisão e publique. Alunos e responsáveis veem somente os próprios registros de frequência publicados. Em **Avaliações e notas**, lance notas da turma, envie e publique após conferência. **Boletim e frequência**, na pasta do aluno, apresenta somente os registros publicados e permite exportar PDF. Ausência e dispensa não viram zero automaticamente.
7. Em **Horários**, adicione blocos com vigência e sala; conflitos de turma, professor e sala são bloqueados. Na pasta do aluno, **Boletim e frequência → Frequência** permite justificar uma falta publicada; a coordenação analisa na turma. Deferir preserva a falta, sem abono automático.
8. Solicitações podem ser abertas na pasta, com anexos existentes ou importados. O setor inicia, solicita complemento, encaminha e conclui com histórico. Reenvios da mesma operação não duplicam pedidos.

PDF, JPEG, PNG e WebP têm limite de 30 MB. A digitalização recorta, gira e organiza imagens em PDF e preserva os originais. PDFs abrem em visualizador real. Modelos alterados valem para novos cadastros; na pasta existente, **Aplicar modelo** soma exigências sem apagar arquivos ou dados. O **Arquivo de documentos** permite navegar, importar e organizar documentos administrativos em pastas e subpastas.

Campos têm ajuda no ícone “i”. Municípios/UF usam catálogo local da [API do IBGE](https://servicodados.ibge.gov.br/api/docs/localidades), pesquisável sem internet; atualize o recurso com `python3 tools/update-localities.py`. A lateral pode ser recolhida; a largura do painel de detalhes é ajustável e salva.

## Builds

```bash
./tools/build-linux.sh
apps/client/build/linux/x64/release/bundle/papel_digital
```

Distribua o `bundle` inteiro. **Hospedar nesta máquina** utiliza o mesmo servidor do modo independente e encerra o processo controlado ao fechar a janela. A logo original fica em `assets/logo.svg`; os arquivos derivados do cliente e os ícones podem ser atualizados com `python3 tools/generate-icons.py` (rsvg-convert e Pillow).

Servidor independente:

```bash
cd apps/server
dart build cli --target bin/dPad_server.dart -o build/server
build/server/bundle/bin/dPad_server --data ../../data
```

Preserve `bundle/bin` e `bundle/lib`, incluindo os assets nativos do SQLite. Windows usa `tools/build-windows.ps1` em PowerShell, Flutter e Visual Studio com C++. O script verifica o servidor empacotado e gera `dist/DoPapelAoDigital-windows-x64.zip`, com o .exe, DLLs, assets e servidor. O workflow manual `.github/workflows/build-windows.yml` prepara um runner Windows; não foi executado neste ambiente Linux.

Android, como cliente do servidor:

```bash
./tools/build-android.sh debug
```

APK: `apps/client/build/app/outputs/flutter-apk/app-debug.apk`. Selecione a conexão da escola; `localhost` no celular é o próprio aparelho. No emulador Android, `10.0.2.2` aponta para o computador hospedeiro. HTTP é permitido somente na versão de laboratório/debug. Release exige HTTPS e assinatura própria em `apps/client/android/key.properties`; esse arquivo e as chaves não entram no Git. O aplicativo não hospeda o servidor no Android.

Web: em `apps/client`, execute `flutter build web`. Sirva com `--web ../client/build/web` no servidor. A mesma origem é o padrão; desenvolvimento em outra origem requer `--cors-origin` explícito.

## Testes

```bash
cd apps/server
dart format --output=none --set-exit-if-changed lib bin test
dart analyze
dart test --concurrency=2
cd ../client
flutter analyze
flutter test
```

`python3 tools/test-client.py` na raiz também executa as telas Linux com preferências reais isoladas. `DPAD_SCREENSHOT_DIR=/tmp/dpad-review python3 tools/test-client.py` gera capturas. Os testes usam HTTP, SQLite e arquivos reais; incluem contas, autorização, curso/turma, modelos, matrículas, diário, notas, publicação, justificativas, horários, solicitações, PDF, temas, escalas fracionárias e regressão de `Overlay` da janela.

Após os builds, `python3 tools/smoke-server.py` verifica o servidor compilado, o cliente Web e a persistência após reinício.

## Recriar dados de desenvolvimento

O esquema permanece inicial, sem migrações incrementais. Quando houver incompatibilidade, pare a instalação e recrie **explicitamente** o diretório desejado:

```bash
cd apps/server
dart run bin/dPad_server.dart --data ../../data --reset-data RECRIAR
```

Isso apaga banco e documentos desse diretório. Um reinício comum não apaga nada. Depois de alterar `schema.drift`, regenere com `dart run build_runner build`.

`--demo`, somente em diretório separado com dados fictícios, mantém os perfis de demonstração usados pelos testes antigos. Esse modo aceita troca de perfil e não deve ser confundido com autenticação. O modo normal exige conta e senha; o cabeçalho `X-Profile` não concede acesso.

Pesquisa sobre EETEPA Santarém, cronograma, docentes públicos e decisões de UX: [docs/contexto-escolar.md](docs/contexto-escolar.md). Limites e próximos passos: [docs/next-cycle.md](docs/next-cycle.md). O boletim é de acompanhamento, sem cálculo institucional de aprovação/recuperação.
