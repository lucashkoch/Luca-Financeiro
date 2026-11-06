# Luca — Assistente Financeiro

O Luca é um aplicativo para organizar as finanças pessoais. Nele você pode registrar receitas, despesas e transferências, acompanhar contas e cartões, criar metas e consultar relatórios.

Os lançamentos podem ser feitos pelo painel no navegador ou por uma conversa com o bot do Telegram. O assistente entende mensagens em português e mostra uma prévia para você conferir antes de salvar.

**Versão atual:** 1.6.0  
**Requisitos:** Windows 10 ou 11 e Python 3.11 ou superior  
**Licença:** MIT

## O que o Luca oferece

- Cadastro de contas, carteiras e cartões.
- Registro de receitas, despesas, depósitos, compras parceladas e transferências.
- Categorias personalizadas, limites mensais, metas e lançamentos recorrentes, que podem ser editados depois do cadastro.
- Definição de conta e forma de pagamento padrão para novos lançamentos.
- Controle de valores a pagar e a receber de outras pessoas, com resumo por pessoa e opção de imprimir os compromissos.
- Acompanhamento manual de economias e investimentos.
- Consultas por período, conta, categoria e forma de pagamento.
- Importação e exportação de lançamentos em CSV e backup dos dados.

O Luca não acessa automaticamente suas contas bancárias, não faz pagamentos e não consulta cotações de investimentos. Os saldos e movimentações são informados por você.

## Assistente e Telegram

Você pode escrever de forma direta, por exemplo:

- `Gastei 45,90 no almoço pelo Nubank no débito.`
- `Recebi 2.400 de salário na Caixa.`
- `Transferi 300 da Nubank para a conta poupança.`
- `Paguei 120 de internet ontem no Pix.`

O interpretador tenta identificar o tipo de movimentação, valor, data, descrição, categoria, conta, forma de pagamento e parcelas. Quando falta informação ou a frase permite mais de uma interpretação, o Luca pode pedir que você esclareça.

Antes de gravar uma movimentação, o sistema apresenta uma prévia com as opções **Confirmar** e **Cancelar**. O dicionário de expressões fica em [`app/financial_language_pt_br.json`](app/financial_language_pt_br.json), separado do código principal. Há exemplos adicionais em [`docs/catalogo-de-frases.md`](docs/catalogo-de-frases.md).

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

O Luca usa long polling, então a instalação local não precisa de webhook nem de uma porta pública. O computador precisa permanecer ligado, conectado à internet e com o serviço em execução para o bot responder.

### Mensagens enviadas enquanto o Luca está offline

O Telegram mantém atualizações pendentes por até 24 horas. Quando o Luca volta a funcionar, ele busca essas mensagens e as grava primeiro em uma fila persistente no banco central (`data/luca-users.db`). Depois, processa a fila em ordem. Assim, uma queda de energia durante o processamento não apaga uma mensagem que já foi salva localmente.

- Mensagens de texto recuperadas, completas e interpretadas com alta confiança são registradas automaticamente no modo `mixed`.
- Mensagens ambíguas, comandos que alteram cadastros e áudios continuam exigindo confirmação.
- Confirmações de mensagens recuperadas ficam válidas por 7 dias.
- `/fila` mostra o que está aguardando ou falhou; `/reprocessar` tenta novamente mensagens que terminaram com erro.
- A fila local só pode guardar mensagens depois que o Luca consegue recebê-las do Telegram. Se a instalação ficar offline por mais de 24 horas, o Telegram pode descartar atualizações antigas antes que o Luca consiga buscá-las.

As opções ficam no `.env`: `TELEGRAM_OFFLINE_THRESHOLD_SECONDS` (padrão 120) e `TELEGRAM_RECOVERED_TEXT_MODE` (`mixed` ou `confirm`). Consulte [`docs/telegram-offline-queue.md`](docs/telegram-offline-queue.md) para detalhes e limitações.

## IA e mensagens de voz

A interpretação básica funciona com regras locais e com o dicionário do projeto. O Ollama é opcional e pode ajudar em mensagens que precisam de contexto adicional. Para ativá-lo, instale o Ollama, execute `instalar_ollama.bat` e ajuste `OLLAMA_ENABLED=1` no `.env`.

A transcrição de mensagens de voz também é opcional. Execute `instalar_audio.bat`; na primeira utilização, o Luca baixa o modelo Whisper configurado. A transcrição é feita no computador. O áudio, porém, chega primeiro pela infraestrutura do Telegram.

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
5. Execute `iniciar.bat` na nova pasta e confira seus dados antes de remover a instalação antiga.

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
