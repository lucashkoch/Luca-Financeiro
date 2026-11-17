# Luca 1.7.6 — integração de Devendo / A receber com Lançamentos

## O que mudou

Ao registrar uma baixa em **Devendo / A receber**, o Luca cria automaticamente a movimentação correspondente:

- **A receber:** registra uma receita na conta escolhida.
- **A pagar:** registra uma despesa na conta escolhida.
- **Baixa parcial:** cria uma movimentação somente pelo valor efetivamente pago/recebido e mantém o restante pendente.

No painel, a janela de baixa permite informar a data da movimentação, escolher a conta e selecionar a forma de pagamento. A opção **Criar o lançamento automaticamente** fica marcada por padrão; desmarque-a quando você já tiver registrado a movimentação manualmente para não duplicar o saldo. Para manter o efeito imediato sobre o dinheiro disponível, contas de cartão e a forma Crédito não são aceitas nesse fluxo.

Pelo Telegram, o Luca utiliza a conta padrão do perfil e uma forma de pagamento não relacionada a crédito. A confirmação informa a conta em que a movimentação foi criada.

Os novos registros ficam vinculados entre `friend_settlements` e `transactions`. Para preservar a consistência, lançamentos vinculados não podem ter seu valor, natureza, conta, forma de pagamento ou data alterados nem ser excluídos diretamente na tela de Lançamentos. Para corrigir uma baixa registrada por engano, abra o histórico do compromisso e use **Desfazer baixa**: o Luca remove a baixa e o lançamento bancário correspondente em conjunto, devolvendo o valor ao saldo pendente.

## Atualização no Windows

1. Feche o Luca e o serviço do Telegram, se estiverem abertos.
2. Faça uma cópia de segurança da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP 1.7.6 em uma pasta nova.
4. Copie a pasta `data/` e o `.env` da instalação anterior para a nova pasta.
5. Não copie `.venv`, `__pycache__` ou `.pytest_cache`.
6. Execute `iniciar.bat`.

A migração é automática e aditiva: o Luca adiciona `transaction_id` à tabela `friend_settlements` e cria um índice para garantir que cada movimentação esteja ligada a, no máximo, uma baixa. Nenhum registro existente é apagado ou reescrito.

## Atenção aos acertos antigos

As baixas feitas antes da versão 1.7.6 permanecem no histórico, mas não recebem lançamentos bancários retroativos. Como o Luca não sabe em qual conta o dinheiro entrou ou saiu, gerar esses movimentos automaticamente poderia duplicar transações já lançadas manualmente.

## Como conferir

1. Abra **Minhas contas** e confirme qual conta está definida como padrão.
2. Em **Devendo / A receber**, cadastre ou abra um compromisso de teste.
3. Clique em **Registrar**, informe um valor total ou parcial, escolha a conta, a forma de pagamento e a data.
4. Confirme que o saldo pendente foi reduzido e que surgiu uma receita (A receber) ou despesa (A pagar) em **Lançamentos**.
5. Abra o histórico do compromisso e confirme que a baixa mostra a conta em que a movimentação foi registrada.
6. Teste uma data futura: o lançamento ficará agendado e não alterará o saldo realizado antes da data informada.
7. Abra o histórico e teste **Desfazer baixa**: o lançamento vinculado é removido e o valor retorna ao saldo pendente.

A baixa e a movimentação são gravadas na mesma operação. Se a conta ou a forma de pagamento for inválida, o Luca não grava nenhum dos dois registros.
