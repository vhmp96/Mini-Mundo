-- ######################################################################
-- # SCRIPT SQL COMPLETO (DDL & DML) - ONG FIO DO BEM
-- # MÓDULO: CRIAÇÃO E MANIPULAÇÃO DE DADOS COM SQL
-- ######################################################################

-- Nota: Os comandos DROP TABLE garantem que você possa executar o script
-- múltiplas vezes sem erros de tabela existente.
DROP TABLE IF EXISTS PARTICIPACAO;
DROP TABLE IF EXISTS DOACAO;
DROP TABLE IF EXISTS OPORTUNIDADE;
DROP TABLE IF EXISTS VOLUNTARIO;
DROP TABLE IF EXISTS DOADOR;
DROP TABLE IF EXISTS PROJETO;
DROP TABLE IF EXISTS ADMINISTRADOR;
DROP TABLE IF EXISTS CATEGORIA;

-- ######################################################################
-- # FASE 1: DDL - CRIAÇÃO DA ESTRUTURA (8 TABELAS)
-- ######################################################################

-- Tabela 1: CATEGORIA
CREATE TABLE CATEGORIA (
    ID_Categoria INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50) UNIQUE NOT NULL,
    Descricao TEXT
);

-- Tabela 2: ADMINISTRADOR
CREATE TABLE ADMINISTRADOR (
    ID_Admin INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    SenhaHash CHAR(60) NOT NULL, -- CHAR(60) é comum para hashes de senha (ex: bcrypt)
    Permissao ENUM('TOTAL', 'PROJETOS') NOT NULL
);

-- Tabela 3: VOLUNTARIO
CREATE TABLE VOLUNTARIO (
    ID_Voluntario INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    CPF CHAR(14) UNIQUE,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    DataNascimento DATE,
    Endereco VARCHAR(150),
    Cidade VARCHAR(50),
    UF CHAR(2)
);

-- Tabela 4: DOADOR
CREATE TABLE DOADOR (
    ID_Doador INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    TipoPessoa ENUM('FISICA', 'JURIDICA') NOT NULL
);

-- Tabela 5: PROJETO (FKs para CATEGORIA e ADMINISTRADOR)
CREATE TABLE PROJETO (
    ID_Projeto INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    MetaArrecadacao DECIMAL(10, 2) NOT NULL, 
    ValorArrecadado DECIMAL(10, 2) DEFAULT 0,
    DataInicio DATE NOT NULL,
    DataFim DATE,
    Status ENUM('ATIVO', 'CONCLUIDO', 'PAUSADO') NOT NULL,
    
    ID_Categoria INT NOT NULL,
    ID_Admin INT NOT NULL,

    FOREIGN KEY (ID_Categoria) REFERENCES CATEGORIA(ID_Categoria),
    FOREIGN KEY (ID_Admin) REFERENCES ADMINISTRADOR(ID_Admin)
);

-- Tabela 6: OPORTUNIDADE (FK para PROJETO)
CREATE TABLE OPORTUNIDADE (
    ID_Oportunidade INT PRIMARY KEY AUTO_INCREMENT,
    Titulo VARCHAR(100) NOT NULL,
    Descricao TEXT,
    CargaHorariaEstimada INT,
    DataLimiteInscricao DATE,
    Status ENUM('ABERTA', 'FECHADA', 'CONCLUIDA') NOT NULL,
    
    ID_Projeto INT NOT NULL,

    FOREIGN KEY (ID_Projeto) REFERENCES PROJETO(ID_Projeto)
);

-- Tabela 7: DOACAO (FKs para DOADOR e PROJETO)
CREATE TABLE DOACAO (
    ID_Doacao INT PRIMARY KEY AUTO_INCREMENT,
    Valor DECIMAL(10, 2) NOT NULL,
    DataHora DATETIME NOT NULL,
    Status ENUM('APROVADA', 'PENDENTE', 'FALHOU') NOT NULL,
    
    ID_Doador INT NOT NULL,
    ID_Projeto INT NOT NULL,

    FOREIGN KEY (ID_Doador) REFERENCES DOADOR(ID_Doador),
    FOREIGN KEY (ID_Projeto) REFERENCES PROJETO(ID_Projeto)
);

-- Tabela 8: PARTICIPACAO (Tabela Associativa N:M com FKs e PK Composta)
CREATE TABLE PARTICIPACAO (
    ID_Voluntario INT NOT NULL,
    ID_Oportunidade INT NOT NULL,
    
    DataInscricao DATE NOT NULL,
    StatusAlocacao ENUM('PENDENTE', 'ALOCADO', 'CANCELADO') NOT NULL,
    CargaHorariaRealizada DECIMAL(5, 2),
    CertificadoEmitido BOOLEAN DEFAULT FALSE,
    
    PRIMARY KEY (ID_Voluntario, ID_Oportunidade), 
    
    FOREIGN KEY (ID_Voluntario) REFERENCES VOLUNTARIO(ID_Voluntario),
    FOREIGN KEY (ID_Oportunidade) REFERENCES OPORTUNIDADE(ID_Oportunidade)
);


-- ######################################################################
-- # FASE 2: DML - INSERÇÃO DE DADOS (POPULANDO AS TABELAS PRINCIPAIS)
-- ######################################################################

-- CATEGORIA
INSERT INTO CATEGORIA (Nome, Descricao) VALUES
('Vestuário', 'Projetos focados em roupas e acessórios'),
('Inverno', 'Campanhas sazonais de frio e agasalhos'),
('Logística', 'Projetos de infraestrutura e transporte');

-- ADMINISTRADOR (Senha hashada fictícia)
INSERT INTO ADMINISTRADOR (Nome, Email, SenhaHash, Permissao) VALUES
('Ana Silva', 'ana.admin@fiodobem.org', '$2a$10$abcdefghijklmnopqrstuvw.xyz0123456789', 'TOTAL'),
('Pedro Souza', 'pedro.proj@fiodobem.org', '$2a$10$abcdefghijklmnopqrstuvw.xyz0123456789', 'PROJETOS');

-- PROJETO (IDs 1 e 2)
INSERT INTO PROJETO (Nome, Descricao, MetaArrecadacao, ValorArrecadado, DataInicio, DataFim, Status, ID_Categoria, ID_Admin) VALUES
('Campanha Calor que Aquece', 'Arrecadação de fundos para 5000 kits de inverno.', 50000.00, 45000.00, '2025-05-01', '2025-08-31', 'ATIVO', 2, 1),
('Programa Roupa Nova', 'Financiamento contínuo para produção de vestuário básico.', 10000.00, 10000.00, '2024-01-01', NULL, 'CONCLUIDO', 1, 2);

-- VOLUNTARIO (IDs 1, 2 e 3)
INSERT INTO VOLUNTARIO (Nome, CPF, Email, Telefone, DataNascimento, Endereco, Cidade, UF) VALUES
('Maria Oliveira', '111.111.111-11', 'maria.voluntaria@email.com', '(11) 98888-7777', '1995-10-20', 'Rua das Flores, 100', 'São Paulo', 'SP'),
('João Santos', '222.222.222-22', 'joao.log@email.com', '(21) 96666-5555', '1990-03-15', 'Av. Central, 50', 'Rio de Janeiro', 'RJ'),
('Lucas Mendes', '333.333.333-33', 'lucas.mendes@email.com', '(41) 94444-3333', '2000-07-25', 'Rua Curitiba, 20', 'Curitiba', 'PR');

-- DOADOR (IDs 1, 2 e 3)
INSERT INTO DOADOR (Nome, Email, Telefone, TipoPessoa) VALUES
('Empresa Solidária LTDA', 'contato@empresa.com', '(11) 3000-4000', 'JURIDICA'),
('Carlos Pereira', 'carlos@email.com', '(11) 91111-2222', 'FISICA'),
('Lojas Moda Fácil', 'doacao@modafacil.com', '(11) 5000-6000', 'JURIDICA');

-- OPORTUNIDADE (IDs 1 e 2 - Ligadas ao Projeto 1 e 2)
INSERT INTO OPORTUNIDADE (Titulo, Descricao, CargaHorariaEstimada, DataLimiteInscricao, Status, ID_Projeto) VALUES
('Triagem e Organização', 'Ajuda na separação de roupas do inverno.', 40, '2025-07-15', 'ABERTA', 1),
('Apoio em Redes Sociais', 'Criação de conteúdo para divulgação de impacto.', 20, '2025-06-30', 'FECHADA', 2);

-- DOACAO (Ligadas ao Doador 1, 2 e Projeto 1, 2)
INSERT INTO DOACAO (Valor, DataHora, Status, ID_Doador, ID_Projeto) VALUES
(25000.00, '2025-06-01 10:00:00', 'APROVADA', 1, 1), -- Empresa Solidária doou 25k ao Projeto 1
(50.00, '2025-06-05 14:30:00', 'APROVADA', 2, 1),   -- Carlos doou 50 ao Projeto 1
(10000.00, '2024-03-10 09:00:00', 'APROVADA', 3, 2); -- Lojas Moda Fácil doou 10k ao Projeto 2

-- PARTICIPACAO (Associa Voluntários a Oportunidades)
INSERT INTO PARTICIPACAO (ID_Voluntario, ID_Oportunidade, DataInscricao, StatusAlocacao, CargaHorariaRealizada, CertificadoEmitido) VALUES
(1, 1, '2025-06-10', 'ALOCADO', NULL, FALSE), -- Maria inscrita na Triagem
(2, 2, '2025-06-01', 'ALOCADO', 20.00, TRUE);  -- João concluiu o Apoio em Redes

-- ######################################################################
-- # FASE 3: DML - CONSULTAS E MANIPULAÇÃO DE DADOS (SELECT, UPDATE, DELETE)
-- ######################################################################

-- REQUISITO 2: SCRIPT SQL com duas a cinco consultas usando SELECT (com WHERE, ORDER BY, JOIN, etc.)

-- CONSULTA 1: Listar o nome de todos os Voluntários que estão ALOCADOS na oportunidade de Triagem. (JOIN e WHERE)
SELECT 
    V.Nome AS Voluntario,
    O.Titulo AS Oportunidade
FROM VOLUNTARIO V
JOIN PARTICIPACAO P ON V.ID_Voluntario = P.ID_Voluntario
JOIN OPORTUNIDADE O ON P.ID_Oportunidade = O.ID_Oportunidade
WHERE P.StatusAlocacao = 'ALOCADO' AND O.Titulo LIKE '%Triagem%';

-- CONSULTA 2: Mostrar o total arrecadado por categoria de projeto, ordenado do maior para o menor. (JOIN, SUM, GROUP BY, ORDER BY)
SELECT
    C.Nome AS Categoria,
    SUM(P.ValorArrecadado) AS TotalArrecadado
FROM CATEGORIA C
JOIN PROJETO P ON C.ID_Categoria = P.ID_Categoria
GROUP BY C.Nome
ORDER BY TotalArrecadado DESC;

-- CONSULTA 3: Listar o nome dos projetos ATIVOS e a meta que ainda falta atingir, limitado a 1. (WHERE e Subtração)
SELECT
    Nome AS Projeto,
    MetaArrecadacao - ValorArrecadado AS FaltaArrecadar
FROM PROJETO
WHERE Status = 'ATIVO'
ORDER BY FaltaArrecadar DESC
LIMIT 1;


-- REQUISITO 3: Script com ao menos três comandos UPDATE e três de DELETE com condições.

-- UPDATE 1: Aumentar o valor arrecadado de todos os projetos ATIVOS em R$ 100,00 (doação geral).
UPDATE PROJETO
SET ValorArrecadado = ValorArrecadado + 100.00
WHERE Status = 'ATIVO';

-- UPDATE 2: Alterar o status de participação do voluntário João Santos para 'CONCLUÍDO' (assumindo que ele terminou o trabalho).
UPDATE PARTICIPACAO
SET StatusAlocacao = 'CONCLUIDO', CertificadoEmitido = TRUE
WHERE ID_Voluntario = 2 AND ID_Oportunidade = 2;

-- UPDATE 3: Corrigir o telefone da Empresa Solidária (ID_Doador = 1).
UPDATE DOADOR
SET Telefone = '(11) 3555-4000'
WHERE ID_Doador = 1;

-- DELETE 1: Remover doadores que só fizeram doações com status 'FALHOU' (Simulação: Se houvesse algum registro FALHOU, este comando limparia o doador).
-- NOTA: Este comando é seguro pois a FK está configurada para não permitir a deleção de um doador que tem DOACOES APROVADAS.
DELETE FROM DOADOR
WHERE ID_Doador IN (
    SELECT ID_Doador FROM DOACAO
    WHERE Status = 'FALHOU'
);

-- DELETE 2: Remover uma Oportunidade que está FECHADA e não tem participação alocada.
DELETE FROM OPORTUNIDADE
WHERE Status = 'FECHADA' AND ID_Oportunidade = 2;

-- DELETE 3: Remover o registro do Administrador 'Pedro Souza' (ID_Admin = 2), após reatribuir seus projetos (necessita ON UPDATE/DELETE, mas para o exercício, simulamos uma deleção simples).
-- Nota: Em um sistema real, seria necessário reatribuir o ID_Admin dos PROJETOS antes de deletar.
DELETE FROM ADMINISTRADOR
WHERE Nome = 'Pedro Souza' AND Permissao = 'PROJETOS';

-- ######################################################################
-- # FIM DO SCRIPT
-- ######################################################################