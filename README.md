<div align="center">

# Luca — Assistente Financeiro

**Seu controle financeiro pessoal, privado e local.**

Organize contas, cartões, receitas, despesas, metas e valores entre amigos em um único painel. Os dados ficam em um banco SQLite no seu computador.

![Python](https://img.shields.io/badge/Python-3.11%2B-3776AB?logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/API-FastAPI-009688?logo=fastapi&logoColor=white)
![SQLite](https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Tests](https://img.shields.io/badge/tests-40%20passing-brightgreen)

</div>

---

## Sobre o projeto

O **Luca** é uma aplicação de organização financeira pessoal que roda localmente no Windows. A ideia é reunir o controle do dia a dia — contas, cartões, gastos, planejamento e acertos com amigos — em uma interface simples, sem depender de uma assinatura mensal ou de um banco de dados na nuvem.

A aplicação básica funciona sem IA. Recursos opcionais usam modelos locais pelo Ollama e transcrição local de áudio pelo faster-whisper.

> **Privacidade:** o Luca não acessa sua conta bancária, não realiza pagamentos e não sincroniza dados com instituições financeiras. Você informa os valores manualmente. O banco SQLite não é criptografado pelo aplicativo; proteja seu computador e seus backups.

## Funcionalidades

### Visão geral
- Saldo consolidado de contas e carteiras.
- Dívidas registradas nos cartões e patrimônio líquido estimado.
- Resultado mensal, movimentações recentes e principais categorias.

### Contas e cartões
- Quantas contas forem necessárias, com nomes livres (por exemplo: Nubank, Caixa, Conta da mãe e Carteira).
- Saldo inicial, saldo atualizado e seleção de conta padrão.
- Cartões de crédito com limite, dias de fechamento e vencimento.
- Faturas por mês e compras parceladas em até 36 vezes.
- Pagamento de fatura por transferência, sem contabilizar a quitação como uma segunda despesa.

### Lançamentos e planejamento
- Registro de receitas e despesas por conta, categoria, data e forma de pagamento.
- Edição, exclusão, busca e filtros de histórico.
- Transferências entre contas sem duplicar receitas ou despesas.
- Orçamentos mensais por categoria.
- Metas de economia com contribuições e retiradas.
- Recorrências semanais, mensais e anuais, geradas somente após ação explícita do usuário.

### Contas com amigos
- Registro de valores que você **tem a receber** e de valores que **precisa pagar** a amigos ou outras pessoas.
- Agrupamento automático dos registros pelo nome da pessoa.
- Total a receber, total a pagar e saldo líquido consolidado e por pessoa.
- Data de vencimento e data personalizada para lembrete.
- Pagamentos e recebimentos parciais ou totais, com histórico de quitações.
- Status de aberto, parcial, próximo do vencimento, atrasado e quitado.
- Lembretes dentro do Luca e notificações do navegador, quando autorizadas.

**Importante sobre o livro de amigos:** ele é separado do fluxo bancário. Registrar um pagamento nessa área reduz o valor pendente do compromisso, mas não altera automaticamente o saldo de uma conta nem os relatórios de receitas e despesas. Isso evita duplicidade e deixa explícito que o registro é um controle de acerto entre pessoas. Quando o dinheiro efetivamente entrar ou sair da sua conta, registre a movimentação financeira correspondente separadamente.

**Importante sobre lembretes:** eles aparecem no painel quando a data escolhida chega. As notificações do Windows/navegador dependem de permissão e de o Luca estar aberto no navegador. Nesta versão não existe um serviço em segundo plano que avise com o computador desligado ou com o navegador fechado.

### Assistente e áudio (opcionais)
- Entende entradas/receitas, depósitos, despesas e transferências entre contas em linguagem natural.
- Reconhece expressões como “depositei”, “fiz um depósito”, “entrada”, “recebi”, “caiu”, “gastei”, “paguei”, “comprei” e “transferi”.
- Associa nomes e variações comuns de contas cadastradas, por exemplo “conta mãe” para “Conta da mãe”.
- Não exige forma de pagamento para depósitos e receitas; em despesas, a forma pode ficar como “não informada” quando você não mencionar.
- Transferências pedem origem e destino e são confirmadas como transferência, sem virar receita ou despesa.
- Mostra uma prévia e exige confirmação antes de salvar qualquer lançamento.
- Consultas rápidas sobre saldos, gastos mensais e categorias.
- Ollama opcional para refinar descrição e categoria. O modelo não pode alterar valor, tipo de movimento, conta ou forma de pagamento identificados pelas regras validadas.
- Gravação no navegador e transcrição local com faster-whisper.

### Telegram (opcional)
- Integração com a Bot API oficial por long polling, sem domínio, webhook, túnel ou hospedagem pública.
- Acesso permitido somente ao ID numérico configurado, em conversa privada.
- Registros por texto ou áudio com prévia e confirmação por botões no chat.
- Comandos para saldo, contas, lembretes, ajuda, confirmar e cancelar.
- Lembretes de acertos com amigos enviados pelo bot.
- O bot continua funcionando sem Ollama; o modelo de linguagem é complementar e executado localmente.

### Dados e relatórios
- Banco SQLite local.
- Relatórios mensais e gráficos de receitas, despesas e categorias.
- Exportação e importação de lançamentos em CSV.
- Backup consistente do banco, mesmo com o Luca em execução.
- Migrações incrementais para preservar bancos anteriores.

## Tecnologias

| Tecnologia | Papel |
|---|---|
| Python 3.11+ | Backend e regras financeiras |
| FastAPI | API local e documentação interativa |
| SQLite | Armazenamento local |
| HTML, CSS e JavaScript | Interface web responsiva |
| Ollama (opcional) | Modelo de linguagem executado localmente |
| faster-whisper (opcional) | Transcrição local de áudio |
| pytest | Testes automatizados |

## Instalação no Windows

### Requisitos

- Windows 10 ou 11.
- Python 3.11 ou superior instalado e disponível no PATH (`Add Python to PATH`).
- Internet na primeira execução para instalar as dependências.

### Iniciar

1. Baixe o ZIP do repositório ou clone o projeto.
2. Extraia a pasta em um local permanente.
3. Execute `iniciar.bat`.
4. Na primeira inicialização, o script cria o ambiente virtual, instala as dependências e cria `.env` a partir de `.env.example`.
5. O painel será aberto em `http://127.0.0.1:8000`.

Para encerrar, volte à janela do terminal e pressione `Ctrl+C`.

A documentação interativa da API fica em `http://127.0.0.1:8000/docs`.

### Primeiro cadastro

1. Em **Minhas contas**, cadastre suas contas e carteiras com os saldos atuais.
2. Cadastre cartões de crédito separadamente, informando a dívida atual, limite e datas de fechamento/vencimento quando souber.
3. Em **Configurações**, escolha uma conta padrão para facilitar os lançamentos.
4. Em **Contas com amigos**, registre valores pendentes com a direção correta: a receber ou a pagar.
5. Faça alguns lançamentos de teste e confira os saldos antes de inserir todo seu histórico.

## Configuração opcional de IA local

1. Instale o Ollama para Windows: <https://ollama.com/download>.
2. Execute `instalar_ollama.bat` para baixar o modelo `qwen2.5:3b`.
3. Abra `.env` e altere `OLLAMA_ENABLED=0` para `OLLAMA_ENABLED=1`.
4. Reinicie o Luca.

O modelo pode ser alterado em `OLLAMA_MODEL`. O serviço local padrão é `http://127.0.0.1:11434`. A integração utiliza a API local do Ollama; consulte <https://docs.ollama.com/api/chat>.

A qualidade e a velocidade dependem do modelo, da memória e do processador disponíveis. O registro básico não depende do Ollama.

## Transcrição de áudio (opcional)

1. Inicie o Luca ao menos uma vez.
2. Execute `instalar_audio.bat`.
3. No painel, autorize o microfone para gravar; no Telegram, envie uma mensagem de voz.
4. Revise a transcrição e os dados interpretados antes de confirmar qualquer lançamento.

A primeira transcrição baixa o modelo configurado em `WHISPER_MODEL` (padrão `small`). Por padrão, a execução usa CPU e `int8`. O modelo Whisper roda localmente. Para mensagens de voz do Telegram, o arquivo é recebido pela Bot API e baixado temporariamente ao computador para transcrição.

## Configurar o Telegram (opcional)

Siga o guia completo em [`docs/telegram-setup.md`](docs/telegram-setup.md). Em resumo: crie um bot com [@BotFather](https://t.me/BotFather), coloque o token em `TELEGRAM_BOT_TOKEN` no `.env`, envie `/start` para descobrir seu ID, configure `TELEGRAM_ALLOWED_USER_ID` e reinicie o Luca. Sem o ID permitido, o bot não acessa dados financeiros.

A integração usa long polling com conexões HTTPS iniciadas pelo computador. O painel continua em `127.0.0.1`; não é necessário publicar uma porta na internet. O Bot API é disponibilizado pelo Telegram sem mensalidade de um provedor de bots, sujeito aos limites de uso da plataforma. Consulte [Telegram Bot API](https://core.telegram.org/bots/api).

**Privacidade:** os registros financeiros ficam no SQLite local, mas mensagens e áudios enviados ao bot passam pelos servidores do Telegram. Conversas com bots não são Secret Chats com criptografia ponta a ponta. Não envie senhas bancárias, códigos de autenticação ou dados completos de cartão.

## Deixar o Luca iniciar com o Windows

Depois de executar `iniciar.bat` uma vez e confirmar que o projeto está instalado, execute `instalar_inicio_automatico.bat`. O script registra uma tarefa no Agendador de Tarefas para iniciar o Luca em segundo plano quando seu usuário entrar no Windows. O serviço registra logs rotativos em `logs/luca-service.log`. Para desativar, execute `remover_inicio_automatico.bat`.

O painel fica disponível em `http://127.0.0.1:8000`; o navegador não precisa ficar aberto para o bot Telegram funcionar. O PC precisa estar ligado, conectado à internet e sem suspensão. A tela pode desligar sem encerrar o serviço. A tarefa inicia no logon do usuário, não antes da tela de login do Windows.

Para executar em primeiro plano e acompanhar o terminal, use `iniciar_servico.bat`.

## Configurações de ambiente

Copie `.env.example` para `.env` (o instalador faz isso automaticamente).

| Variável | Padrão | Descrição |
|---|---|---|
| `OLLAMA_ENABLED` | `0` | Ativa a IA local quando definido como `1` |
| `OLLAMA_URL` | `http://127.0.0.1:11434` | Endereço local do Ollama |
| `OLLAMA_MODEL` | `qwen2.5:3b` | Modelo instalado no Ollama |
| `WHISPER_MODEL` | `small` | Modelo de transcrição |
| `WHISPER_DEVICE` | `cpu` | Dispositivo para transcrição |
| `WHISPER_COMPUTE_TYPE` | `int8` | Tipo numérico usado pelo faster-whisper |
| `LUCA_ACCESS_PASSWORD` | vazio | Senha opcional do painel/API; usuário HTTP Basic: `luca` |
| `LUCA_DATABASE_PATH` | `data/luca.db` | Caminho alternativo para o banco SQLite |
| `TELEGRAM_BOT_TOKEN` | vazio | Token do bot criado no BotFather; mantenha em segredo |
| `TELEGRAM_ALLOWED_USER_ID` | vazio | ID numérico autorizado; obrigatório para acessar dados |
| `TELEGRAM_POLL_TIMEOUT` | `25` | Tempo máximo de long polling em segundos |
| `TELEGRAM_REMINDER_CHECK_SECONDS` | `60` | Intervalo de verificação de lembretes |
| `TELEGRAM_MAX_AUDIO_MB` | `20` | Tamanho máximo de áudio aceito (1 a 20 MB) |

A variável antiga `PIERRE_DATABASE_PATH` continua sendo aceita para facilitar a migração de instalações anteriores. Se `data/luca.db` ainda não existir e `data/pierre.db` existir, o Luca continuará utilizando o banco antigo para preservar os dados.

O arquivo `.env` nunca deve ser enviado ao GitHub.

## Área Contas com amigos — exemplo

Imagine que você pagou R$ 300,00 de hospedagem para um grupo e o Rafael precisa devolver a parte dele:

1. Abra **Contas com amigos → Novo registro**.
2. Pessoa: `Rafael`.
3. Tipo: `Tenho a receber`.
4. Descrição: `Parte da hospedagem`.
5. Valor: `300,00`.
6. Informe vencimento e lembrete, se desejar.

Quando Rafael devolver R$ 100,00, use **Registrar** e informe o valor recebido. O Luca passa a mostrar R$ 200,00 pendentes. Quando o restante for recebido, o compromisso fica como **Quitado** e o histórico permanece disponível.

O mesmo fluxo funciona para valores que você precisa pagar a outra pessoa.

## Backup, exportação e importação

- **Backup completo:** Configurações → Baixar backup completo. Guarde o `.db` em outro local seguro.
- **Exportar CSV:** Relatórios → Exportar CSV. O arquivo usa `;` como separador e UTF-8 com BOM para facilitar abertura no Excel em português.
- **Importar CSV:** Configurações → selecione um CSV exportado pelo Luca e a conta de destino. A importação cria novos lançamentos e não deduplica registros; faça um backup primeiro.

O banco padrão fica em `data/luca.db`. **Não apague a pasta `data`**: ela contém suas informações financeiras. O banco não deve ser compartilhado publicamente.

## Testes

No PowerShell, dentro da pasta do projeto:

```powershell
py -3.11 -m venv .venv
.venv\Scripts\activate
python -m pip install -r requirements.txt
python -m pytest -q
```

O GitHub Actions executa validação de sintaxe Python, JavaScript e os testes automaticamente a cada push e pull request.

Documentação adicional: [arquitetura](docs/architecture.md) · [contribuição](CONTRIBUTING.md) · [segurança](SECURITY.md) · [guia de publicação](docs/github-publishing.md).

Para atualizar uma instalação anterior sem perder seus lançamentos, consulte [`docs/upgrading-to-v1.3.0.md`](docs/upgrading-to-v1.3.0.md).

## Publicar no seu GitHub

1. Crie um repositório vazio no GitHub com o nome `luca-assistente-financeiro` (não marque para criar README, licença ou `.gitignore`, pois esses arquivos já estão no projeto).
2. Extraia o projeto em uma pasta local e abra o PowerShell nela.
3. Antes de publicar, confira se `.env` e `data/*.db` não aparecem no status.
4. Execute:

```powershell
git init -b main
git add .
git status
git commit -m "feat: release Luca Assistente Financeiro 1.3.0"
git remote add origin https://github.com/SEU-USUARIO/luca-assistente-financeiro.git
git push -u origin main
```

Substitua `SEU-USUARIO` pelo seu usuário do GitHub. O `.gitignore` impede que banco, `.env`, ambiente virtual, backups e arquivos temporários sejam adicionados por padrão, mas sempre revise `git status` antes de confirmar o commit. Nunca coloque token de acesso do GitHub dentro de arquivos do projeto.

Sugestão de descrição do repositório: **Assistente financeiro pessoal local com contas, cartões, metas, relatórios e controle de valores a receber/pagar entre amigos.**

## Segurança e limitações

- O servidor inicia em `127.0.0.1`, acessível apenas no próprio computador.
- `LUCA_ACCESS_PASSWORD` ativa uma camada adicional de HTTP Basic. Não exponha o servidor diretamente à internet; essa senha não substitui HTTPS, proteção de rede ou uma implantação revisada.
- O arquivo SQLite não é criptografado pelo aplicativo.
- Não informe senhas bancárias, códigos de autenticação ou números completos de cartões.
- Não há Open Finance, sincronização bancária, conciliação automática ou execução de pagamentos.
- Os lembretes no painel dependem do Luca aberto. Os lembretes via Telegram exigem bot configurado, usuário autorizado, PC ligado e conexão com a internet; se o PC ficar desligado, os lembretes vencidos são verificados no próximo início.
- O token Telegram deve ficar apenas no `.env`, nunca no GitHub. O Luca não aceita mensagens de grupos nem de usuários diferentes do ID autorizado.
- Chats com bots no Telegram não são Secret Chats com criptografia ponta a ponta; mensagens e áudios são processados pela infraestrutura Telegram antes de chegarem ao computador.
- A identificação de valor, tipo de movimento, conta e forma de pagamento usa regras determinísticas para reduzir erros financeiros. O Ollama é complementar e só refina descrição/categoria. Confira sempre a prévia antes de confirmar; mensagens ambíguas ou sem conta identificável pedem esclarecimento.

## Estrutura do projeto

```text
luca-assistente-financeiro/
├── .github/                 # CI e modelos de issues
├── app/
│   ├── static/              # Interface web
│   ├── assistant.py         # Interpretação e transcrição
│   ├── database.py          # SQLite e migrações
│   ├── finance.py           # Regras e cálculos financeiros
│   ├── main.py              # API FastAPI e rotas
│   ├── service.py           # Execução em segundo plano e logs rotativos
│   └── telegram_bot.py      # Bot oficial Telegram por long polling
├── data/                    # Banco local (ignorado pelo Git)
├── docs/                    # Guias e documentação técnica
├── logs/                    # Logs locais (ignorado pelo Git)
├── scripts/                 # Instalação/remoção da tarefa do Windows
├── tests/                   # Testes automatizados
├── .env.example
├── iniciar.bat
├── instalar_inicio_automatico.bat
├── remover_inicio_automatico.bat
├── instalar_audio.bat
├── instalar_ollama.bat
├── LICENSE
├── pyproject.toml
└── requirements.txt
```

## Roadmap

- [x] Múltiplas contas e cartões.
- [x] Receitas, despesas, parcelamentos e transferências.
- [x] Orçamentos, metas e recorrências.
- [x] Livro de valores a receber/pagar com amigos.
- [x] Lembretes locais e totalizadores por pessoa.
- [x] Documentação e testes automatizados para GitHub.
- [x] Integração oficial com Telegram por long polling.
- [x] Lembretes de acertos com amigos pelo Telegram.
- [x] Inicialização automática no logon do Windows.
- [ ] Testes de interface automatizados.
- [ ] Relatório PDF personalizável.

## Licença

Distribuído sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE).


### Experiência de preenchimento — v1.2.1

Os formulários usam datas digitáveis no padrão brasileiro `dd/mm/aaaa`. As datas de movimentações e quitações sugerem hoje automaticamente. No cadastro de acertos, os campos essenciais ficam visíveis e vencimentos, lembretes e observações ficam em **Prazo, lembrete e observações**. Os detalhes de vencimento sugerem hoje somente quando essa seção é aberta.


### Telegram e execução contínua — v1.3.0

O Luca pode conversar por Telegram sem endpoint público. Crie o bot com BotFather, configure `TELEGRAM_BOT_TOKEN`, envie `/start` para descobrir o ID do remetente, configure `TELEGRAM_ALLOWED_USER_ID` e reinicie. A integração aceita texto e áudio; áudio precisa do suporte faster-whisper instalado. A confirmação de registros é obrigatória.

Para iniciar em segundo plano no logon do Windows, execute `instalar_inicio_automatico.bat`; para remover a tarefa, execute `remover_inicio_automatico.bat`. Consulte [`docs/upgrading-to-v1.3.0.md`](docs/upgrading-to-v1.3.0.md) ao atualizar uma instalação existente.
