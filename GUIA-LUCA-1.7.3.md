# Atualização do Luca para a versão 1.7.3

## Novidade principal: acertos pessoais pelo Telegram

Agora você pode cadastrar pelo bot valores que outras pessoas devem a você e valores que você deve a outras pessoas, sem precisar abrir o painel.

### Fluxo guiado

1. Envie `/novoacerto` no chat privado do Luca.
2. Toque em **Alguém me deve** ou **Eu estou devendo**.
3. Envie o nome da pessoa.
4. Envie o valor e o motivo, por exemplo: `R$ 80,00 do jantar`.
5. Opcionalmente, acrescente `vence em 20/11/2026` e `me lembre em 19/11/2026`.
6. Confira a prévia e toque em **Confirmar** ou **Cancelar**.

Você também pode começar diretamente com `/novoacerto receber` ou `/novoacerto pagar`.

### Consultar e baixar compromissos

- `/devendo` mostra os totais e compromissos em aberto, com pessoa, descrição, saldo pendente e vencimento.
- Para criar um novo compromisso, use os botões exibidos pelo comando ou `/novoacerto`.
- Frases diretas continuam disponíveis: `Rafael me deve R$ 80 do jantar`, `Devo R$ 50 para Rafael pela pizza`.
- Para registrar recebimento ou pagamento parcial, use `Rafael me pagou R$ 40` ou `Paguei R$ 50 para Rafael`. Se existir mais de um compromisso aberto para a mesma pessoa, o Luca pede que você escolha o compromisso no painel para não baixar o item errado.

Os acertos pessoais ficam separados de receitas, despesas e saldos bancários. Quando o dinheiro efetivamente entrar ou sair da conta, registre também a movimentação bancária apropriada; o controle de acertos não cria essa movimentação automaticamente.

### Cancelamento e privacidade

- Use `/cancelar` para encerrar o cadastro guiado antes de confirmar.
- O rascunho do fluxo expira após 20 minutos.
- O estado do assistente fica na base privada do perfil vinculado ao Telegram.
- Nada é gravado até você confirmar a prévia.

## Instalação

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP em uma pasta nova.
4. Copie `data/` e `.env` da instalação anterior.
5. Não copie a pasta `.venv`.
6. Execute `iniciar.bat`.

A nova tabela de rascunhos do Telegram é criada por migração aditiva. Não apague nem substitua seu banco de dados.
