CREATE DATABASE cursor_SQL
USE cursor_SQL

CREATE TABLE curso (
codigo		INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
duracao		INT				NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina (
codigo		VARCHAR(100)			NOT NULL,
nome		VARCHAR(100)			NOT NULL,
carga_horaria		INT				NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina_curso (
codigo_disciplina		VARCHAR(100)			NOT NULL,
codigo_curso			INT						NOT NULL
PRIMARY KEY (codigo_disciplina, codigo_curso)
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY (codigo_curso) REFERENCES curso(codigo)
)

INSERT INTO curso VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logistica', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94,' Gestão Empresarial', 2600)

INSERT INTO disciplina VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80)

INSERT INTO disciplina_curso VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94)

--(Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)

CREATE FUNCTION fn_curso(@codigo_curso VARCHAR(100))
RETURNS @tabela TABLE (
	codigo_disciplina		VARCHAR(100),
	nome_disciplina			VARCHAR(100),
	carga_horaria			INT,
	nome_curso				VARCHAR(100)
	)
AS BEGIN
	DECLARE @codigo_disciplina		VARCHAR(100),
			@nome_disciplina		VARCHAR(100),
			@carga_horaria			INT,
			@nome_curso				VARCHAR(100)
	DECLARE c CURSOR FOR
		SELECT d.codigo, d.nome, d.carga_horaria, c.nome
		FROM disciplina d, curso c, disciplina_curso dc
		WHERE dc.codigo_curso = c.codigo AND dc.codigo_disciplina = d.codigo AND c.codigo = @codigo_curso
	OPEN C
	FETCH NEXT FROM c
		INTO @codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @tabela VALUES
		(@codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso)
		FETCH NEXT FROM c
			INTO @codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso
	END
	CLOSE c
	DEALLOCATE c
	RETURN
END

SELECT codigo_disciplina,nome_disciplina,carga_horaria,nome_curso
FROM fn_curso (48)