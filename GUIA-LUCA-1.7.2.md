# Atualização do Luca para a versão 1.7.2

## Novidades

- Filtro por forma de pagamento no Histórico financeiro. Ele lista as formas ativas cadastradas no perfil, inclusive formas personalizadas.
- O assistente consulta lançamentos anteriores com descrições semelhantes para sugerir uma categoria pessoal (por exemplo, `iFood` e `iFood delivery`).
- Se você corrigir a categoria de um lançamento no painel ou escolher manualmente outra categoria na prévia do Telegram, o Luca guarda essa preferência para o estabelecimento nas próximas vezes.
- A prévia informa quando a categoria foi sugerida pelo histórico ou aprendida de uma correção anterior.
- Uma categoria escrita explicitamente na mensagem continua tendo prioridade. Se o histórico estiver dividido entre categorias, o Luca não força uma escolha.

## Como atualizar

1. Feche o Luca.
2. Faça cópia de segurança da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP em uma pasta nova.
4. Copie a pasta `data/` e o `.env` da instalação anterior para a nova. Não copie `.venv`.
5. Execute `iniciar.bat`.

Na inicialização, o Luca cria a tabela de preferências aprendidas e atualiza referências de formas padrão nos registros antigos. A migração é aditiva e não exclui nem renumera lançamentos.

## Observações

- As preferências de categoria ficam no banco individual de cada perfil; um perfil não aprende com os dados de outro.
- O Luca não altera categorias de lançamentos antigos automaticamente. A aprendizagem afeta sugestões para novos registros.
- A primeira correção manual é importante: depois dela, descrições equivalentes do mesmo estabelecimento podem reutilizar a categoria escolhida.
- No Histórico financeiro, use o filtro “Todas as formas de pagamento” para selecionar Débito, Crédito, Pix ou qualquer forma personalizada ativa. O filtro funciona junto com os demais filtros e com a paginação.
- Na prévia do assistente do painel e do Telegram, o Luca informa quando a categoria veio de uma correção anterior ou foi sugerida por lançamentos semelhantes. Registros antigos sem referência explícita são associados às formas padrão durante a migração.

## Validação

- Testes de filtro simples e paginado por forma de pagamento.
- Testes de sugestão a partir do histórico e de preferência manual.
- Teste de prioridade para categoria explicitamente informada.
- Testes do fluxo Telegram: sugestão, correção, confirmação e aprendizagem para mensagens seguintes.
- Teste de transparência da prévia do assistente no painel web, incluindo a indicação de categoria aprendida ou sugerida pelo histórico.
- **208 testes automatizados aprovados.**
