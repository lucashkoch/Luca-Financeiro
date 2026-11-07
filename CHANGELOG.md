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
