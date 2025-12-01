-- ######################################################################
-- # SCRIPT SQL COMPLETO (DDL & DML) - ONG FIO DO BEM
-- # CORREÇÃO FINAL DE ERROS DE INTEGRIDADE (#1062 e #1451)
-- ######################################################################

-- FASE 1: DDL - CRIAÇÃO DA ESTRUTURA (Com DROP TABLE para garantir limpeza)
-- O comando DROP TABLE é crucial para evitar o erro #1062 (Entrada Duplicada)
-- As tabelas são deletadas na ordem inversa de dependência (filhas antes dos pais).
DROP TABLE IF EXISTS PARTICIPACAO;
DROP TABLE IF EXISTS DOACAO;
DROP TABLE IF EXISTS OPORTUNIDADE;
DROP TABLE IF EXISTS VOLUNTARIO;
DROP TABLE IF EXISTS DOADOR;
DROP TABLE IF EXISTS PROJETO;
DROP TABLE IF EXISTS ADMINISTRADOR;
DROP TABLE IF EXISTS CATEGORIA;

-- CRIAÇÃO DAS TABELAS (8)

CREATE TABLE CATEGORIA (
    ID_Categoria INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50) UNIQUE NOT NULL, -- Restrição UNIQUE causa o erro #1062 se DROP não funcionar
    Descricao TEXT
);

CREATE TABLE ADMINISTRADOR (
    ID_Admin INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    SenhaHash CHAR(60) NOT NULL,
    Permissao ENUM('TOTAL', 'PROJETOS') NOT NULL
);

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

CREATE TABLE DOADOR (
    ID_Doador INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    TipoPessoa ENUM('FISICA', 'JURIDICA') NOT NULL
);

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
-- # FASE 2: DML - INSERÇÃO DE DADOS (POPULANDO AS TABELAS)
-- ######################################################################

INSERT INTO CATEGORIA (Nome, Descricao) VALUES
('Vestuário', 'Projetos focados em roupas e acessórios'),
('Inverno', 'Campanhas sazonais de frio e agasalhos'),
('Logística', 'Projetos de infraestrutura e transporte');

INSERT INTO ADMINISTRADOR (Nome, Email, SenhaHash, Permissao) VALUES
('Ana Silva', 'ana.admin@fiodobem.org', 'HASH_FICTICIO', 'TOTAL'),
('Pedro Souza', 'pedro.proj@fiodobem.org', 'HASH_FICTICIO', 'PROJETOS');

INSERT INTO VOLUNTARIO (Nome, CPF, Email, Telefone, DataNascimento, Endereco, Cidade, UF) VALUES
('Maria Oliveira', '111.111.111-11', 'maria.voluntaria@email.com', '(11) 98888-7777', '1995-10-20', 'Rua das Flores, 100', 'São Paulo', 'SP'),
('João Santos', '222.222.222-22', 'joao.log@email.com', '(21) 96666-5555', '1990-03-15', 'Av. Central, 50', 'Rio de Janeiro', 'RJ'),
('Lucas Mendes', '333.333.333-33', 'lucas.mendes@email.com', '(41) 94444-3333', '2000-07-25', 'Rua Curitiba, 20', 'Curitiba', 'PR');

INSERT INTO DOADOR (Nome, Email, Telefone, TipoPessoa) VALUES
('Empresa Solidária LTDA', 'contato@empresa.com', '(11) 3000-4000', 'JURIDICA'),
('Carlos Pereira', 'carlos@email.com', '(11) 91111-2222', 'FISICA'),
('Lojas Moda Fácil', 'doacao@modafacil.com', '(11) 5000-6000', 'JURIDICA');

INSERT INTO PROJETO (Nome, Descricao, MetaArrecadacao, ValorArrecadado, DataInicio, DataFim, Status, ID_Categoria, ID_Admin) VALUES
('Campanha Calor que Aquece', 'Arrecadação de fundos para 5000 kits de inverno.', 50000.00, 45000.00, '2025-05-01', '2025-08-31', 'ATIVO', 2, 1),
('Programa Roupa Nova', 'Financiamento contínuo para produção de vestuário básico.', 10000.00, 10000.00, '2024-01-01', NULL, 'CONCLUIDO', 1, 2);

INSERT INTO OPORTUNIDADE (Titulo, Descricao, CargaHorariaEstimada, DataLimiteInscricao, Status, ID_Projeto) VALUES
('Triagem e Organização', 'Ajuda na separação de roupas do inverno.', 40, '2025-07-15', 'ABERTA', 1),
('Apoio em Redes Sociais', 'Criação de conteúdo para divulgação de impacto.', 20, '2025-06-30', 'FECHADA', 2);

INSERT INTO DOACAO (Valor, DataHora, Status, ID_Doador, ID_Projeto) VALUES
(25000.00, '2025-06-01 10:00:00', 'APROVADA', 1, 1),
(50.00, '2025-06-05 14:30:00', 'APROVADA', 2, 1),   
(10000.00, '2024-03-10 09:00:00', 'APROVADA', 3, 2);

INSERT INTO PARTICIPACAO (ID_Voluntario, ID_Oportunidade, DataInscricao, StatusAlocacao, CargaHorariaRealizada, CertificadoEmitido) VALUES
(1, 1, '2025-06-10', 'ALOCADO', NULL, FALSE), 
(2, 2, '2025-06-01', 'ALOCADO', 20.00, TRUE); 


-- ######################################################################
-- # FASE 3: DML - MANIPULAÇÃO DE DADOS (UPDATE e DELETE)
-- ######################################################################

-- UPDATE 1: Aumentar o valor arrecadado de todos os projetos ATIVOS em R$ 100,00.
UPDATE PROJETO
SET ValorArrecadado = ValorArrecadado + 100.00
WHERE Status = 'ATIVO';

-- UPDATE 2: Alterar o status de participação do voluntário João Santos para 'CONCLUÍDO'.
UPDATE PARTICIPACAO
SET StatusAlocacao = 'CONCLUIDO', CertificadoEmitido = TRUE
WHERE ID_Voluntario = 2 AND ID_Oportunidade = 2;

-- UPDATE 3: Corrigir o telefone da Empresa Solidária (ID_Doador = 1).
UPDATE DOADOR
SET Telefone = '(11) 3555-4000'
WHERE ID_Doador = 1;


-- BLOCO DELETE CORRIGIDO PARA INTEGRIDADE REFERENCIAL (#1451)

-- DELETE 1 (Limpa a FK): Remove o registro da PARTICIPACAO antes de deletar a OPORTUNIDADE.
DELETE FROM PARTICIPACAO 
WHERE ID_Voluntario = 2 AND ID_Oportunidade = 2; 

-- DELETE 2 (Ajusta a FK): Reatribui o projeto do Admin 2 para o Admin 1 (Ana Silva).
UPDATE PROJETO
SET ID_Admin = 1
WHERE ID_Admin = 2;

-- DELETE 3: Deleta o Administrador 'Pedro Souza' (ID=2).
DELETE FROM ADMINISTRADOR
WHERE ID_Admin = 2; 

-- DELETE 4: Deleta a Oportunidade 2 (agora que a PARTICIPACAO foi resolvida).
DELETE FROM OPORTUNIDADE
WHERE Status = 'FECHADA' AND ID_Oportunidade = 2; 

-- ######################################################################
-- # FASE 4: DML - CONSULTAS (SELECTs de Requisito)
-- ######################################################################

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

-- CONSULTA 3: Listar o nome dos projetos ATIVOS e a meta que ainda falta atingir.
SELECT
    Nome AS Projeto,
    MetaArrecadacao - ValorArrecadado AS FaltaArrecadar
FROM PROJETO
WHERE Status = 'ATIVO'
ORDER BY FaltaArrecadar DESC;

-- ######################################################################
-- # FIM DO SCRIPT
-- ######################################################################
