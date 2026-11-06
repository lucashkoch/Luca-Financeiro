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
