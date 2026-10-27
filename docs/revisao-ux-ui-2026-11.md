# Revisão de UX/UI e sequência de refatoração

20/11/2026. Recorte: primeiro corrigir a base visual e os problemas diretos de uso; registrar as mudanças profundas antes de implementá-las. Esta revisão complementa `spec.md`, sem substituir as regras funcionais do produto.

## Método e limites

Foram inspecionados o shell Flutter, menus de janela, navegação, temas, formulários compartilhados, pastas de alunos, arquivo administrativo, matrículas, solicitações, diários, notas, horários, launcher e API. A pesquisa abaixo foi confrontada com esses arquivos e com testes de componentes e jornadas usando HTTP/SQLite/arquivos reais.

É uma auditoria técnica e heurística. A avaliação de intuitividade 4/10 veio do usuário; não é uma medição feita com uma amostra de participantes. Capturas e testes de pixels ajudam a verificar a implementação, mas não certificam a renderização em todos os monitores, drivers ou compositores.

## Ajustes aplicados nesta etapa

| Problema observado | Alteração aplicada | Onde |
|---|---|---|
| Cinzas azulados e pouca distinção entre áreas | Paletas neutras clara/escura, com cores próprias para janela, sidebar, rodapé da sidebar, cabeçalho e detalhes; cor de destaque reservada para ações e seleção | `shared/app_theme.dart`, `main.dart` |
| Menu do software ausente do topo | Configurações → Aparência / Sobre e licenças; Servidor → conectar, verificar conexão, hospedar e encerrar a própria hospedagem. Abrir um menu fecha o anterior | `shared/software_menu.dart`, `window_title_bar.dart`, `app/dialogs.dart` |
| Preferências repetidas na lateral e mistura de conexão com aparência | Preferências saíram do rodapé da sidebar. Servidor tem menu próprio. Conta e arquivo permanecem na área inferior da navegação | `app/navigation.dart` |
| Rótulos da sidebar quebrados | Uma linha, reticências e tooltip; “Org. Acadêmica”; cursos/períodos/turmas mantêm níveis distinguíveis | `app/navigation.dart` |
| Lateral estreita comprimindo o conteúdo | Rail compacta automática em larguras intermediárias, com expansão em drawer; recolhimento manual continua disponível | `app/navigation.dart`, `workspace.dart` |
| Cabeçalhos coloridos “flutuando” com margem externa | Cabeçalho contínuo de ponta a ponta da área principal, com espaçamento interno; conteúdo recebe seu próprio padding. Padrão aplicado nas páginas de alunos, cursos/turmas, organização acadêmica, contas, modelos, arquivo e solicitações | `shared/page_header.dart`, páginas principais |
| Abas parecendo pequenos botões | Abas textuais de altura consistente, distribuídas na largura disponível, com indicador inferior; rolagem quando os textos não cabem | `shared/section_tabs.dart`, páginas acadêmicas e pasta do aluno |
| Rótulo com ajuda atravessando a borda do campo | Seletores e localidades usam rótulos acima do controle; ajuda continua no “i”; seleção dependente acompanha o valor atualizado | `shared/widgets.dart`, `localities.dart`, `search_picker.dart` |
| Datas exigindo separadores manuais | Máscara de digitação: `13` vira `13/`, o mês abre o trecho do ano; aceita colagem, mantém o contrato ISO da API e não abre calendário | `shared/date_input.dart`, `shared/widgets.dart` |
| Seletores sem escolha real | Valor já definido com uma única opção aparece como informação; curso único na matriz e setor definido pelo serviço não pedem seleção redundante | `shared/widgets.dart`, `academic_page.dart`, `features/forms.dart` |
| Status esticado como barra e metadados selecionáveis sem necessidade | Status ocupa apenas sua largura; valores comuns usam texto normal. Endereços de servidor e mensagens completas continuam copiáveis | `shared/widgets.dart`, `app/details.dart`, `students_page.dart` |
| Arquivo exibindo documentos de todos os níveis na raiz | Abertura de pasta mostra filhos diretos. Busca na raiz encontra documentos com seu caminho. Breadcrumbs clicáveis, alinhados à esquerda quando curtos e roláveis quando longos, e “subir uma pasta” | `features/documents/archive_page.dart`, `folder_breadcrumbs.dart` |
| Seleção altera largura da lista | Área de detalhes fica reservada nas páginas que usam o painel; selecionar ou fechar o item não redimensiona o conteúdo. Em telas menores, detalhes usam drawer | `app/workspace.dart` |
| Redimensionamento recria a página e perde a aba | Área principal mantém identidade ao trocar sidebar por drawer; regressão confere o mesmo estado da pasta antes/depois da redução de largura | `app/workspace.dart`, `test/school_journey_test.dart` |
| Corpo se move durante operações | Botões conservam rótulo e dimensões durante o carregamento; spinner ocupa a mesma área. Progresso permanece no espaço já reservado | `shared/widgets.dart`, formulários |
| Snackbar intrusivo | Removido. Avisos são consultados no ícone Atividade do topo, sem faixa fixa ou espaço dedicado no corpo. Erros de formulário continuam locais | `shared/operation_status.dart` |
| Divisores inconsistentes em escala fracionária | Linhas decorativas usam traço fino em espaço de layout constante; o tratamento fica restrito às linhas, preservando o antialiasing de texto e ícones | `shared/widgets.dart` |
| LAN e estado do servidor pouco claros | Escuta padrão `0.0.0.0`, endereços reais no status, opção explícita de loopback, erros de conexão mais compreensíveis e localização do executável em build de desenvolvimento | servidor CLI, `launcher_io.dart`, `shared/api.dart` |

A reserva de detalhes não cria um rodapé de mensagens. Alterar o tamanho da janela, recolher a navegação por comando ou arrastar o divisor são mudanças explícitas de layout. Seleção, aviso e carregamento não devem produzir esse efeito.

Não houve alteração estrutural no banco, aumento de schemaVersion, inclusão de dados fictícios na instalação normal ou substituição de operações reais por mocks.

## Diagnóstico após a base visual

### 1. Renderização: ainda precisa de validação no desktop de uso

O divisor anterior alterava sua dimensão lógica conforme o DPR; havia também contornos redundantes e rótulos pequenos em abas. Esses pontos foram tratados. Não há evidência suficiente para atribuir todos os serrilhados ao mesmo motivo, nem para afirmar que uma troca de engine resolveria o problema.

Próxima verificação: registrar SO, resolução, escala do sistema, DPR informado pelo Flutter e backend gráfico; comparar capturas no tamanho nativo a 100%, 125%, 150% e 200%, incluindo mudança entre monitores. Separar texto, ícones, bordas, SVG, fotos e PDF. Comparar renderer somente se existir falha reproduzível. Não aplicar escala global à árvore nem desativar antialiasing de fontes. Referências: [DPR do Flutter](https://api.flutter.dev/flutter/dart-ui/FlutterView/devicePixelRatio.html), [traço fino](https://api.flutter.dev/flutter/dart-ui/Paint/strokeWidth.html), [Impeller](https://docs.flutter.dev/perf/impeller) e [DPI no Windows](https://learn.microsoft.com/en-us/windows/win32/hidpi/high-dpi-desktop-application-development-on-windows).

### 2. Navegação ainda depende demais de telas e modais

`Workspace.go` reinicia pesquisa e filtro; voltar de um cadastro não recompõe necessariamente a posição da lista. `dataProvider` consulta pastas, documentos, pedidos, fila, alunos, turmas, cursos e modelos em conjunto. Uma atualização global pode provocar reconstruções e consultas desnecessárias. Isso é uma hipótese de custo a medir, não um benchmark de lentidão.

Separar estado de localização (URL), estado da lista (filtro, ordenação, rolagem) e estado do item (seleção/edição). Atualizar somente os recursos alterados. Preservar as regras de acesso do servidor.

### 3. Pasta do aluno precisa ser o centro da tarefa

O dossiê já reúne pessoa, documentos, matrícula, pedidos e resultados. Ainda é preciso reduzir a procura entre abas: mostrar pendências acionáveis e levar diretamente ao campo ou documento que precisa de correção. Ao cadastrar a partir de uma turma, levar o contexto da turma ao formulário e confirmar a oferta antes de salvar; não escolher uma turma arbitrária sem deixar isso evidente.

O arquivo administrativo é uma área de trabalho distinta. Não criar árvores por tipo documental dentro de cada aluno. Modelos devem definir exigências, não espalhar arquivos em estruturas fixas.

### 4. Formulários: geometria corrigida, interação ainda desigual

Há campos Forui e controles Material, validações locais e mensagens gerais, campos extensos e salvamento com comportamentos diferentes. As datas agora recebem máscara de digitação, mas a identificação desses campos ainda depende do rótulo; a próxima refatoração deve tornar esse contrato explícito. Alguns erros ainda aparecem apenas depois de enviar. O endereço continua em texto para manter compatibilidade: seleção de município não equivale a um cadastro normalizado de endereço.

Próximo passo: contratos explícitos para data/hora/número, preservando a máscara de data sem menus solicitada pelo usuário; erros associados ao controle e resumo com foco no primeiro erro; preservar entradas após falha. Ampliar o modo de leitura para outras informações conhecidas, oferecendo alteração somente onde existe uma escolha legítima. Não transformar toda informação estática em dropdown. Evitar criar um gerador genérico de formulários.

### 5. Horários: backend existe; apresentação e diagnóstico são insuficientes

`academics.dart` já valida sobreposição de turma, professor e sala, intervalo e vigência, em transação. A interface de `schedule_panel.dart` mostra uma lista por dia; o erro 409 identifica conflito genericamente. O maior ganho seguinte é uma visão semanal com contexto e resolução, não reimplementar essa regra no cliente.

A tabela deve considerar minutos reais de início/fim, intervalos e durações variáveis. Não presumir aulas fixas de 45 minutos ou currículo igual em todas as fases. Vigência e fase precisam ficar visíveis.

### 6. Diário e notas ainda exigem muita navegação

`GradeForm` repete blocos por aluno. Uma turma grande vira um formulário vertical longo. O diário alterna lista, edição e publicação, mas a situação do trabalho pode ficar distante da ação principal. O boletim é um extrato publicado de acompanhamento; fechamento e aprovação institucional continuam fora deste recorte.

Priorizar tabela de lançamento com aluno identificável, navegação por teclado, estados explícitos e salvamento consistente. Pendente, ausente, dispensada e nota zero permanecem distintos. A publicação continua uma ação revisada e autorizada, com possibilidade de correção registrada.

### 7. Solicitações precisam orientar o próximo atendimento

“Solicitações” e “Atendimento” representam perspectivas diferentes. Antes de fundir telas, identificar o que cada perfil faz: abrir, responder pendência, iniciar, encaminhar e concluir. Uma fila deve priorizar a próxima ação, mostrar atualização e separar pendência do solicitante de espera pelo setor. O histórico deve permanecer acessível sem repetir a descrição completa em diversos lugares.

## Sequência proposta para a próxima etapa — ainda não implementada

| Ordem | Entrega | Refatoração concreta | Critério de aceitação |
|---|---|---|---|
| 1 — P0 | Estabilidade de navegação | Preservar filtros/posição por rota; separar providers de lista e detalhe; invalidar só o recurso alterado | Abrir, editar e voltar ao aluno conserva filtro, ordem e rolagem; falha da fila não bloqueia documentos |
| 2 — P0 | Dossiê com tarefas pendentes | Resumo com pendências acionáveis; abrir editor/importação no contexto correto; turma de origem levada ao cadastro | Partindo da turma, cadastrar aluno e corrigir documento sem repetir curso/turma ou procurar outra tela |
| 3 — P0 | Formulários consistentes | Consolidar data/hora/número e erros por campo; rever obrigatoriedade e defaults; remover dependência do texto do label | Envio inválido foca o primeiro erro, explica a correção e preserva tudo que foi digitado; teste com teclado e texto ampliado |
| 4 — P1 | Horário semanal em tabela | Extrair apresentação semanal de `schedule_panel.dart`; colunas por dia, eixo de horário, fase/vigência fixas; seleção abre detalhe | Comparar semana sem percorrer sete listas; disciplinas longas e aulas com durações diferentes continuam legíveis |
| 5 — P1 | Conflito com resolução | API retorna categoria/intervalo conflitante permitido ao perfil; prévia antes de salvar e revalidação transacional na gravação | Destacar o choque e informar o que mudar; dois clientes concorrentes não conseguem reservar o mesmo recurso |
| 6 — P1 | Notas em tabela | Extrair lançamento de `GradeForm`; cabeçalho contextual, coluna de aluno estável, teclado e feedback por linha/lote | Lançar uma turma sem abrir um formulário por aluno; zero não vira ausência; falha não apaga rascunho |
| 7 — P1 | Rotina do diário | Estado do trabalho junto do título; conteúdo/frequência na mesma tarefa; revisão e publicação com resumo | Registrar uma aula, conferir frequência e enviar para revisão sem perder turma/componente |
| 8 — P1 | Arquivo com navegação completa | Ordenação, escopo de busca explícito, restauração da posição, seleção e caminhos no seletor de destino; atalhos subir/voltar | Importar, mover e reencontrar um arquivo sem confundir dossiê de aluno com arquivo administrativo |
| 9 — P1 | Fila de solicitações orientada à ação | Rever sobreposição entre pedidos próprios e fila do setor; filtros persistentes; histórico mais compacto | Aluno encontra pendência; setor encontra pedido atendível; todos conseguem identificar a última resposta |
| 10 — P2 | Componentização final e acessibilidade | Extrair shell de `Workspace`, dividir diálogos por responsabilidade, consolidar cabeçalhos; foco, atalhos e leitor de tela | Sem dependência circular de UI; nomes longos, janela estreita e texto ampliado funcionam nos dois temas |

Executar nessa ordem, em entregas pequenas. Cada uma precisa funcionar com a API existente ou com uma alteração de contrato justificada. Criar somente os componentes usados. Rever a lista depois da primeira sessão de uso com secretaria e professor.

### Especificação da grade de horários antes de codificar

- Contexto fixo: turma, curso, fase, vigência e semana/data de referência.
- Colunas de dias disponíveis; eixo temporal por horários reais. Intervalo é espaço sem aula, não uma disciplina fictícia.
- Célula: componente, docente e sala; seleção preserva escala e rolagem da tabela.
- Edição inicial por formulário contextual, sem drag-and-drop obrigatório.
- Conflito deve apontar recurso e intervalo; indicação visual acompanhada de texto, sem depender só de vermelho.
- Comparar vigências anteriores sem misturar horários que não coexistem. Mobile pode usar dia selecionado, com o mesmo contexto.
- Backend continua como autoridade; resultado de prévia pode ficar obsoleto antes do salvamento.

## Pesquisa e decisões

| Referência primária | Aplicação nesta revisão |
|---|---|
| [Discord — temas e aparência](https://support.discord.com/hc/en-us/articles/207260127-How-to-Change-Discord-Color-Themes-and-Customize-Appearance-Settings) | Referência de cinzas, branco e distinção de superfícies; os valores escolhidos para o aplicativo são próprios, não uma reprodução certificada do Discord |
| [Microsoft — title bar](https://learn.microsoft.com/en-us/windows/apps/design/basics/titlebar-design) | Reservar arraste e controles de janela, com menus de software separados do conteúdo escolar |
| [Nielsen — heurísticas](https://www.nngroup.com/articles/ten-usability-heuristics/) | Reconhecimento, consistência, prevenção de erro, retorno compreensível e redução de informação concorrente |
| [Fluent 2 — Tablist](https://fluent2.microsoft.design/components/web/react/core/tablist/usage) | Abas textuais para categorias relacionadas; não confundir navegação com botão de executar ação |
| [W3C APG — Tabs](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/) | Seleção identificável e interação por teclado; conservar semântica do componente nativo |
| [Flutter — TabBar](https://api.flutter.dev/flutter/material/TabBar-class.html) | Reutilizar o controle existente em vez de construir abas com chips |
| [W3C — rótulos](https://www.w3.org/WAI/tutorials/forms/labels/) | Rótulo legível e persistente; placeholder complementa, não identifica sozinho |
| [GOV.UK — text input](https://design-system.service.gov.uk/components/text-input/) | Separar rótulo, exemplo e controle; reduzir instruções espalhadas |
| [GOV.UK — validação](https://design-system.service.gov.uk/patterns/validation/) | Próxima etapa de erros associados ao campo e recuperação preservando a entrada |
| [W3C — contraste de texto](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) | Teste numérico de contraste para texto normal e secundário nas regiões do tema |
| [W3C — contraste não textual](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html) | Revisar foco e estados dos controles; não tratar divisor decorativo como único identificador de interação |
| [Carbon — breadcrumbs](https://www.carbondesignsystem.com/building-blocks/core/components/breadcrumb/guidelines) | Caminho navegável, com ancestral acionável e localização atual distinta |
| [Carbon — data table](https://www.carbondesignsystem.com/building-blocks/core/components/data-table/guidelines) | Próxima etapa de tabelas de notas e consultas com cabeçalho e ações contextualizadas |

As recomendações são adaptadas ao Flutter e ao domínio escolar. Uma referência visual não comprova acessibilidade, desempenho nem usabilidade do produto inteiro. A validação com pessoas e equipamentos reais continua necessária.


## Verificações executadas nesta entrega

- `dart format --output=none --set-exit-if-changed`: 73 arquivos, nenhuma alteração pendente de formatação; `dart analyze` do servidor e `flutter analyze` do cliente sem problemas.
- Servidor: 28 testes aprovados, incluindo SQLite/arquivos reais, permissões, matrícula, diário, notas, justificativas, conflitos, solicitações e launcher.
- Cliente: 30 casos verificados. A suíte aprovou 29; a jornada restante revelou um clique do teste no breadcrumb atrás do diálogo. O seletor foi restrito ao diálogo e a jornada foi reexecutada inteira com sucesso. Ela cobre cadastro, matrícula, publicação, pedido do aluno, atendimento e criação/movimentação/renomeação/exclusão de pastas. Não foram suprimidas as asserções de comportamento.
- Regressões específicas: menus exclusivos, ausência de Snackbar/espaço de aviso, geometria do botão ocupado, cabeçalho contínuo, seleção conhecida, máscara/colagem/Backspace de datas, contraste, divisor em DPR 1/1,25/1,5/2 e preservação do estado ao reduzir a janela.
- Builds de servidor Dart, Linux release, Web release e Android debug concluídos. Assinatura do APK verificada; pacote Linux contém o aplicativo, servidor e biblioteca nativa do SQLite. Checksums em `dist/SHA256SUMS.txt`.
- Servidor compilado: instalação vazia, autenticação, modelo, curso, turma, matrícula, PDF/upload/download, Web, trava de instância, encerramento por EOF e persistência após reinício aprovados em diretório temporário.
- `/health` respondeu por loopback e pelo IP LAN desta máquina, com escuta `0.0.0.0`. Isso não substitui um teste a partir de outro aparelho ou de outra rede.
- Executável Linux permaneceu aberto durante a checagem de inicialização com preferências isoladas, sem exceções Dart/Overlay registradas. GTK emitiu avisos de acessibilidade/cursor do ambiente. Capturas de layout claro, escuro e estreito foram inspecionadas.

Android físico/emulador e Windows não foram executados. O APK é debug, não uma distribuição de produção; o `.exe` depende do runner Windows existente. A renderização ainda precisa da comparação no monitor/escala de uso descrita acima. A grade semanal, a tabela de notas e as refatorações de fluxo permanecem na sequência proposta, sem controles simulados nesta entrega.
