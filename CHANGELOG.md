## 1.7.8 — edição do saldo inicial da conta

- **Corrigido:** ao editar uma conta, o saldo inicial não era salvo — a tela dizia "atualizado", mas o valor continuava o mesmo. O botão da conta (antes "Fatura") agora é **Editar** e permite alterar nome, saldo inicial e, se houver cartão, fechamento e vencimento.
- A API de edição de contas agora recusa campos desconhecidos com erro 422, em vez de responder sucesso sem salvar nada.
- **Aviso de saldo negativo em transferências:** a transferência continua sendo gravada, mas o Luca avisa quando a conta de origem fica negativa e orienta a conferir o saldo inicial.
- Alterar o saldo inicial muda o saldo atual na mesma proporção; os lançamentos existentes são mantidos.

## 1.7.7 — revisão geral: segurança, robustez e conveniências

### Correções

- **Convite não é mais "queimado" por um erro de cadastro.** Se a pessoa convidada errar (senha curta, e-mail já cadastrado), o convite de uso único volta a ficar disponível para uma nova tentativa.
- **Vincular o Telegram a partir de outra conta do Telegram** agora funciona. Antes, o Luca respondia "vinculado", mas mantinha o vínculo antigo.
- **Uma recorrência com problema não bloqueia mais as outras.** Se a forma de pagamento de uma recorrência fosse arquivada, nenhuma recorrência do perfil era gerada. Agora cada regra é processada isoladamente; a forma arquivada cai para o tipo equivalente e regras de contas arquivadas aguardam a restauração da conta.
- **Lançamento com forma de pagamento arquivada voltou a ser editável** (descrição, categoria, observações etc.). Só uma forma *recém-escolhida* precisa estar ativa.
- **Edição de lançamentos validada.** Valor, data, descrição, categoria e tipo inválidos retornam uma mensagem clara em vez de erro interno — uma data inválida gravada podia quebrar o resumo e as faturas. Trocar apenas o tipo da forma (ex.: Débito → Pix) atualiza também o vínculo da forma de pagamento.
- Uma parcela isolada não pode mais ser convertida em receita ou em forma diferente de Crédito, o que deixava o parcelamento inconsistente.
- **Importação de CSV** não falha mais com erro interno: linhas com valor ou data inválidos são apontadas pelo número da linha e nada é importado até o arquivo estar correto. Aceita datas `dd/mm/aaaa`, `receita`/`despesa` e formas em português (`débito`, `dinheiro`...). A exportação grava o valor exato em centavos.
- Configurações com identificadores inválidos e edição de compromissos com campos nulos retornam 422 em vez de erro interno. O envio de áudio pelo painel não carrega mais arquivos acima do limite na memória.

### Segurança

- **Limite de tentativas de login:** após 8 senhas erradas em 15 minutos para o mesmo e-mail e origem, novas tentativas são recusadas temporariamente. O tempo de resposta não revela mais se um e-mail possui cadastro.
- **Troca de senha** em Configurações → Senha de acesso. Os outros dispositivos conectados são desconectados.
- **Administradores podem desativar e reativar perfis** em Configurações → Usuários e convites. Os dados são preservados e o acesso é encerrado imediatamente. O último administrador ativo e o próprio usuário não podem ser desativados.
- Cabeçalhos `X-Content-Type-Options`, `X-Frame-Options` e `Referrer-Policy` em todas as respostas.

### Melhorias

- **Backup automático diário** de todos os perfis em `data/backups/`, mantendo os últimos 7 dias (`LUCA_BACKUP_KEEP`; `0` desativa).
- **Limites mensais: "Copiar do mês anterior"** repete os limites sem sobrescrever os que já existem no mês.
- **Fuso horário em servidores Linux:** defina `TZ=America/Sao_Paulo` no `.env` para que "hoje", vencimentos e recorrências sigam o seu calendário.
- **232 testes automatizados aprovados** (13 novos em `tests/test_hardening.py`).

## 1.7.6 — integração de acertos com lançamentos bancários

- Registrar um pagamento ou recebimento parcial/total em **Devendo / A receber** agora cria automaticamente a despesa/receita correspondente em **Lançamentos**.
- O painel permite escolher a conta, a forma de pagamento e a data efetiva da movimentação. Cartões de crédito e a forma Crédito são excluídos desse fluxo para que a baixa represente dinheiro recebido ou pago. A criação automática pode ser desmarcada quando a movimentação já foi lançada manualmente.
- A operação é atômica: a baixa e o lançamento são gravados juntos ou nenhum dos dois é persistido. O histórico vincula cada baixa a uma única movimentação.
- Pagamentos futuros são registrados com data futura e só afetam o saldo na data indicada, preservando o cálculo de saldo realizado.
- Lançamentos vinculados protegem valor, tipo, conta, forma de pagamento e data contra edição/exclusão direta. No histórico de acertos, a ação **Desfazer baixa** remove a baixa e sua movimentação vinculada em conjunto, reabrindo o saldo pendente.
- Telegram usa a conta padrão do perfil e confirma a criação do movimento; o painel permite selecionar uma conta específica.
- Migração aditiva adiciona `friend_settlements.transaction_id` e seu índice único parcial. Baixas antigas permanecem sem vínculo e não geram lançamentos retroativos, evitando duplicidades.

## 1.7.5 — projeção contínua de recorrências nas faturas

- Recorrências ativas com forma de pagamento Crédito agora são projetadas em todas as ocorrências dos próximos 12 ciclos de cada cartão, respeitando frequência semanal, mensal ou anual e os dias originais de ancoragem.
- A projeção é somente leitura: não avança a próxima data cadastrada e não cria lançamentos ou ocorrências no banco.
- A tela “Ver fatura” calcula todas as ocorrências da regra dentro do ciclo selecionado, mesmo quando a próxima data registrada está em um mês anterior.
- Quando existe um lançamento real/manual compatível por data, valor, forma de pagamento e descrição, ele substitui a previsão para evitar duplicidade.
- Pausar ou desativar uma recorrência remove as projeções futuras; alterar o valor atualiza apenas as próximas previsões, preservando lançamentos históricos. Recorrências em Pix/Débito não entram nas faturas.
- Pagamentos e estornos reduzem dívidas já lançadas, não previsões de cobranças que ainda não aconteceram.
- O resumo das contas mostra quantas parcelas e previsões recorrentes compõem cada ciclo, e informa que o total comprometido considera os próximos 12 ciclos projetados.
- **218 testes automatizados aprovados**, incluindo previsão de janeiro/2027 com R$ 347,33 em compras/parcelas + R$ 330,71 em recorrências = R$ 678,04.

## 1.7.4 — frases rápidas para acertos pelo Telegram

- Adicionadas as expressões “Cobrar R$ 80 do João”, “Cobrar 80 João”, “João me devendo R$ 80” e “Pagar R$ 50 para João”.
- Mantida a prévia com confirmação obrigatória antes de criar compromissos.
- Melhorada a extração do nome da pessoa quando o valor aparece antes ou depois do nome.
- Atualizados os exemplos de `/ajuda`, `/start`, versão do aplicativo e cache de arquivos estáticos.
- Nenhuma migração de banco de dados necessária.

## 1.7.3 — cadastro guiado de acertos pessoais pelo Telegram

- Adicionado o comando `/novoacerto` (também `/acerto` e `/novodevendo`) para cadastrar valores a receber ou a pagar por um fluxo guiado: direção, pessoa, valor/motivo e dados opcionais de vencimento/lembrete.
- O fluxo mostra uma prévia e exige confirmação antes de criar o compromisso. `/cancelar` encerra o assistente sem gravar dados; o estado temporário expira após 20 minutos e é armazenado isoladamente no banco de cada perfil.
- `/devendo` agora apresenta os compromissos abertos individualmente, com saldo pendente e vencimento, além de botões para iniciar um acerto a receber ou a pagar.
- O menu de comandos do Telegram inclui `novoacerto`; a ajuda documenta exemplos de criação e baixa de compromissos.
- O cadastro de acertos continua no livro auxiliar de pessoas (`friend_entries`/`friend_settlements`), sem alterar automaticamente saldos bancários ou classificar o mesmo valor como receita/despesa. Recebimentos e pagamentos parciais continuam com confirmação e validação de saldo.
- Adicionada tabela de estado temporário do assistente guiado por perfil, criada de forma aditiva e com expiração automática.
- **214 testes automatizados aprovados**, incluindo criação a receber/a pagar, confirmação, cancelamento, expiração do rascunho e validação de vencimento.
- **Testes automatizados específicos para os fluxos a receber, a pagar, confirmação, cancelamento e atalhos em `/devendo`.**

## 1.7.2 — aprendizagem de categorias e filtro por forma de pagamento

- O histórico financeiro agora oferece filtro por forma de pagamento, incluindo métodos personalizados cadastrados pelo usuário.
- Os endpoints de listagem simples e paginada aceitam `payment_method_id`; métodos padrão também encontram lançamentos legados sem referência de método, e a migração preenche as referências padrão ausentes.
- O assistente do painel e do Telegram consulta o histórico do próprio perfil por descrição de estabelecimento normalizada e sugere a categoria já utilizada anteriormente. A prévia informa quando a classificação veio do histórico.
- Categorias corrigidas pelo usuário no painel ou escolhidas manualmente na prévia do Telegram passam a ser preferências explícitas por estabelecimento, armazenadas no banco isolado daquele perfil.
- Categorias explicitamente indicadas na mensagem têm prioridade sobre a aprendizagem. Histórico ambíguo não é usado para adivinhar, e lançamentos divididos por categorias não contaminam a aprendizagem do estabelecimento.
- Adicionados índices para consultas do filtro de pagamento e para a leitura do histórico de classificação.
- Migração aditiva cria a tabela de preferências de categoria e preserva todos os lançamentos existentes.
- **208 testes automatizados aprovados.**

## 1.7.1 — parcelamentos simplificados

- Simplificado o cadastro de compras parceladas: o usuário informa apenas a quantidade total de parcelas e escolhe se o valor digitado representa o total da compra ou o valor de cada parcela.
- Novas compras parceladas sempre são geradas de 1/N até N/N. O formulário não exibe nem envia campos de próxima parcela ou parcelas restantes.
- O backend deixou de aceitar a criação manual de cronogramas parciais. O fluxo de criação é consistente no painel e nos lançamentos confirmados pelo Telegram.
- Grupos antigos que já estão gravados com numeração posterior (por exemplo, 5/12 a 12/12) não são renumerados. Ao editar um grupo legado, o Luca identifica a sequência existente pelo próprio histórico.
- O valor total é dividido em centavos de forma exata; o valor por parcela multiplica pela quantidade informada.
- A API também rejeita os campos antigos de próxima parcela e parcelas restantes para novos cadastros, em vez de criar um cronograma parcial por engano.
- Nenhuma migração de dados é necessária.
- **198 testes automatizados aprovados.**

## 1.7.0 — evolução da experiência e controle financeiro

- Histórico paginado com filtro por categoria e navegação entre páginas.
- Lançamentos podem ser divididos entre categorias sem alterar o movimento bancário; relatórios e limites consideram as partes.
- Recorrências podem ser pausadas e reativadas sem perder a configuração.
- Fechamento mensal com checklist e observações salvas por período.
- Formulário de lançamento mais enxuto: parcelamento e saldo inicial ficam em opções avançadas.
- Importação CSV protegida contra reimportação acidental do mesmo arquivo na mesma conta.
- Endpoints de detalhe e grupo de parcelas não dependem do limite das 1.000 movimentações mais recentes.
- Filtros por categoria e texto também encontram partes de lançamentos divididos.
- **196 testes automatizados aprovados.**
- Mantida a duplicação segura de lançamento e a compatibilidade com os perfis existentes.

## 1.6.16 — duplicação segura de lançamentos e revisão de simplicidade

- A lista de lançamentos oferece a ação **Duplicar**. Ela abre o formulário preenchido para revisão e grava uma nova movimentação somente após o usuário salvar.
- A cópia recebe a data de hoje por padrão, preserva descrição, valor, categoria, conta, forma de pagamento e observações, e nunca altera o original.
- Ao duplicar uma parcela, somente o valor daquela parcela é copiado como lançamento simples; o grupo original e as demais parcelas não são replicados. O usuário pode configurar um novo parcelamento antes de salvar.
- Saldos iniciais consolidados de fatura não oferecem a ação de duplicar, evitando transformar uma dívida inicial em uma compra nova acidentalmente.
- Removida do `.env.example` a opção `LUCA_ACCESS_PASSWORD`, que não era consumida pelo código e poderia sugerir uma camada de proteção que não existia. O login normal por perfil permanece inalterado.
- Incluído um relatório de revisão geral com recomendações para agrupar a navegação, simplificar formulários e manter integrações opcionais fora do fluxo financeiro principal. Nenhuma funcionalidade financeira existente foi removida.
- **186 testes automatizados aprovados.**

## 1.6.15 — recorrências visíveis no detalhe da fatura
- A tela “Ver fatura” inclui a próxima ocorrência das recorrências ativas com forma de pagamento Crédito quando a data cai dentro do ciclo selecionado.
- Recorrências previstas aparecem com a identificação “PREVISTO” e entram no total da fatura. Quando a ocorrência é gerada ou lançada manualmente no mesmo dia e valor, a previsão é removida para evitar duplicidade.
- A lista de recorrências passa a exibir a forma de pagamento, facilitando identificar quais regras devem compor o cartão.
- A fatura do Luca continua sendo uma previsão baseada nos registros; o valor oficial é o exibido pelo emissor e deve ser conciliado.

## 1.6.14 — resumo de crédito por ciclo de fatura
- A área Minhas contas substitui os indicadores confusos de dívida anterior e crédito por mês de calendário por Fatura atual, Próximas faturas e Total comprometido.
- Os valores passam a respeitar o dia de fechamento e o vencimento configurados em cada conta/cartão. Saldo inicial de fatura entra na fatura atual como valor consolidado.
- Próximas faturas são discriminadas por data de fechamento e vencimento. A próxima ocorrência de recorrências ativas no crédito também entra na previsão e é substituída pelo lançamento real quando gerada, sem duplicidade. Eventuais faturas anteriores não quitadas continuam no total comprometido e aparecem em um aviso explicativo, sem ocupar um indicador separado.
- A tela de detalhes da fatura inclui o saldo inicial consolidado; a prévia de conciliação também o considera no total do Luca sem tratá-lo como compra individual não conciliada.

## 1.6.13 — recorrências automáticas, parcelamentos restantes e conciliação de fatura

- Parcelamentos agora separam o total original do contrato, a próxima parcela efetiva e a quantidade de parcelas não pagas que serão cadastradas. A edição reconstrói apenas o cronograma restante, preservando o índice original da parcela.
- O formulário aceita tanto o valor total da compra quanto o valor de cada parcela. O modo de valor total distribui centavos pela quantidade original, sem dividir apenas pelo saldo restante.
- Recorrências são geradas automaticamente ao iniciar e verificadas a cada minuto. Uma tabela de ocorrências com unicidade por regra/data garante idempotência e permite recuperar vencimentos perdidos enquanto o app estava desligado. Regras mensais/anuais preservam o dia original mesmo após fevereiro ou meses curtos.
- Lançamentos legados com a descrição exata `Fatura atual`/`Saldo inicial de fatura`, no crédito e em `Dívidas e financiamentos`, são classificados como saldo inicial. Continuam na dívida do cartão, mas ficam fora das despesas de consumo e dos relatórios por categoria.
- Contas bancárias comuns aceitam dia de fechamento e vencimento do cartão vinculado. A tela de fatura exibe o ciclo configurado, incluindo o dia do fechamento anterior como início do período (ciclo 17 a 17).
- Adicionada prévia de conciliação do CSV Nubank (colunas `date`, `title`, `amount`) com correspondência por data/valor, identificação de divergências e atalhos para cadastro/conferência. A comparação é somente leitura e não importa nem exclui registros automaticamente.
- Guia de atualização documenta as sequências de parcelas que aparecem no CSV fornecido e reforça que grupos antigos não são reescritos automaticamente.
- **179 testes automatizados aprovados.**

## 1.6.12 — valor mensal das parcelas e composição correta do crédito futuro

- O campo de valor em novos parcelamentos passou a representar o **valor de cada parcela**. Exemplo: R$ 124,16 em 12 vezes gera 12 parcelas de R$ 124,16 (total de R$ 1.489,92). A tela mostra o total calculado antes de salvar.
- O interpretador de linguagem mantém a distinção: frases como “compra de R$ 1.500 em 5 parcelas” tratam o valor como total da compra; frases como “5 parcelas de R$ 300 cada” tratam o valor como parcela mensal.
- O resumo de crédito agora inclui compromissos parcelados futuros mesmo quando a primeira data de parcela ainda não chegou. A parcela com data no mês atual aparece em “Crédito deste mês”; meses seguintes aparecem em “Parcelas futuras”. Lançamentos futuros sem parcelamento continuam fora do saldo realizado.
- A edição de uma compra parcelada agora permite alterar a compra inteira de uma vez: valor por parcela, quantidade, descrição, categoria, conta, pagamento e data inicial. As linhas mensais são reconstruídas mantendo seus identificadores sempre que possível.
- Corrigido o caso de uma compra criada com valor mensal tratado como valor total e dividida indevidamente pela quantidade de parcelas. Compras antigas não são alteradas automaticamente; abra uma parcela do grupo, edite a compra inteira e informe o valor mensal correto.
- Adicionados testes para o exemplo Sócio Furacão (12x de R$ 124,16), data inicial futura no mês, distribuição de meses, atualização de grupo e FIFO de pagamentos.

## 1.6.11 — composição do crédito pendente

- A área “Minhas contas” agora separa o crédito pendente em meses anteriores em aberto, compras/parcelas com data neste mês, parcelas futuras e total restante.
- O total continua incluindo toda a dívida efetiva ainda não quitada, inclusive parcelas dos próximos meses de compras cujo primeiro vencimento já chegou. Compras com data futura que ainda não começaram não entram na dívida atual.
- Pagamentos de crédito e estornos reduzem os itens mais antigos primeiro (FIFO), para que a divisão por mês feche com o total restante.
- O resumo mostra a quantidade de parcelas futuras ainda pendentes e a quantidade de compras/parcelas com data no mês atual.
- A interface explica que a divisão utiliza as datas registradas nas compras/parcelas; não é uma fatura importada do emissor.
- Incluídos testes para parcelamentos entre meses, pagamentos parciais, alocação de pagamentos, cartões do modelo antigo e reconciliação entre os subtotais e a dívida total.

## 1.6.10 — interpretação de valores falados com centavos
- Corrige valores ditados como “40 reais, 25 centavos” e “40 reais e 25 centavos”, inclusive quando o Whisper usa vírgula como pausa.
- Reconhece centavos numéricos ou escritos por extenso e remove a expressão monetária completa da descrição.
- Mantém a prioridade de métodos de pagamento explicitamente mencionados na mensagem sobre a forma padrão cadastrada.

## 1.6.10 — saldos realizados até a data atual
- Saldos bancários e de cartões deixam de considerar lançamentos, transferências e pagamentos com data futura.
- Compras parceladas no crédito passam a compor a dívida total quando a primeira parcela chega à data de competência; as parcelas seguintes continuam no planejamento e nas faturas dos meses correspondentes.
- O resumo de crédito pendente desconsidera compras ainda não efetivadas e pagamentos futuros.
- Resultado do mês no painel, relatórios usados pelo painel, tendência e gastos dos limites mensais usam valores realizados até hoje.
- Liquidações de acertos entre pessoas com data futura não reduzem o saldo antes do dia informado. Esses valores também ficam reservados para evitar compromissos acima do total original.
- Relatórios mensais completos continuam podendo incluir movimentações futuras quando consultados sem `realized_until`, preservando a visão de planejamento.
- O assistente também usa valores realizados até hoje nas consultas de saldo e gastos por categoria.
- Contas com movimentações ou recorrências futuras não podem ser arquivadas até que esses registros sejam cancelados ou ajustados.
- 164 testes automatizados aprovados, incluindo salário futuro, transferências futuras, pagamentos de crédito agendados, parcelas e liquidações futuras de acertos.

## 1.6.8 — últimas movimentações sem lançamentos futuros
- O cartão "Últimas movimentações" no painel agora consulta somente transações com data até hoje.
- O limite de seis itens é aplicado depois do filtro de data, garantindo que lançamentos futuros não ocupem espaço no resumo.
- A tela completa de lançamentos continua permitindo consultar datas futuras, úteis para parcelas e registros programados.
- Nenhuma alteração no banco de dados ou migração necessária.
- Adicionado teste de regressão para o filtro da dashboard.

## 1.6.7 — identidade visual Luca no aplicativo e no Telegram

- A marca fornecida foi incorporada ao painel: ícone na navegação lateral, avatar da área “Falar com Luca”, tela de login e favicon.
- Os arquivos da marca foram incluídos em `app/static/` e `branding/`, com um JPG quadrado otimizado para a foto do bot.
- Na primeira conexão do bot, o Luca usa o método oficial `setMyProfilePhoto` da Bot API para enviar a foto de perfil. O envio é repetido somente se o arquivo da imagem mudar; um marcador local evita uploads em toda inicialização.
- A sincronização da foto é best-effort: se a API não aceitar a atualização ou a rede falhar, o painel e o bot continuam iniciando normalmente.
- `TELEGRAM_PROFILE_PHOTO_ENABLED=0` desativa a sincronização; `TELEGRAM_PROFILE_PHOTO_PATH` permite apontar para outra imagem JPG.
- O arquivo original da logo foi preservado em `branding/luca-logo-original.png`.

## 1.6.6 — nova prévia no fim da conversa após editar pelo Telegram

- Depois de corrigir qualquer campo de um lançamento pendente, o Luca envia uma **nova mensagem completa** com todos os dados atualizados e os botões Confirmar, Editar e Cancelar. O usuário não precisa voltar à mensagem antiga para encontrar o lançamento revisado.
- A prévia anterior permanece no histórico como referência, mas o Luca tenta remover seus botões antes de atualizar o identificador da prévia ativa. Assim, a ação mais recente fica sempre no fim da conversa e botões antigos deixam de ser usados por engano.
- Aplicado o mesmo comportamento ao editar por texto (valor, descrição, data, parcelas e observações) e ao escolher opções (categoria, conta e forma de pagamento).
- Removidas mensagens de confirmação redundantes que apareciam depois do cartão atualizado e empurravam a prévia para cima.
- Adicionados testes de regressão para confirmar que a mensagem mais recente contém o lançamento completo, os botões atuais, o novo `preview_message_id`, que a prévia anterior perde os botões e que nenhuma transação é criada antes da confirmação.
- **152 testes automatizados aprovados.**

## 1.6.5 — confirmação visível ao editar lançamentos pelo Telegram

- Depois de alterar valor, descrição, data, parcelas ou observações, o Luca continua atualizando a prévia original e agora também envia uma resposta explícita confirmando que a alteração foi aplicada.
- A mesma confirmação visível é enviada após escolher categoria, conta ou forma de pagamento nos botões de edição.
- A resposta deixa claro que a prévia foi atualizada e que o lançamento ainda precisa ser confirmado; nenhuma alteração é gravada nas tabelas financeiras nesta etapa.
- Adicionado teste integrado cobrindo o fluxo real: prévia → callback `editfield` → mensagem de texto `500` → atualização do payload → resposta de confirmação, sem criar uma transação antes de confirmar.

## 1.6.4 — isolamento do transporte de áudio e restauração do timeout

- Restaurado o timeout de leitura do método Telegram `getFile` para 30 segundos, igual ao comportamento anterior à v1.6.3. O timeout reduzido para 12 segundos foi removido porque gerava falhas desnecessárias em conexões mais lentas.
- Criado um pool HTTPX separado para `getFile` e download de mídia. O polling longo (`getUpdates`) e as mensagens de texto usam outro pool, evitando que áudio e long polling disputem as mesmas conexões.
- Mantidas três tentativas idempotentes de `getFile`; se todas falharem, a fila persistente agenda nova tentativa com backoff.
- O instalador automático de áudio continua limitado a faster-whisper/PyAV/CTranslate2 e não altera o transporte HTTP do Telegram.
- Adicionados testes para timeout de 30 segundos e isolamento entre o pool de áudio e o pool de polling.
- Sem alteração de esquema ou migração do banco de dados.

## 1.6.1 — preparação automática do áudio

## 1.6.3 — fila Telegram separada para texto e áudio

- Separados os workers da caixa de entrada: mensagens de texto, comandos e callbacks são processados independentemente dos áudios. Um `getFile` lento não bloqueia as mensagens digitadas que chegam depois.
- A fila agora registra o tipo de atualização (`general` ou `audio`) e migra as linhas existentes automaticamente. Cada worker processa sua própria fila persistente.
- Uma mensagem em espera de retentativa não bloqueia outros itens prontos do mesmo tipo; o Luca tenta o próximo item e volta ao anterior no horário programado.
- `getFile` usa timeout menor e retentativas controladas; download de mídia tem uma retentativa imediata, e falhas temporárias voltam à fila com espera progressiva.
- Os bancos de perfil fazem uma verificação idempotente das colunas de `pending_actions` antes de processar mensagens e callbacks. Isso corrige perfis restaurados ou antigos que ainda não tenham `source_update_id`, sem depender exclusivamente da migração geral na inicialização.
- Exceções no worker não encerram mais a thread de processamento; falhas ao atualizar o estado da fila são registradas e a lease é recuperada no reinício.
- Os logs de requisições HTTPX/HTTPcore deixaram de exibir URLs completas da Bot API, evitando que o token do bot apareça em logs normais.
- Testes para fila independente de texto/áudio, migração de `worker_kind`, auto-reparo da tabela de ações pendentes e timeout reduzido de `getFile`.
- **149 testes automatizados aprovados.**


- O serviço verifica automaticamente faster-whisper, CTranslate2 e PyAV antes de iniciar a API, usando o mesmo interpretador Python da instalação.
- Quando os pacotes de áudio estão ausentes ou incompatíveis, o serviço instala as dependências de `requirements-audio.txt`; PyAV permanece fixado em `>=11,<19` para evitar a incompatibilidade conhecida com faster-whisper.
- A preparação é executada também pela inicialização automática do Windows e por `iniciar_servico.bat`, pois todos iniciam `app.service`.
- Se a instalação falhar por rede ou dependência nativa, o Luca continua disponível para o painel e mensagens de texto; o erro fica no log e no endpoint `/assistant/audio/status`.
- O modelo Whisper não é baixado no boot: o endpoint informa se ele já está em cache e o modelo é baixado no primeiro áudio.
- `instalar_audio.bat` foi simplificado e agora chama o mesmo verificador/reparador idempotente usado pelo serviço.
- Adicionados testes para dependências ausentes, PyAV incompatível, falha de pip, cache do modelo e inicialização do serviço.

## 1.6.0 — recuperação de mensagens do Telegram

- Criada uma caixa de entrada persistente no banco central de perfis. Cada atualização retornada por `getUpdates` é gravada junto com o próximo offset, na mesma transação, antes de o polling confirmar o lote ao Telegram.
- Adicionado processamento em segundo plano, separado do polling, com ordem FIFO, estado por mensagem, tentativas, espera progressiva e recuperação de itens que estavam em processamento quando o serviço foi encerrado.
- O identificador `update_id` impede que lotes repetidos criem mensagens duplicadas na fila; atualizações já processadas pela versão anterior são reconhecidas durante a migração.
- No modo misto, mensagens de texto recuperadas só são registradas automaticamente quando a interpretação está completa e tem alta confiança. Mensagens ambíguas, comandos que alteram cadastros e áudios continuam exigindo confirmação.
- Ações pendentes originadas de mensagens recuperadas expiram em 7 dias, em vez de 15 minutos. Várias confirmações podem coexistir sem substituir uma à outra.
- Criado o comando `/fila` para consultar a situação das mensagens e `/reprocessar` para reenfileirar falhas do próprio usuário.
- Downloads de áudio com falha transitória voltam à fila com retentativa; erros permanentes são mantidos em estado de falha até correção e reprocessamento.
- Adicionadas as configurações `TELEGRAM_OFFLINE_THRESHOLD_SECONDS` e `TELEGRAM_RECOVERED_TEXT_MODE`.
- Limitação documentada: o Telegram conserva atualizações pendentes por até 24 horas. A caixa local só protege mensagens depois que elas são recebidas e persistidas pelo Luca.
- Nenhum lançamento ou dado de usuário é removido pela migração; as novas tabelas são criadas automaticamente no banco central e nos bancos de perfil.
- Adicionados testes para lotes acima de 100 atualizações, retomada após reinício, deduplicação, retentativas e espera do worker sem uso excessivo de CPU. **131 testes automatizados aprovados.**

## 1.5.0 — edição de recorrências e resumo por pessoa

- A tela de recorrências agora permite editar descrição, tipo, valor, categoria, conta, forma de pagamento, frequência e próxima data.
- Criada a rota `PATCH /recurring/{id}` com validação de conta, forma de pagamento e compatibilidade de cartão.
- O fechamento de modais agora exige que o ponteiro comece e termine no fundo do modal; arrastar para selecionar texto em campos não fecha o formulário.
- A área Devendo / A receber ganhou filtro por pessoa e um resumo individual com valores a receber, a pagar, saldo líquido e compromissos cadastrados.
- O resumo individual pode ser impresso ou salvo como PDF pelo navegador.
- A lista por pessoa também pode ser aberta clicando no nome na seção Saldo por pessoa.
- Ajustes responsivos no cabeçalho da área Devendo / A receber para evitar sobreposição dos textos e botões.
- Nenhuma tabela ou dado financeiro existente foi removido; sem migração de banco.
- 118 testes automatizados aprovados.

## 1.4.8 — compatibilidade do Whisper com PyAV

- Corrigida a incompatibilidade de dependências que fazia a transcrição falhar depois de carregar e decodificar o áudio: faster-whisper 1.2.1 chama `av.open(..., metadata_errors=...)`, argumento removido no PyAV 19.
- `instalar_audio.bat` agora instala `av>=11,<19`, em vez de atualizar PyAV sem limite de versão.
- O instalador valida a versão principal do PyAV e encerra com erro explícito se detectar PyAV 19 ou superior.
- O runtime verifica a compatibilidade antes de iniciar a transcrição e orienta a executar o instalador atualizado.
- `/assistant/audio/status` passa a informar `decoder.faster_whisper_compatible` e `decoder.compatibility_warning`.
- Nenhuma alteração no banco de dados.
- Testes de regressão para PyAV 19 e para o pin do instalador.

## 1.4.7 — dicionário de linguagem financeira pt-BR

- Criado `app/financial_language_pt_br.json`, catálogo versionado e editável, separado das regras do parser.
- O dicionário reúne 28 categorias (incluindo Outros), 889 expressões/sinônimos únicos de categoria, 63 aliases de intenção e 42 aliases de forma de pagamento.
- O parser agora carrega os grupos de intenção, meios de pagamento e categorias do JSON, em vez de manter todos esses termos embutidos em um bloco Python.
- A categorização passou a pontuar frases específicas acima de palavras genéricas, mantendo prioridades contextuais para Educação, Cuidados pessoais, Vendas, Salário, Rendimentos e Benefícios.
- A correspondência reconhece acentos, equivalência entre hífen e espaço e plurais comuns do português brasileiro, sem aceitar correspondência por substring.
- Termos ambíguos como “cartão”, “99” e “Inter” não devem ser interpretados isoladamente; nomes de contas continuam sendo resolvidos pelas contas cadastradas em cada perfil.
- “Vale-refeição” recebido é classificado como Benefícios; quando usado para pagar uma refeição, permanece em Alimentação.
- Foram acrescentadas categorias padrão ao seletor, incluindo Veículo, Serviços, Impostos e taxas, Tarifas e encargos, Dívidas e financiamentos, Seguros, Vendas, Reembolsos, Benefícios, Rendimentos e Presentes e doações.
- O banco recebe as novas categorias por `INSERT OR IGNORE` durante a inicialização; nenhuma tabela ou lançamento existente é removido.
- Suíte automatizada: 108 testes aprovados.

# Changelog

## 1.6.2 — edição de lançamentos no Telegram e migração de perfis existentes

- As prévias de receitas e despesas enviadas pelo Telegram agora incluem a opção **Editar** antes de confirmar.
- O menu de edição permite corrigir valor, descrição, categoria, conta, forma de pagamento, data, parcelas e observações. Categorias, contas e formas de pagamento são selecionadas entre os cadastros ativos do próprio perfil.
- As alterações são aplicadas somente à prévia pendente; nenhum lançamento é gravado até a confirmação. O botão Confirmar continua utilizando os dados revisados.
- A prévia original é atualizada no Telegram após uma correção, mantendo os mesmos botões de confirmação e cancelamento.
- Corrigida a migração das bases de usuários existentes: na inicialização, o Luca executa `init_db()` em cada banco individual antes de iniciar o worker do Telegram. Isso adiciona `source_update_id` e demais colunas pendentes a perfis criados em versões anteriores.
- A edição em andamento pode ser cancelada com `/cancelar_edicao`; outros comandos continuam disponíveis sem perder o campo selecionado.
- Adicionados testes para edição de campos, seleção de categoria/conta/pagamento, confirmação dos dados alterados, cancelamento de edição e migração de bancos antigos.
- 145 testes automatizados aprovados.


## 1.4.9 — transporte Telegram resiliente

- Migradas chamadas da Bot API e downloads de mídia de `urllib` para `httpx.Client` persistente, com pool keep-alive compartilhado.
- Timeouts explícitos de conexão, leitura, escrita e pool.
- Retry/backoff limitado para métodos idempotentes; `sendMessage` não é repetido para evitar duplicidade.
- `getFile` possui até três tentativas em falhas transitórias.
- Download de áudio usa streaming; valida o tamanho anunciado e descarta arquivo parcial/truncado antes do Whisper.
- `/telegram/status` mantém métricas recentes de sucesso/falha de API e falhas no pipeline de áudio, sem expor o token.
- Sem migração ou alteração de esquema SQLite.
- 112 testes automatizados aprovados com transporte HTTP simulado.

## 1.4.6 — cadastro Telegram e tolerância a falhas de áudio

- Corrigidas descrições nas mensagens compactas do Telegram: remove palavras isoladas de forma de pagamento quando reconhecidas como metadados, sem remover o motivo do lançamento.
- A categoria final anexada à frase passa a ser separada da descrição somente quando existe uma finalidade independente; mantém "mercado"/"alimentação" quando esse é o único motivo informado.
- Normalização ortográfica básica para descrições comuns: água, almoço, café e ônibus.
- `getFile` passa a usar timeout ampliado e uma retentativa para falhas transitórias.
- Download de áudio passa a usar duas tentativas e timeout de 75 segundos, com mensagens específicas para falhas de rede e divergências de etapa.
- `_process_voice` informa se a falha ocorreu ao solicitar os metadados, baixar, decodificar/transcrever ou enviar a resposta; não cria ação pendente em caso de falha.
- Adicionados testes de regressão dos exemplos "Agua 7 credito alimentacao" e "Lanche 8,00 nubank credito", da prévia real do Telegram e dos timeouts.
- Nenhuma alteração no banco de dados.
- 101 testes automatizados aprovados.

## 1.4.5 — decodificação robusta de áudio

- Mensagens de voz do Telegram (.oga/.ogg/Opus) e gravações do navegador são decodificadas via PyAV e normalizadas para WAV PCM mono/16 kHz antes do Whisper.
- `instalar_audio.bat` instala e valida explicitamente faster-whisper, CTranslate2 e PyAV, exibindo as bibliotecas FFmpeg empacotadas.
- VAD desativado para preservar fala curta de mensagens financeiras de 2–5 segundos e reduzir dependências no caminho crítico.
- Status de áudio passa a mostrar separadamente a disponibilidade do decodificador PyAV, versões e bibliotecas FFmpeg.
- Erros de decode e de transcrição incluem causa técnica resumida no chat e traceback completo no log, sem gerar lançamento.
- Ampliada a lista de extensões reconhecidas no download para `.opus` e `.mp4`, além de `.oga`, `.ogg`, `.mp3`, `.m4a`, `.wav` e `.webm`.
- Nenhuma alteração no banco de dados.
- 94 testes automatizados aprovados.


## 1.4.4 — padrões e arquivo de contas

- Corrigido o preenchimento da conta padrão em novos lançamentos e recorrências; o primeiro banco/conta ativa passa a ser padrão quando ainda não há uma preferência válida.
- A migração corrige perfis antigos sem conta padrão e remove marcações duplicadas de padrão.
- Débito passa a ser a preferência inicial de pagamento quando ainda não existe uma escolha válida; cada perfil mantém uma única forma de pagamento padrão.
- A listagem de formas de pagamento diferencia formas disponíveis da única forma efetivamente configurada como padrão.
- Configurações reorganizadas com instruções mais claras e status da preferência selecionada.
- Nova seção Contas arquivadas, com restauração e exclusão permanente quando a conta não possui histórico vinculado.
- A exclusão permanente é bloqueada quando há lançamentos, transferências, recorrências ou pagamentos de crédito relacionados.
- Adicionadas rotas de restauração e exclusão permanente, contagem de registros relacionados e testes de regressão.
- 90 testes automatizados aprovados.

## 1.4.3 — correções de recorrências e preferências

- Corrigido o erro `Cannot read properties of null (reading 'closest')` ao salvar recorrências: o formulário agora é capturado antes das operações assíncronas.
- Corrigido o salvamento da forma de pagamento em recorrências, incluindo seu identificador; a geração das parcelas recorrentes preserva o meio selecionado.
- Adicionado cadastro de categorias por perfil, com arquivamento e reativação sem apagar o histórico de lançamentos.
- Categorias cadastradas ficam disponíveis em lançamentos, recorrências e limites mensais.
- Adicionada preferência de forma de pagamento padrão, ao lado da conta padrão.
- Novos lançamentos e novas recorrências já abrem com banco e forma de pagamento padrão selecionados.
- Corrigidas outras rotinas assíncronas de formulários que poderiam usar `event.currentTarget` depois do envio.
- Preferência de pagamento padrão aplicada também às interpretações sem forma de pagamento explícita no assistente web e no Telegram.
- 84 testes automatizados aprovados.

## 1.4.2 — 2026-11-04

### Interpretação de lançamentos
- Ampliação das formas naturais de expressar despesas, receitas, depósitos e transferências.
- Reconhecimento de valores falados por extenso, valores compactos (`2k`, `2,5k`), contos/pilas e centavos falados.
- Suporte adicional a datas relativas e escritas por extenso, além de variações de parcelamento (`5x`, `5 vezes`, `cinco parcelas`).
- Limpeza de descrições com remoção de datas, horários, palavras de pagamento e referências de conta.
- Nova categoria **Esportes** e regras contextuais para compras de tênis, atividades esportivas, Vendas e reembolsos.
- Transferências como “mandei/enviei da conta A para conta B” só são inferidas quando as duas contas estão reconhecidas.
- Corrigida colisão entre valores como `R$ 99` e o aplicativo 99; o número não classifica por si só como Transporte.

### Áudio e transcrição
- Modelo padrão alterado para `medium`, com contexto de português brasileiro e vocabulário financeiro.
- Cache do modelo Whisper carregado para evitar recarregar a rede neural a cada áudio.
- Instalador usa o interpretador exato da `.venv` usada pelo serviço e valida `faster-whisper` e `ctranslate2`.
- Novo diagnóstico autenticado em `/assistant/audio/status`, com caminho do Python, versões e erro de importação.
- Telegram diferencia biblioteca ausente de falha de DLL, dependência interna, download do modelo ou decodificação do áudio.

### Compatibilidade
- Sem alteração de schema e sem migração de banco.
- 75 testes automatizados aprovados nesta release.

## 1.4.1 — 2026-11-04

### Aparência e personalização
- Configurações por perfil para fonte (Inter, Manrope, Space Grotesk ou fonte do sistema).
- Escala geral da interface de 90%, 100%, 110% ou 120%.
- Densidade confortável ou compacta, persistida no banco privado de cada usuário.
- Prévia da tipografia antes de salvar as preferências.

### Visão geral
- Dois indicadores dedicados no dashboard: **A receber de pessoas** e **A pagar a pessoas**.
- Valores calculados a partir dos compromissos pendentes, já descontando quitações parciais.
- Compromissos entre pessoas não são somados ao saldo bancário nem ao patrimônio líquido.

### Economias e investimentos
- Nova área baseada nas contas existentes dos tipos Poupança e Investimento.
- Totalizadores separados de economias, investimentos e total combinado.
- Ações de aplicar/guardar e resgatar/retirar por transferência entre contas.
- Exibição das metas existentes para acompanhar objetivos.
- Nenhuma tabela financeira duplicada: saldos vêm do razão das contas.

### Compatibilidade e testes
- Nenhuma migração destrutiva ou alteração necessária nas tabelas de movimentações.
- 63 testes automatizados aprovados na suíte desta release.

## 1.4.9 — Transporte Telegram resiliente
- Substituído `urllib` por `httpx.Client` persistente com pool de conexões.
- Timeouts divididos em connect/read/write/pool.
- Retry com backoff para chamadas idempotentes e downloads de mídia.
- Download de voz em streaming sem desligar keep-alive.
- Diagnóstico expõe método, duração, tentativas e última falha sem revelar o token.
- Arquivos incompletos/truncados são descartados e baixados novamente; nenhum áudio parcial chega ao Whisper.
