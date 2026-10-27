# Próximo ciclo

A referência funcional está em [spec.md](../spec.md), e a pesquisa em
[contexto-escolar.md](contexto-escolar.md). Evitar manter três especificações.

Antes de um piloto: validar matrizes, fases, calendário e regras pedagógicas com
a instituição. O boletim atual é um extrato de acompanhamento, com notas
publicadas e média normalizada ponderada; não decide aprovação.

Implementar recuperação, segunda chamada, conselho e fechamento somente após
definir escala, arredondamento, critérios, reabertura e responsabilidade. As correções atuais registram eventos; versões imutáveis dos valores e fechamento oficial ainda precisam ser definidos.
Adicionar importação revisada de cronogramas com mapeamento de disciplinas,
docentes e salas; não inferir identidade a partir de primeiros nomes.

Operação real requer HTTPS confiável, backup completo de SQLite e arquivos com
restauração testada, proteção do disco, recuperação administrativa, revisão de
permissões e verificação dos vínculos de responsáveis. A política de recriar
bancos incompatíveis é apenas de desenvolvimento e deve ser encerrada antes do
uso com registros que precisem ser conservados.

Validar uso diário com secretaria e docentes: tempo para localizar pendências,
cadastro de muitos cursos/fases, nomes longos, lançamento por teclado, leitor de
tela e correções sem perda de contexto. Instalar e testar o APK em dispositivo
Android e o bundle Windows em máquina Windows.
