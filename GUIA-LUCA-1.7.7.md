# Luca 1.7.7 — revisão geral: segurança, robustez e conveniências

## O que mudou

Esta versão é uma revisão do código inteiro. Não há mudança no modelo de dados nem nos cálculos de saldo, fatura ou relatório.

**Correções**

- O convite de uso único não é mais consumido quando o cadastro falha (senha curta, e-mail repetido).
- Vincular o perfil a outra conta do Telegram passa a substituir o vínculo antigo de verdade.
- Uma recorrência com forma de pagamento ou conta arquivada não impede mais a geração das demais.
- Lançamentos cuja forma de pagamento foi arquivada voltaram a ser editáveis.
- Edição de lançamentos e importação de CSV recusam dados inválidos com mensagens claras, em vez de erro interno.

**Novidades**

- **Configurações → Senha de acesso:** troque sua senha. Os outros dispositivos são desconectados.
- **Configurações → Usuários e convites:** o administrador pode desativar ou reativar um perfil. Os dados ficam preservados.
- **Limites mensais → Copiar do mês anterior:** repete os limites do mês passado sem alterar os que já existem.
- **Backup automático diário** em `data/backups/` (últimos 7 dias por perfil).
- **Proteção de login:** 8 tentativas erradas em 15 minutos bloqueiam temporariamente novas tentativas para aquele e-mail e origem.

## Novas opções do `.env` (opcionais)

```
# Quantos backups diários manter por perfil em data/backups (0 desativa).
LUCA_BACKUP_KEEP=7
# Em servidor Linux, use o seu fuso para datas e recorrências.
TZ=America/Sao_Paulo
```

## Atualização no Windows

1. Feche o Luca e o serviço do Telegram, se estiverem abertos.
2. Faça uma cópia de segurança da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP 1.7.7 em uma pasta nova.
4. Copie a pasta `data/` e o `.env` da instalação anterior para a nova pasta.
5. Não copie `.venv`, `__pycache__` ou `.pytest_cache`.
6. Execute `iniciar.bat`.

Não há migração de banco nesta versão. A pasta `data/backups/` é criada sozinha no primeiro minuto de execução.

## Como conferir

1. Em **Configurações → Senha de acesso**, troque a senha e confirme que outro navegador conectado foi desconectado.
2. Em **Limites mensais**, escolha o próximo mês e clique em **Copiar do mês anterior**.
3. Após um minuto com o Luca aberto, confira os arquivos em `data/backups/`.
4. Em **Recorrências**, as regras continuam sendo geradas normalmente na data.

## Sobre os backups automáticos

Os arquivos em `data/backups/` contêm seus dados financeiros, assim como a pasta `data/`. Eles protegem contra exclusões acidentais e arquivos corrompidos, mas ficam no mesmo disco: continue usando **Baixar backup completo** para guardar uma cópia fora do computador.
