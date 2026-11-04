# Luca — Assistente Financeiro

![Version](https://img.shields.io/badge/version-1.4.3-7569e6)
![Tests](https://img.shields.io/badge/tests-84%20passing-22a06b)
![Python](https://img.shields.io/badge/python-3.11%2B-3776ab)
![License](https://img.shields.io/badge/license-MIT-blue)

Assistente financeiro em português brasileiro, com painel web local, banco SQLite, perfis isolados, integração opcional com Telegram e inteligência artificial local. Foi pensado para registrar e consultar finanças sem assinatura de uma API de IA.

> **Importante sobre hospedagem:** a instalação padrão escuta somente em `127.0.0.1` e é privada ao computador. O suporte a vários perfis separa os dados dentro da mesma instalação, mas para amigos acessarem o painel de outros computadores será necessário hospedar a aplicação em um servidor com HTTPS, armazenamento persistente e configuração segura. Não exponha o servidor HTTP local diretamente à internet.

## Atualização 1.4.2 — linguagem natural e transcrição

- O parser aceita valores em português por extenso (por exemplo, “cento e vinte reais”), abreviações como `2,5k`, valores com centavos falados e formas diferentes de ordenar ação, conta, data e pagamento.
- A limpeza de descrições remove referências temporais e de pagamento, mantendo o motivo do gasto; futebol, quadra, academia e outras atividades ganham a categoria **Esportes**.
- Transferências coloquiais como “mandei da Caixa pra Nubank” só são tratadas como movimentação interna quando as duas contas são identificadas.
- O áudio usa `medium` por padrão, contexto em português brasileiro com vocabulário financeiro, VAD, busca por feixe e cache do modelo carregado. O primeiro uso baixa o modelo localmente.
- O instalador usa explicitamente o Python da pasta `.venv`, valida o carregamento de `faster-whisper`/`ctranslate2` e há diagnóstico em `/assistant/audio/status`. Erros de modelo/DLL deixam de ser confundidos com pacote ausente.
- Nenhuma migração de banco de dados.

## Recursos

### Finanças do dia a dia
- Múltiplas contas financeiras: corrente, poupança, carteira, investimento e outros tipos.
- Receitas, despesas, depósitos, compras parceladas e transferências internas.
- Formas de pagamento cadastráveis. Por padrão: **Débito, Crédito e Pix**. É possível definir uma forma de pagamento e uma conta/banco padrão para novos lançamentos.
- Forma de pagamento vinculada ao lançamento e à conta bancária usada para acompanhar a movimentação.
- Compras no crédito podem ser registradas em uma conta normal, sem exigir cadastro de cartão separado.
- Quitação das compras no crédito sem duplicar a despesa original.
- Cadastro de categorias próprias, com arquivamento e reativação sem apagar o histórico.
- Limites mensais por categoria, metas de economia e lançamentos recorrentes.
- Área **Devendo / A receber**, com compromissos, pagamentos parciais, histórico, vencimentos e lembretes.
- Área **Economias & investimentos**, com visão consolidada das contas de poupança e investimento, operações de aplicação/resgate por transferência e metas vinculadas ao planejamento. Os valores são alimentados manualmente pelas contas, sem cotação de mercado automática ou rentabilidade calculada por corretora; o mesmo dinheiro aparece uma única vez no patrimônio.

### Painel e relatórios
- Tema escuro por padrão, com alternância para tema claro.
- Personalização por perfil da fonte (Inter, Manrope, Space Grotesk ou sistema), escala da interface e densidade confortável/compacta.
- Resumo geral com total a receber de pessoas e total a pagar a pessoas, sem misturar esses compromissos ao saldo bancário.
- Tipografia maior e menus adaptados a telas menores.
- Filtros de lançamentos por mês, ano, intervalo de datas ou todo o período.
- Datas digitáveis no formato `dd/mm/aaaa`.
- Relatórios por categoria, conta, período e forma de pagamento.
- Importação CSV e exportação de lançamentos.
- Backup do banco por perfil.

### Assistente conversacional
- Interpretador determinístico de português brasileiro para entradas, despesas e transferências.
- Extração de valor, data, conta, descrição, categoria, forma de pagamento e parcelas.
- Prévia e confirmação antes de gravar qualquer lançamento ou operação administrativa.
- Perguntas de esclarecimento quando houver ambiguidade; o sistema evita inventar conta, forma de pagamento ou intenção.
- Catálogo de frases e exemplos em [`docs/catalogo-de-frases.md`](docs/catalogo-de-frases.md).
- Integração opcional com Ollama para apoio contextual local.
- Integração opcional com faster-whisper para transcrição local de áudio.

### Telegram
- Um único bot Telegram pode atender vários perfis.
- Cada usuário vincula sua própria conta Telegram com um código de uso único.
- O bot escolhe automaticamente o banco privado do usuário vinculado.
- Consultas e cadastros de contas, lançamentos, formas de pagamento, limites, metas, recorrências e acertos.
- Ações de edição e exclusão suportadas para operações comuns, sempre com confirmação.
- Lembretes de compromissos enviados pelo bot.
- Long polling: não exige domínio, webhook ou porta pública.

### Perfis e isolamento de dados
- Primeiro cadastro cria o administrador.
- Administrador pode gerar convites de uso único para novos perfis.
- Cada usuário tem seu próprio arquivo SQLite em `data/users/`.
- Banco central `data/luca-users.db` guarda autenticação, sessões, convites e vínculos Telegram; não guarda o razão financeiro de todos os usuários.
- Sessões com cookie HttpOnly e senhas derivadas com scrypt.
- Consultas web e ações do Telegram são executadas no contexto do perfil autenticado.

## Instalação no Windows

Requisitos: Windows 10/11, Python 3.11 ou superior e conexão com a internet para instalar as dependências.

1. Baixe ou clone o repositório.
2. Extraia em uma pasta permanente, por exemplo `C:\Luca`.
3. Execute `iniciar.bat`.
4. O instalador cria `.venv`, instala `requirements.txt` e cria `.env` a partir de `.env.example` se necessário.
5. Abra `http://127.0.0.1:8000`.
6. Na primeira execução, crie o perfil administrador. Se houver um banco legado `data/luca.db`, o primeiro administrador o importa para seu banco privado e uma cópia de backup é feita antes da migração.

O painel não se conecta automaticamente a bancos. Cadastre manualmente os saldos atuais e registre movimentações. Nunca informe senhas bancárias, códigos de autenticação ou números completos de cartões.

## Primeira configuração e perfis

### Administrador

Na primeira abertura, crie nome, e-mail e senha (mínimo de 10 caracteres). Se a aplicação já tiver usuários cadastrados, o cadastro inicial fica bloqueado.

### Convidar um amigo

1. Entre no perfil administrador.
2. Abra **Configurações → Usuários e convites → Gerar convite**.
3. Envie o código ao amigo por um canal privado. O convite é de uso único e expira após 7 dias.
4. O amigo abre a mesma instância do Luca, informa o código, cria seu nome, e-mail e senha e entra em um perfil vazio.
5. O arquivo de dados desse usuário será separado do seu.

**Limite da instalação local:** com `iniciar.bat`, a aplicação é acessível apenas no computador onde está instalada. Amigos em outros dispositivos precisam de uma instância hospedada com HTTPS. Para essa implantação, configure proxy HTTPS, armazenamento persistente, `LUCA_COOKIE_SECURE=1`, backups e controle de acesso. O projeto não inclui um serviço de hospedagem gerenciada.

## Telegram

1. Crie um bot com [@BotFather](https://t.me/BotFather).
2. Coloque o token em `TELEGRAM_BOT_TOKEN` no `.env`.
3. Reinicie o Luca.
4. Entre no perfil do Luca e abra **Configurações → Luca no Telegram → Gerar código de vínculo**.
5. Abra o bot em conversa privada e envie `/vincular CÓDIGO`.
6. Cada usuário deve gerar seu próprio código no seu perfil. Um vínculo não dá acesso aos dados de outro perfil.

Não é necessário `TELEGRAM_ALLOWED_USER_ID`; essa configuração antiga foi substituída por vínculos individuais. O bot ignora grupos e só aceita conversas privadas vinculadas.

Comandos principais:

| Comando | Função |
|---|---|
| `/start` | Iniciar o bot |
| `/ajuda` | Catálogo resumido de exemplos |
| `/saldo` | Saldo consolidado |
| `/contas` | Saldos individuais |
| `/credito` | Compras no crédito ainda não quitadas |
| `/lancamentos` | Últimos lançamentos e IDs |
| `/limites` | Limites mensais |
| `/metas` | Metas de economia |
| `/devendo` | Valores a pagar e a receber |
| `/formas` | Formas de pagamento ativas |
| `/recorrencias` | Regras recorrentes |
| `/lembretes` | Lembretes vencidos ou do dia |
| `/confirmar` e `/cancelar` | Resolver ação pendente |
| `/vincular CÓDIGO` | Vincular este Telegram ao perfil |

O catálogo completo de linguagem está em [`docs/catalogo-de-frases.md`](docs/catalogo-de-frases.md). Ações financeiras ou administrativas criam uma prévia com botões **Confirmar** e **Cancelar**. A prévia expira em 15 minutos.

### Privacidade do Telegram

O texto e os áudios passam pela infraestrutura do Telegram. Conversas com bots **não** são Secret Chats com criptografia ponta a ponta. Áudios são baixados temporariamente e transcritos localmente; o arquivo temporário é removido após o processamento. Não envie senhas bancárias ou dados sigilosos.

## IA local e áudio

### Ollama (opcional)

1. Instale o Ollama.
2. Execute `instalar_ollama.bat` para baixar o modelo configurado.
3. Em `.env`, defina `OLLAMA_ENABLED=1`.
4. Reinicie o Luca.

O parser local determinístico continua sendo a primeira camada. O modelo não pode substituir silenciosamente o valor, o tipo ou a conta identificados pelo parser. O Luca não usa API paga de IA.

### Áudio (opcional)

Execute `instalar_audio.bat` e reinicie o Luca. O primeiro uso baixa o modelo Whisper configurado em `WHISPER_MODEL`. A transcrição roda no computador. Para enviar áudio pelo Telegram, o serviço do Luca precisa estar ativo.

## Inicialização automática no Windows

- Execute `instalar_inicio_automatico.bat` para criar uma tarefa no Agendador de Tarefas no logon do usuário atual.
- Execute `remover_inicio_automatico.bat` para remover a tarefa.
- O serviço padrão escuta apenas em `127.0.0.1:8000`.
- O computador precisa estar ligado, conectado à internet e sem suspensão para Telegram e lembretes funcionarem.

## Atualizar sem perder dados

**Não extraia uma versão nova por cima da pasta antiga.** Use uma pasta nova e copie os dados.

1. Pare o Luca e remova/pare a tarefa automática antiga, se estiver instalada.
2. Faça uma cópia de segurança de toda a pasta `data/` e do `.env`.
3. Extraia a nova versão em uma pasta separada.
4. Copie o `.env` antigo para a nova pasta.
5. Copie toda a pasta `data/` antiga para a nova pasta, preservando `luca.db`, `luca-users.db`, `users/` e backups caso existam.
6. Execute `iniciar.bat` na pasta nova. As migrações de banco são aditivas; não recriam tabelas financeiras.
7. Faça login com seu perfil existente. Se for sua primeira atualização para perfis e só existir `data/luca.db`, o primeiro administrador importa esse banco para o seu novo perfil e cria um backup automático.
8. Teste contas, saldo, últimos lançamentos e Telegram antes de remover a instalação antiga.
9. Reinstale a tarefa automática a partir da nova pasta, se desejado.

Guia completo: [`docs/upgrading-to-v1.4.2.md`](docs/upgrading-to-v1.4.2.md).

## Configuração `.env`

| Variável | Padrão | Descrição |
|---|---|---|
| `OLLAMA_ENABLED` | `0` | Ativa suporte contextual do Ollama |
| `OLLAMA_URL` | `http://127.0.0.1:11434` | Endereço local do Ollama |
| `OLLAMA_MODEL` | `qwen2.5:3b` | Modelo local |
| `WHISPER_MODEL` | `medium` | Modelo de transcrição (mais preciso, exige mais CPU/memória) |
| `WHISPER_DEVICE` | `cpu` | Dispositivo de transcrição |
| `TELEGRAM_BOT_TOKEN` | vazio | Token do BotFather |
| `TELEGRAM_POLL_TIMEOUT` | `25` | Long polling |
| `TELEGRAM_REMINDER_CHECK_SECONDS` | `60` | Intervalo de verificação de lembretes |
| `TELEGRAM_MAX_AUDIO_MB` | `20` | Tamanho máximo de áudio |
| `LUCA_ACCESS_PASSWORD` | vazio | Proteção HTTP Basic adicional do painel local |
| `LUCA_COOKIE_SECURE` | `0` | Defina `1` somente atrás de HTTPS |
| `LUCA_CONTROL_DATABASE_PATH` | `data/luca-users.db` | Banco central de perfis |
| `LUCA_DATABASE_PATH` | `data/luca.db` | Caminho legado do banco pessoal antes da migração |

Nunca publique `.env`, banco SQLite, backups ou logs em repositório público. O `.gitignore` do projeto exclui esses arquivos.

## Desenvolvimento e testes

```powershell
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m pytest -q
```

O projeto usa FastAPI, SQLite e JavaScript sem framework. A suíte automatizada cobre regras financeiras, migrações, isolamento entre perfis, parser, UI e fluxos Telegram simulados. Ela não substitui um teste manual com um bot Telegram real e uma instalação Windows.

## Estrutura

```text
app/
  assistant.py       # parser determinístico, Ollama e transcrição
  auth.py            # perfis, sessões, convites e vínculos Telegram
  database.py        # SQLite, migrações aditivas e contexto por usuário
  main.py            # API FastAPI
  service.py         # inicialização do serviço local
  telegram_bot.py    # bot por long polling e comandos
  static/            # painel web
tests/               # suíte automatizada
docs/                # arquitetura, Telegram e catálogo de frases
```

## Segurança e limites

- Não é um serviço bancário, não acessa contas bancárias e não realiza pagamentos.
- Não armazene credenciais bancárias, números completos de cartão ou códigos de autenticação.
- O isolamento por usuário ocorre em arquivos SQLite separados; para uso remoto, publique somente atrás de HTTPS e mantenha o sistema atualizado.
- O administrador pode gerar convites; não compartilhe convites publicamente.
- O arquivo do token Telegram é segredo. Se for exposto, revogue-o pelo BotFather e atualize `.env`.
- Faça backups regulares de `data/` e teste a restauração.

## Licença

MIT. Atualize o campo de copyright da licença com seu nome/identidade antes de publicar o repositório.


### Atualização 1.4.3 — recorrências, categorias e padrões
- Correção do erro ao salvar recorrências e persistência correta do tipo de pagamento nas movimentações geradas.
- Cadastro de categorias personalizadas, com arquivamento e reativação sem perda do histórico.
- Preferências de banco/conta e tipo de pagamento padrão em lançamentos manuais e interpretações do assistente/Telegram.
- 84 testes automatizados aprovados.
