# Contribuindo

Obrigado por considerar uma contribuição ao Luca — Assistente Financeiro.

## Antes de abrir uma alteração

1. Abra uma issue descrevendo o problema ou a melhoria.
2. Não inclua dados financeiros reais, tokens, senhas, extratos ou informações pessoais.
3. Para mudanças de banco de dados, implemente migrações compatíveis com bancos existentes.
4. Para cálculos monetários, use centavos inteiros no SQLite e `Decimal` na entrada/saída; não use `float` para persistir dinheiro.
5. Para operações financeiras, inclua testes que cubram também os casos de erro e limites.

## Ambiente de desenvolvimento

```powershell
py -3.11 -m venv .venv
.venv\Scripts\activate
python -m pip install -r requirements.txt
python -m pytest -q
```

## Pull requests

- Mantenha o escopo de cada PR pequeno e objetivo.
- Atualize `README.md` e `CHANGELOG.md` quando o comportamento mudar.
- Não envie `data/*.db`, `.env`, backups ou arquivos de configuração privados.
- Confirme que `python -m pytest -q` passa antes de enviar.
