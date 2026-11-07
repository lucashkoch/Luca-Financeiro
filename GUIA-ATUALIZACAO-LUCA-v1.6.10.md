# Atualização do Luca — versão 1.6.10

## O que mudou
- Corrigida a interpretação de valores falados com centavos separados: “40 reais, 25 centavos”, “40 reais e 25 centavos”, “quarenta reais, vinte e cinco centavos”.
- O trecho dos centavos é incorporado ao valor e removido da descrição.
- A forma de pagamento explicitamente falada continua tendo prioridade sobre a forma padrão configurada.

## Como atualizar
1. Feche o Luca.
2. Faça backup da pasta `data` e do arquivo `.env`.
3. Extraia esta versão em uma pasta nova.
4. Copie o `.env` e a pasta `data` da instalação anterior.
5. Não copie a pasta `.venv`.
6. Execute `iniciar.bat`.

Não há migração de banco de dados nesta versão.
