# Histórico de versões

## 1.3.0 — 2026-11-04

### Telegram
- Integração com a Telegram Bot API oficial por long polling, sem webhook ou endereço público.
- Autorização obrigatória por ID numérico, limitada a conversas privadas; grupos e outros usuários são ignorados.
- Registro de receitas, depósitos, despesas e transferências a partir de mensagens em linguagem natural.
- Confirmação/cancelamento por botões inline ou comandos; confirmações expiram após 15 minutos.
- Consultas de saldos, contas, gastos e valores entre amigos.
- Recepção de mensagens de voz/áudio, download limitado a 20 MB e transcrição opcional local por faster-whisper.
- Lembretes de acertos com amigos enviados pelo Telegram e marcados após envio bem-sucedido.
- Deduplicação de updates recebidos para evitar processamento duplicado em reinicializações.

### Windows e operação
- Serviço de execução em segundo plano com logs rotativos em `logs/luca-service.log`.
- Instalação e remoção de inicialização automática no logon via Agendador de Tarefas do Windows.
- Proteção contra iniciar outra instância quando o painel já está ativo.
- Painel mostra o estado da integração Telegram sem revelar o token.
- WhatsApp removido desta versão para manter o escopo pessoal e evitar a manutenção de um adaptador inadequado ao uso pretendido.

### Segurança e confiabilidade
- Sem token ou ID autorizado, o bot não lê nem altera dados financeiros; `/start` e `/id` informam somente o ID do remetente para configuração.
- Somente o ID configurado, em conversa privada, pode usar comandos e consultar dados.
- Toda movimentação financeira apresenta resumo e exige confirmação explícita.
- O Luca não remove webhooks existentes automaticamente, pois o Telegram não permite long polling com webhook ativo.
- Token, base SQLite, logs e arquivos `.env` permanecem fora do controle de versão.

### Compatibilidade
- Nenhuma migração destrutiva do banco. A versão reutiliza as tabelas de ações pendentes e de atualizações processadas.
- O painel e a API continuam locais em `127.0.0.1`.

## 1.2.1 — 2026-11-04

### Interface
- Formulário de acertos entre amigos simplificado: pessoa, tipo, descrição e valor ficam em primeiro plano.
- Vencimento, lembrete e observações foram agrupados em uma seção opcional recolhível.
- Datas passaram a aceitar digitação direta no formato brasileiro `dd/mm/aaaa`, com máscara automática e validação de calendário.
- Datas de movimentações, transferências, recorrências e quitações sugerem a data de hoje por padrão.
- Datas de vencimento e lembrete sugerem hoje ao abrir os detalhes opcionais, mas não são gravadas sem que o usuário abra essa seção.
- Corrigido o estilo que aplicava largura fixa ao botão Cancelar e fazia o texto sobrepor o botão Salvar.
- Rodapé dos modais agora tem dimensões e comportamento responsivo, com botões sem sobreposição em telas estreitas.

### Compatibilidade
- Datas digitadas são convertidas para ISO (`AAAA-MM-DD`) antes de enviar à API; o formato do banco de dados e os dados existentes não mudam.
- Nenhuma migração de banco de dados necessária.

## 1.2.0 — 2026-11-03

- Interpretação determinística mais precisa de receitas, depósitos, despesas e transferências entre contas.
- Depósitos e receitas não exigem forma de pagamento para serem registrados.
- Reconhecimento de nomes de contas com variações naturais, como “conta mãe” para “Conta da mãe”.
- Transferências identificam origem e destino e podem ser confirmadas diretamente na conversa.
- Cartão, forma de pagamento e tipo de movimentação são validados antes da confirmação.
- Ollama passa a refinar somente descrição e categoria, sem poder alterar valor, tipo, forma de pagamento ou contas envolvidas.
- Exemplos da tela do assistente atualizados para entradas, despesas e transferências.

## 1.1.0 — 2026-11-03

- Área **Contas com amigos** para valores a receber e a pagar.
- Cadastro de compromissos por pessoa, com data de vencimento e lembrete.
- Registro de pagamentos/recebimentos parciais e totais, com histórico de quitações.
- Totalizadores a receber, a pagar e saldo líquido por pessoa e no consolidado.
- Lembretes no painel, com opção de notificação do navegador e dispensa diária.
- Rebranding completo para **Luca — Assistente Financeiro**.
- Estrutura de documentação e automação de testes para GitHub.

## 1.0.0 — 2026-11-03

- Primeira versão funcional do controle financeiro local.
