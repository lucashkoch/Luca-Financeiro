# Luca — Assistente Financeiro

<p align="center"><img src="branding/luca-logo-original.png" alt="Logo Luca" width="260"></p>

O Luca é um aplicativo para organizar as finanças pessoais. Nele você pode registrar receitas, despesas e transferências, acompanhar contas e cartões, criar metas e consultar relatórios.

Os lançamentos podem ser feitos pelo painel no navegador ou por uma conversa com o bot do Telegram. O assistente entende mensagens em português e mostra uma prévia para você conferir antes de salvar.

**Versão atual:** 1.7.8  

### Novidades da versão 1.7.7

Revisão geral de segurança e robustez: limite de tentativas de login, troca de senha pelo painel, desativação de perfis pelo administrador, backup automático diário em `data/backups/`, cópia dos limites mensais do mês anterior e correções em convites, vínculo do Telegram, recorrências, edição de lançamentos e importação de CSV. Não há migração de banco. Consulte `GUIA-LUCA-1.7.7.md` para a atualização.

### Novidades da versão 1.7.6

Baixas de compromissos em **Devendo / A receber** agora geram automaticamente a receita ou despesa correspondente em **Lançamentos**, na conta, forma de pagamento e data selecionadas. O histórico vincula os dois registros para evitar divergências e permite desfazer uma baixa junto com a movimentação correspondente; baixas antigas não geram lançamentos retroativos. A migração do banco é aditiva e ocorre na inicialização. Consulte `GUIA-LUCA-1.7.6.md` para a atualização.

### Versão anterior: 1.7.5

As faturas de cartão projetam todas as cobranças de recorrências ativas no crédito pelos próximos 12 ciclos, respeitando o dia de fechamento e vencimento. As previsões não criam lançamentos e desaparecem quando a ocorrência real é registrada. Pausar ou cancelar uma recorrência remove as próximas previsões; recorrências em Pix ou Débito ficam fora da fatura.

**Requisitos:** Windows 10 ou 11 e Python 3.11 ou superior  
**Licença:** MIT

## O que o Luca oferece

- Cadastro de contas, carteiras e cartões.
- Registro de receitas, despesas, depósitos, compras parceladas e transferências.
- Categorias personalizadas, limites mensais, metas e lançamentos recorrentes gerados automaticamente quando vencem, com prevenção de duplicidade.
- Definição de conta e forma de pagamento padrão para novos lançamentos.
- Controle de valores a pagar e a receber de outras pessoas, com resumo por pessoa, compromissos detalhados e opção de imprimir; o Telegram permite cadastrar esses acertos por um fluxo guiado e confirmar antes de salvar.
- Acompanhamento manual de economias e investimentos.
- Consultas por período, conta, categoria e forma de pagamento, com filtros paginados no histórico.
- Importação e exportação de lançamentos em CSV, proteção contra reimportação do mesmo arquivo e backup dos dados.
- Divisão de uma movimentação entre categorias sem duplicar o efeito no saldo da conta.
- Histórico paginado, recorrências pausáveis e checklist de fechamento mensal.

O Luca não acessa automaticamente suas contas bancárias, não faz pagamentos e não consulta cotações de investimentos. Os saldos e movimentações são informados por você.

Os saldos bancários e o resultado realizado consideram movimentações com data até hoje. Receitas, despesas e transferências programadas para datas futuras não alteram o dinheiro disponível antes da data informada. Compras parceladas no crédito são tratadas como compromissos desde o cadastro: a parcela com data neste mês aparece em “Crédito deste mês” e as demais ficam em “Parcelas futuras”. Ao cadastrar uma compra parcelada, informe somente a quantidade total de parcelas e escolha se o valor digitado é o total da compra ou o valor de cada parcela. O Luca gera a sequência completa de 1/N até N/N. Grupos antigos que já tenham outra numeração são preservados e continuam editáveis sem pedir a próxima parcela ou a quantidade restante. Pagamentos registrados reduzem primeiro os valores mais antigos. O Luca permite configurar fechamento e vencimento do cartão vinculado a uma conta bancária e comparar uma fatura com o CSV do banco em uma prévia que não altera dados automaticamente. As recorrências ativas com forma de pagamento Crédito também são projetadas em cada ciclo dos próximos 12 meses; a previsão é somente leitura, sai quando o lançamento real correspondente aparece e deixa de ser gerada quando a regra é pausada ou desativada. Lançamentos comuns podem ser duplicados para abrir um novo formulário preenchido, com data de hoje e sem alterar o original; ao duplicar uma parcela, somente aquela parcela é copiada. Saldo inicial de fatura permanece como dívida, sem ser contabilizado como nova despesa por categoria. O resumo de cartões agrupa os valores pelo ciclo real de fechamento e vencimento, destacando fatura atual, próximas faturas e total comprometido.

## Assistente e Telegram

Além de receitas, despesas e transferências, o Telegram possui um fluxo específico para compromissos pessoais. Envie `/novoacerto` ou abra `/devendo` e toque em “Novo valor a receber” ou “Novo valor a pagar”. O bot pergunta o nome da pessoa, o valor e o motivo, permite incluir vencimento/lembrete e exibe uma prévia antes de gravar. Use `/devendo` para consultar valores pendentes; para registrar baixas, escreva “Rafael me pagou R$ 40” ou “Paguei R$ 50 para Rafael”. Cada pagamento/recebimento parcial ou total também gera automaticamente uma despesa/receita vinculada ao acerto, usando a conta padrão do perfil e uma forma de pagamento diferente de Crédito. No painel, você pode escolher a conta, a forma de pagamento e a data da movimentação. A criação automática pode ser desmarcada quando a entrada/saída já tiver sido lançada manualmente.

Você também pode escrever de forma direta, por exemplo:

- `Gastei 45,90 no almoço pelo Nubank no débito.`
- `Recebi 2.400 de salário na Caixa.`
- `Transferi 300 da Nubank para a conta poupança.`
- `Paguei 120 de internet ontem no Pix.`
- `Rafael me deve R$ 80 do jantar.`
- `Devo R$ 50 para Rafael pela pizza.`

O interpretador tenta identificar o tipo de movimentação, valor, data, descrição, categoria, conta, forma de pagamento e parcelas. Ele também consulta as categorias que você já usou para o mesmo estabelecimento. Quando você corrige uma categoria no painel ou na prévia do Telegram, o Luca aprende essa preferência para mensagens futuras do mesmo estabelecimento. Se o histórico estiver conflitante ou não houver correspondência segura, ele mantém a sugestão genérica para você revisar. Quando falta informação ou a frase permite mais de uma interpretação, o Luca pode pedir que você esclareça.

Antes de gravar uma movimentação, o sistema apresenta uma prévia com as opções **Confirmar**, **Cancelar** e **Editar**. Pelo Telegram, você pode corrigir valor, descrição, categoria, conta, forma de pagamento, data, parcelas e observações antes de confirmar. O dicionário de expressões fica em [`app/financial_language_pt_br.json`](app/financial_language_pt_br.json), separado do código principal. Há exemplos adicionais em [`docs/catalogo-de-frases.md`](docs/catalogo-de-frases.md).

O mesmo bot do Telegram pode atender mais de um perfil. Cada pessoa vincula sua própria conta por um código gerado no painel, e os dados financeiros ficam separados por usuário. Veja as instruções em [`docs/telegram-setup.md`](docs/telegram-setup.md).

## Instalação no Windows

Você precisa do Windows 10 ou 11, Python 3.11 ou superior e acesso à internet para instalar as dependências.

1. Baixe o projeto ou clone este repositório.
2. Extraia os arquivos em uma pasta permanente, por exemplo `C:\Luca`.
3. Execute `iniciar.bat`.
4. Na primeira execução, o script cria o ambiente virtual, instala as dependências e prepara o arquivo `.env` a partir de `.env.example`.
5. Abra [http://127.0.0.1:8000](http://127.0.0.1:8000) no navegador e crie o perfil administrador.

O banco de dados é criado na pasta `data/`. Guarde essa pasta e o arquivo `.env`: eles contêm os dados e as configurações da sua instalação.

## Configurar o Telegram

Para usar o bot, crie um bot com o [@BotFather](https://t.me/BotFather), informe o token em `TELEGRAM_BOT_TOKEN` no arquivo `.env` e siga o guia [`docs/telegram-setup.md`](docs/telegram-setup.md).

O Luca usa long polling, então a instalação local não precisa de webhook nem de uma porta pública. O computador precisa permanecer ligado, conectado à internet e com o serviço em execução para o bot responder. Na primeira inicialização, o Luca também envia a logo do projeto como foto de perfil do bot, usando `setMyProfilePhoto`. Essa sincronização acontece novamente apenas se a imagem mudar. Para desativá-la, defina `TELEGRAM_PROFILE_PHOTO_ENABLED=0` no `.env`.

### Mensagens enviadas enquanto o Luca está offline

O Telegram mantém atualizações pendentes por até 24 horas. Quando o Luca volta a funcionar, ele busca essas mensagens e as grava primeiro em uma fila persistente no banco central (`data/luca-users.db`). Depois, processa a fila em ordem. Assim, uma queda de energia durante o processamento não apaga uma mensagem que já foi salva localmente.

- Mensagens de texto recuperadas, completas e interpretadas com alta confiança são registradas automaticamente no modo `mixed`.
- Mensagens ambíguas, comandos que alteram cadastros e áudios continuam exigindo confirmação.
- Confirmações de mensagens recuperadas ficam válidas por 7 dias.
- `/fila` mostra o que está aguardando ou falhou; `/reprocessar` tenta novamente mensagens que terminaram com erro.
- O processamento de texto/comandos e o processamento de áudio usam workers separados. Um áudio lento para baixar ou transcrever não segura as mensagens de texto enviadas depois.
- A fila local só pode guardar mensagens depois que o Luca consegue recebê-las do Telegram. Se a instalação ficar offline por mais de 24 horas, o Telegram pode descartar atualizações antigas antes que o Luca consiga buscá-las.

As opções ficam no `.env`: `TELEGRAM_OFFLINE_THRESHOLD_SECONDS` (padrão 120) e `TELEGRAM_RECOVERED_TEXT_MODE` (`mixed` ou `confirm`). Consulte [`docs/telegram-offline-queue.md`](docs/telegram-offline-queue.md) para detalhes e limitações.

## IA e mensagens de voz

A interpretação básica funciona com regras locais e com o dicionário do projeto. O Ollama é opcional e pode ajudar em mensagens que precisam de contexto adicional. Para ativá-lo, instale o Ollama, execute `instalar_ollama.bat` e ajuste `OLLAMA_ENABLED=1` no `.env`.

A transcrição de mensagens de voz é opcional. Ao iniciar o serviço, o Luca verifica se `faster-whisper`, CTranslate2 e PyAV estão instalados e compatíveis. Se faltar algo, tenta instalar automaticamente usando o mesmo ambiente Python da aplicação. Se a instalação falhar por falta de conexão ou outro problema, o painel e o bot de texto continuam funcionando; a falha fica registrada em `logs/luca-service.log` e pode ser consultada em `/assistant/audio/status`.

O modelo Whisper configurado em `WHISPER_MODEL` não é baixado durante a inicialização para evitar uma espera longa. Ele é baixado automaticamente no primeiro áudio e fica em cache para os próximos usos. O arquivo `instalar_audio.bat` continua disponível para forçar uma verificação/reparação manual. A transcrição é feita no computador. O áudio, porém, chega primeiro pela infraestrutura do Telegram.

## Perfis e acesso de outras pessoas

Na primeira abertura, crie o perfil administrador. Depois, o administrador pode gerar convites para outras pessoas criarem seus próprios perfis. Cada perfil mantém seu banco financeiro separado.

Por padrão, o painel escuta somente em `127.0.0.1`, ou seja, fica acessível apenas no próprio computador. Para abrir o painel em outros dispositivos, é necessário hospedar a aplicação em um servidor e configurar HTTPS, armazenamento persistente, backups e controle de acesso. Não exponha o servidor local diretamente à internet.

Há uma orientação inicial em [`docs/hospedagem-servidor.md`](docs/hospedagem-servidor.md), incluindo o que muda ao manter a aplicação e os bancos em uma VPS.

## Atualizar o Luca

Antes de atualizar, faça uma cópia da pasta `data/` e do arquivo `.env`.

1. Pare o Luca.
2. Extraia a nova versão em outra pasta.
3. Copie o `.env` e a pasta `data/` da instalação anterior.
4. Não copie a pasta `.venv`; ela será recriada quando necessário.
5. Execute `iniciar.bat` na nova pasta e confira seus dados antes de remover a instalação antiga. O ambiente `.venv` será recriado, e o suporte de áudio será verificado/instalado automaticamente pelo serviço quando necessário.

As instruções específicas da versão ficam em [`docs/`](docs/). O histórico de mudanças está no [`CHANGELOG.md`](CHANGELOG.md).

## Desenvolvimento e testes

Para preparar um ambiente de desenvolvimento no Windows PowerShell:

```powershell
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m pytest -q
```

O projeto usa Python, FastAPI, SQLite, HTML, CSS e JavaScript. Os testes automatizados cobrem as regras financeiras, o interpretador, a interface e os fluxos do Telegram simulados. Eles não substituem testes com um bot real e uma instalação Windows conectada à internet.

## Privacidade e segurança

- Não coloque senhas bancárias, números completos de cartões ou códigos de autenticação no Luca.
- Mantenha o token do Telegram apenas no `.env` e nunca o publique no GitHub.
- Conversas com bots do Telegram não são chats secretos com criptografia ponta a ponta.
- Faça backups regulares da pasta `data/` e teste a restauração.
- Para acesso remoto ao painel, use HTTPS e mantenha a aplicação atualizada.

## Licença

Este projeto está disponível sob a licença MIT. Consulte o arquivo [`LICENSE`](LICENSE).
