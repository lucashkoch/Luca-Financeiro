# Segurança e reporte responsável

O Luca guarda dados financeiros pessoais. Trate o banco SQLite e os backups como informações sensíveis.

## Nunca publique

- Arquivos `.env` ou tokens de integrações.
- Bancos `data/*.db`, backups, extratos ou CSVs com dados reais.
- Senhas, códigos de autenticação, números completos de cartão ou credenciais bancárias.

O `.gitignore` exclui esses arquivos por padrão, mas revise `git status` antes de cada commit.

## Reportar uma vulnerabilidade

Não publique detalhes exploráveis em uma issue pública. Entre em contato privadamente com o responsável pelo repositório (use o recurso **Report a vulnerability** do GitHub, caso esteja habilitado). Inclua passos para reproduzir sem anexar dados financeiros reais.

## Modelo de segurança atual

- O servidor inicia em `127.0.0.1` e não deve ser exposto diretamente à internet.
- A senha HTTP Basic é uma camada adicional opcional, não substitui uma implantação segura.
- O arquivo SQLite não é criptografado pelo aplicativo.
- As notificações do navegador são exibidas apenas enquanto a aplicação estiver aberta e o navegador permitir notificações.


## Integração Telegram

- O token do bot e o ID autorizado ficam em `.env`, que não deve ser versionado.
- Apenas o ID autorizado em conversa privada pode consultar ou alterar dados.
- Mensagens e áudios passam pelos servidores Telegram; chats com bots não têm a proteção de ponta a ponta dos Secret Chats. Não envie credenciais bancárias ou códigos de autenticação.
- O serviço não abre portas públicas e faz requisições HTTPS de saída para a Bot API.
