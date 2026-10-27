# Referências para os fluxos escolares

Pesquisa consultada em 28/10/2026. A configuração do aplicativo continua vazia
na instalação normal. Fontes públicas não são cadastros operacionais.

## EETEPA Francisco Coimbra Lobato — Santarém

O [cronograma fornecido](<../Fase 2_2026 Matutino 2026_2.xlsx - Matutino Vigência 10.08.pdf>), “Fase 2/2026 Matutino 2026_2”, vigência de 10/08/2026,
mostra nove colunas de turmas/coortes:

| Coorte indicada | Cursos no horário matutino |
|---|---|
| 2024 | Agricultura |
| 2025 | Meio Ambiente, Logística, Informática e Alimentos |
| 2026 | Informática, Rede de Computadores, Logística e Segurança do Trabalho |

Isso evidencia turmas em continuidade, não o quadro completo de vagas de ingresso
em cada ano. Há aulas de 45 minutos, intervalo de 15 minutos, componentes gerais
e técnicos, distribuição por docente e mudanças de fase. Não inferir carga total
de matriz pela quantidade semanal de blocos. Não interpretar células “xxxxxxxx”
como disciplina ou falta. A indicação de sala também precisa de conferência:
há sala 1 atribuída a duas colunas, portanto não importar conflitos silenciosamente.

O [edital 008/2025, ingresso 2026](https://www.sectet.pa.gov.br/sites/default/files/EDITAL%20N%C2%BA%20008.2025%20-%20Processo%20de%20Sele%C3%A7%C3%A3o%20de%20Alunos%20%E2%80%93%20CETEC_DETEC_SECTET_03.12.2025_PAE_0.pdf),
quadro da página 23, relaciona Informática, Logística, Segurança do Trabalho,
Guia de Turismo, Secretaria Escolar, Alimentos e Rede de Computadores para a
Francisco Coimbra Lobato; distingue modalidade e turno. Guia de Turismo tem
observação de oferta na Escola Borari. A escola Antônio Batista Belo de Carvalho
aparece em quadro separado: não misturar suas ofertas com as da unidade principal.

A [notícia da feira de dezembro de 2025](https://www.agenciapara.com.br/noticia/73134/eetepa-santarem-reune-mais-de-100-projetos-na-vii-feira-cientifica-e-tecnologica)
cita Agricultura, Meio Ambiente, Turismo, Logística, Informática, Segurança do
Trabalho, Secretaria Escolar e Alimentos. É evidência de áreas participantes,
não comprovação de novas turmas, vagas ou matrizes homologadas em 2025.
Para 2024, a coorte de Agricultura é identificada no horário fornecido; não foi
confirmada uma relação completa de ingressos de 2024 para esta unidade.
Os editais/erratas de cada seleção continuam sendo a referência para ingresso.

O [catálogo publicado pela própria escola](https://sites.google.com/escola.seduc.pa.gov.br/eetepa-santarem/cursos-t%C3%A9cnicos)
distingue cursos e modalidades, mas não informa vigência anual.
A [página pública da equipe](https://sites.google.com/escola.seduc.pa.gov.br/eetepa-santarem/equipe-eetepa)
inclui docentes como Elias Sousa Leitão (Computação), Elisangela de Castro Coelho
(Letras/Psicologia), Jonathas de Franco Aguiar Gomes (Química) e Maria Rosenildes
Guimarães dos Santos (Biologia/Geografia). A página não garante lotação atual.
O horário usa nomes abreviados: não resolver identidades automaticamente.

Consequências: separar disciplina reutilizável, componente por curso/fase,
docente, diário de turma e horário com vigência. Cadastro docente complementa
uma conta de professor; nomes públicos não criam credenciais.

## Processos e dados

A [orientação de matrícula 2026 da Sectet](https://www.sectet.pa.gov.br/node/4701)
separa pré-inscrição e confirmação documental. O acompanhamento local não
substitui o portal oficial nem reserva vagas externas.

O [Inep](https://www.gov.br/inep/pt-br/areas-de-atuacao/pesquisas-estatisticas-e-indicadores/censo-escolar/)
relaciona fichas, diários, frequência e histórico como registros administrativos.
Seu [material de orientação](https://download.inep.gov.br/pesquisas_estatisticas_indicadores_educacionais/censo_escolar/orientacoes/matricula_inicial/caderno_de_conceitos_e_orientacoes_censo_escolar_2023.pdf)
fundamenta identificação conforme documento, nascimento, filiação e vínculos.
Isso não autoriza exigir todos os dados indiscriminadamente: modelos definem
as exigências, e dados não informados não são inferidos.

O [SUAP/IFRN](https://ajuda.suap.ifrn.edu.br/ensino/edu/)
distingue matriz, componentes, aulas, avaliações, etapas e regras de resultado.
As regras são institucionais; o aplicativo ainda não determina aprovação.
A [orientação de justificativa do IFRN](https://portal.ifrn.edu.br/campus/joaocamara/ensino/secretaria-academica/justificativa-de-faltas/)
distingue justificativa de abono. Essa distinção foi preservada no registro:
deferir não transforma falta em presença.

## Experiência de uso

A [W3C/WAI](https://www.w3.org/WAI/tutorials/forms/labels/)
recomenda rótulos visíveis e instruções para formulários. O aplicativo usa
rótulo e exemplo/formato, com ajuda complementar sob demanda, sem depender apenas de placeholder.
O horário fornecido inspira separação e alternância visual entre os dias.
Testes devem verificar contraste, escalas fracionárias, foco, rolagem estreita
e estabilidade de posição durante carregamentos.

## Refinamentos de formulários e navegação — 28/10/2026

A [W3C WAI](https://www.w3.org/WAI/tutorials/forms/instructions/) orienta a conservar
rótulos, indicar formatos e oferecer instruções acessíveis. Rótulos continuam
visíveis; exemplos são curtos e ajuda complementar abre pelo ícone “i”, inclusive
por toque e teclado. Placeholder não substitui rótulo ou validação.

O catálogo de municípios e UFs vem da [API oficial do IBGE](https://servicodados.ibge.gov.br/api/docs/localidades),
com origem e data de consulta no recurso. A busca roda no cliente, sem enviar
dados pessoais ao IBGE. Localidade no exterior exige escolha explícita; valores
antigos não são descartados. Período, etapa e tipos documentais podem reutilizar
configurações existentes.

O arquivo administrativo passou a abrir filhos diretos, mostrar o caminho e
permitir importar, mover e excluir pastas vazias. Dossiês de alunos mantêm uma
relação individual; adotar uma pasta administrativa exige raiz sem subpastas,
evita duplicação e passa a respeitar o acesso da secretaria pela pessoa vinculada.
