# 📂 Projeto Fio do Bem - Implementação de Banco de Dados SQL

Este repositório contém os scripts SQL para a criação e manipulação do banco de dados relacional (Minimundo) da ONG fictícia "Fio do Bem", desenvolvido como parte da disciplina de Modelagem de Banco de Dados.

O Modelo Lógico foi projetado em conformidade com a Terceira Forma Normal (3FN) para garantir a integridade e a ausência de redundância.

## 🎯 Requisitos de Entrega:

O script `script_dados_fio_do_bem.sql` abrange as seguintes fases:

### 1. DDL (Data Definition Language) - Criação da Estrutura
* Criação de 8 tabelas: `CATEGORIA`, `ADMINISTRADOR`, `VOLUNTARIO`, `DOADOR`, `PROJETO`, `OPORTUNIDADE`, `DOACAO`, e a tabela associativa `PARTICIPACAO`.
* Definição de Chaves Primárias (`PRIMARY KEY`) e Chaves Estrangeiras (`FOREIGN KEY`).
* Uso de tipos de dados adequados (`DECIMAL` para valores monetários, `ENUM` para status).

### 2. DML (Data Manipulation Language) - Inserção de Dados
* Comandos `INSERT INTO` para popular as 8 tabelas com dados coerentes à causa da ONG.

### 3. Consultas e Manipulação de Dados

#### Consultas (SELECT)
1.  **Consulta de Participação:** Lista Voluntários alocados em oportunidades específicas (Uso de `JOIN` e `WHERE`).
2.  **Total Arrecadado por Categoria:** Soma o valor arrecadado por categoria de projeto (`SUM`, `GROUP BY`, `ORDER BY`).
3.  **Falta para Meta:** Calcula e mostra o valor que falta para atingir a meta do projeto mais ativo (`WHERE`, `LIMIT`).

#### Manipulação (UPDATE e DELETE)
* **3 Comandos UPDATE:** Correção de dados e alteração de status de projetos e participação.
* **3 Comandos DELETE:** Exemplos de remoção de dados com condições (`WHERE`).

## ⚙️ Instruções de Execução

1.  Crie um novo esquema/banco de dados vazio (ex: `fio_do_bem_db`).
2.  Execute o script `script_dados_fio_do_bem.sql` na íntegra.
3.  O script irá limpar o ambiente (`DROP TABLE`) e recriar toda a estrutura e dados sequencialmente.
