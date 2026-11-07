# Luca v1.6.7 — identidade visual

Esta versão incorpora a logo fornecida ao painel e sincroniza a foto de perfil do bot Telegram.

## Atualização

1. Feche o Luca.
2. Faça backup de `data/` e `.env`.
3. Extraia o ZIP v1.6.7 em uma pasta nova.
4. Copie `.env` e `data/` da instalação anterior.
5. Não copie `.venv`.
6. Execute `iniciar.bat`.

## O que mudou

- Símbolo Luca na navegação lateral, no assistente e no favicon.
- Logo completa na tela de login.
- Arquivo original preservado em `branding/luca-logo-original.png`.
- Foto JPG quadrada do bot em `branding/luca-telegram-avatar.jpg`.
- Sincronização automática pelo método oficial `setMyProfilePhoto`, uma vez por imagem/bot.

A sincronização está habilitada por padrão. Para desativar, configure `TELEGRAM_PROFILE_PHOTO_ENABLED=0` no `.env`. Se o envio falhar, o serviço continua funcionando; consulte `logs/luca-service.log`.

**Segurança:** o pacote não inclui `.env`, banco de dados, logs ou `.venv`. Mantenha seu token do Telegram somente no `.env` e nunca o publique no GitHub.
