# Do Papel ao Digital

Referência do produto — revisão de 28/10/2026.
Substitui os recortes anteriores. Os comandos de execução ficam no README.

## Objetivo

Reduzir papel nos processos escolares completos: cadastro, matrícula, documentos,
solicitações, horários, diário, frequência, justificativas, avaliações e resultados.

Produto genérico: cursos, modalidades, fases, componentes, docentes e requisitos
documentais são cadastrados pela instituição. EETEPA Santarém é uma referência de
pesquisa, sem configuração obrigatória ou contas reais inseridas automaticamente.
Fontes e limites: [contexto escolar](docs/contexto-escolar.md).

A versão exige validação institucional antes do uso com dados reais. Não substitui
Educacenso, sistema oficial de matrícula, histórico certificado, regimento ou
assinatura eletrônica. Regras de aprovação/recuperação não devem ser presumidas.

## Arquitetura e persistência

- Cliente Flutter/Dart: Linux, Windows, Android e Web; Forui, Riverpod, go_router,
  file_picker, pdfrx, crop_your_image, pdf e image. APIs desktop isoladas.
- Servidor independente Dart/Shelf/shelf_router, SQLite/Drift e filesystem.
  Mesmas regras em execução headless e hospedagem junto ao desktop.
- Banco é a fonte de verdade. IDs estáveis, integridade, transações, revisões
  concorrentes, upload limitado, gravação atômica e arquivos físicos opacos.
- Sem backend duplicado, sucesso simulado, listas independentes da API ou arquivos
  que apenas referenciam o caminho original no computador do usuário.
- **Manter schemaVersion 1 durante o desenvolvimento.** Quebras estruturais exigem
  recriação explícita com --reset-data RECRIAR. Marca interna detecta bancos
  incompatíveis. Não criar migrações v2/v3 nem apagar dados a cada inicialização.

## Instalação e acesso

Instalação normal começa vazia. Primeiro administrador configura usuário e senha
localmente, sem senha padrão. Administração cria contas de aluno, responsável,
professor, grêmio, secretaria, coordenação e administração.

Senhas derivadas com salt, sessões expiráveis e autorização no servidor.
Aluno/responsável acessam pessoas vinculadas explicitamente. Professor acessa
seus diários. Coordenação configura/revisa atividade acadêmica. Secretaria
gerencia cadastro, matrícula, solicitações e conferência documental.

Dados fictícios somente com --demo; restauração exige confirmação explícita.
Servidor escuta em 127.0.0.1 por padrão. Rede externa é uma escolha explícita;
Android release exige HTTPS. Sem URLs públicas de documentos. Implantação real
depende de backups, HTTPS e revisão de segurança e proteção de dados.

## Organização e matrícula

1. Cadastrar curso/modalidade e, quando necessário, modelo documental.
2. Cadastrar disciplinas e matriz por fase: carga em horas-relógio e duração da
   hora-aula em minutos. Não presumir que hora-aula tenha 45 ou 60 minutos.
3. Criar turma: curso, ano letivo, período da oferta, etapa, turno e capacidade.
4. Cadastrar aluno selecionando turma existente; matrícula começa em análise.
5. Conferir pendências e ativar matrícula. Ativação com pendências exige motivo
   registrado; servidor verifica capacidade.
6. Mudança de turma restringe curso/ano/período compatíveis. Transferência,
   cancelamento e encerramento exigem motivo e preservam histórico.
7. Renovação cria novo vínculo e conserva cadastro e documentos.

Navegação agrupa turmas por curso/modalidade e período, com filtro de ano.
Pasta significa o dossiê de uma pessoa. Documentos associados a solicitações
permanecem na pasta original, sem cópias físicas ou transferência automática.

Cadastro: nome, identificação interna, nascimento, sexo informado, nome social,
naturalidade, nacionalidade, filiação, responsável, endereço, contatos,
observações e campos adicionais. Dados opcionais não são inferidos.
Modelos definem dados/documentos exigidos; sua configuração é copiada ao cadastro,
sem mudanças retroativas silenciosas. Aplicar outro modelo a uma pasta existente
soma exigências e preserva documentos e valores preenchidos.

## Documentos e solicitações

Importar PDF/JPEG/PNG/WebP, selecionar destino/tipo, transferir bytes, consultar,
renomear, mover, baixar e excluir quando não houver vínculo impeditivo.
Conferência: aguardando, conferido ou precisa de correção, com observação.
Sem alegação de autenticação automática do documento.

Digitalização: selecionar imagens, recortar, girar, ordenar/remover páginas e
gerar PDF multipágina. Visualizador real com páginas, zoom e exportação.
Exemplos fictícios devem existir fisicamente e ficar restritos ao modo demo.

Serviços: declaração, requerimento, atividade escolar e solicitação geral.
Vincular aluno/documentos, receber protocolo e acompanhar histórico persistente.
Estados: recebida, em atendimento, aguardando solicitante e concluída.
Atendimento pode encaminhar, pedir complemento, responder e concluir.
Solicitante responde à pendência. Transições no servidor e reenvio idempotente.
Sem chat. Requerimento gera PDF para visualizar, exportar e anexar.

## Rotina acadêmica

**Diário:** componente da matriz e docente ativo atribuídos à turma. Aula registra
data, conteúdo e horas-aula; frequência explícita para cada matrícula ativa, sem
presença automática. Lista original preservada após transferências.
Rascunho, conferência, publicação e devolução com motivo. Carga ministrada deriva
das aulas publicadas e duração de hora-aula do componente.

**Horário:** dia, início/fim, sala opcional e vigência por diário. Mudanças de fase
recebem componentes/horários próprios. Bloquear conflitos reais de turma, professor
e sala em datas/dias coincidentes. Exibir dias separados, superfícies alternadas
e consulta de vigências anteriores.

**Avaliações:** título, etapa, data, valor máximo e peso. Lançamento em lista,
salvamento transacional e histórico. Zero é nota explícita. Pendente, ausente e
dispensada são situações distintas; dispensa exige motivo. Envio só após resolver
pendências; publicação pela coordenação/administração. Correções exigem devolução.

**Boletim de acompanhamento:** somente notas e frequência publicadas, filtradas
pelo aluno vinculado, agrupadas por diário/fase/etapa. Exibir valores, pesos e
situações. Média normalizada ponderada de 0 a 10, indicando incompletude quando
houver avaliação sem nota. PDF autorizado. Sem decisão automática de aprovação,
reprovação, recuperação ou certificação.

**Justificativas:** aluno/responsável seleciona falta publicada, informa motivo
e pode anexar comprovante da própria pasta. Coordenação decide e responde.
Deferimento preserva a falta como justificada; não equivale a presença ou abono.
Comprovante restrito ao aluno vinculado e à análise autorizada.

## Interface e experiência

- Navegação, título/contexto, ações, conteúdo e detalhes recolhíveis com hierarquia.
- Sem slogans, cartões decorativos ou controles sem ação. Estados vazios indicam
  o que falta e a ação correspondente.
- Campos rotulados, obrigatoriedade explícita e exemplos curtos. Ajuda adicional
  no ícone “i”, acessível por toque, mouse e teclado.
  Erros próximos do formulário; sucesso após confirmação do servidor.
- Claro, escuro e sistema com preferência persistida, contraste e superfícies
  distinguíveis. Progresso não deve deslocar o conteúdo.
- Navegação recolhível e largura dos detalhes ajustável, com preferências salvas.
- Municípios/UF em lista pesquisável local do IBGE; aceitar localidade externa
  explicitamente. Preservar dados existentes. Reaproveitar períodos, etapas e
  tipos documentais configurados, permitindo novas opções quando aplicável.
- Arquivo administrativo com pastas/subpastas navegáveis, importação, edição,
  movimentação e exclusão vazia; separado dos dossiês individuais.
- Largura estreita usa drawer, detalhes adaptados, abas roláveis e formulários
  com rolagem. Não comprimir três colunas.
- Logo em assets/logo.svg, ícones gerados e decoração funcional da janela.
- Preservar rascunhos de solicitações ao navegar.

## Verificação e entrega

Testes de API real com banco/arquivos temporários: integridade, perfis, documentos,
matrículas, solicitações, diários, notas, publicação, justificativas, horários e
persistência. Flutter: navegação, formulários, erros, temas, layout estreito,
Overlay e capturas com fontes reais. Executar formatadores/analisadores oficiais.

Compilar servidor, Linux, Web e Android quando disponíveis. Identificar APK debug;
release exige chave própria. Windows requer runner Windows/Visual Studio.
Distribuir bundle com servidor, DLLs e assets, não apenas o arquivo .exe.
Não declarar builds ou testes que não foram executados.

## Próximos ciclos

Validar calendário, matrizes oficiais, recuperação, segunda chamada, abono,
conselho, fechamento e documentos oficiais com a instituição. Importação revisada
de cronogramas, backups/restauração e implantação institucional.

OCR, nuvem, sincronização, notificações, assinatura própria, autenticação federada
e gestão multi-instituição não fazem parte desta implementação.
