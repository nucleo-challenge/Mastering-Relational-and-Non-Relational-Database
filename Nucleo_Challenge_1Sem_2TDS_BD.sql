

DROP TABLE resposta_usuario;
DROP TABLE simulacao_cidade;
DROP TABLE pergunta;
DROP TABLE usuario;
DROP SEQUENCE seq_usuario;
DROP SEQUENCE seq_pergunta;
DROP SEQUENCE seq_resposta_usuario;
DROP SEQUENCE seq_simulacao_cidade;


-- ---------------------------------------------------------------------


CREATE SEQUENCE seq_usuario          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pergunta         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_resposta_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_simulacao_cidade START WITH 1 INCREMENT BY 1;


-- ---------------------------------------------------------------------


CREATE TABLE usuario (
    id_usuario   NUMBER(10)    NOT NULL,
    nome         VARCHAR2(100) NOT NULL,
    email        VARCHAR2(150) NOT NULL,
    senha_hash   VARCHAR2(255) NOT NULL,
    pontuacao    NUMBER(10)    DEFAULT 0 NOT NULL,
    dt_cadastro  DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_usuario       PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_email UNIQUE (email)
);


-- ---------------------------------------------------------------------


CREATE TABLE pergunta (
    id_pergunta  NUMBER(10)     NOT NULL,
    enunciado    VARCHAR2(500)  NOT NULL,
    resposta     CHAR(1)        NOT NULL,
    explicacao   VARCHAR2(1000) NOT NULL,
    referencia   VARCHAR2(300),
    CONSTRAINT pk_pergunta          PRIMARY KEY (id_pergunta),
    CONSTRAINT ck_pergunta_resposta CHECK (resposta IN ('V', 'F'))
);


-- ---------------------------------------------------------------------


CREATE TABLE resposta_usuario (
    id_resposta    NUMBER(10) NOT NULL,
    id_usuario     NUMBER(10) NOT NULL,
    id_pergunta    NUMBER(10) NOT NULL,
    resposta_dada  CHAR(1)    NOT NULL,
    acertou        CHAR(1)    NOT NULL,
    dt_resposta    TIMESTAMP  DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_resposta_usuario          PRIMARY KEY (id_resposta),
    CONSTRAINT fk_resposta_usuario_usuario  FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario),
    CONSTRAINT fk_resposta_usuario_pergunta FOREIGN KEY (id_pergunta)
        REFERENCES pergunta (id_pergunta),
    CONSTRAINT ck_resposta_usuario_dada     CHECK (resposta_dada IN ('V', 'F')),
    CONSTRAINT ck_resposta_usuario_acertou  CHECK (acertou IN ('S', 'N'))
);


-- ---------------------------------------------------------------------


CREATE TABLE simulacao_cidade (
    id_simulacao   NUMBER(10) NOT NULL,
    id_usuario     NUMBER(10) NOT NULL,
    qtd_solar      NUMBER(1)  NOT NULL,
    qtd_eolica     NUMBER(1)  NOT NULL,
    qtd_nuclear    NUMBER(1)  NOT NULL,
    qtd_carvao     NUMBER(1)  NOT NULL,
    pontos_ganhos  NUMBER(5)  DEFAULT 0 NOT NULL,
    dt_simulacao   TIMESTAMP  DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_simulacao_cidade         PRIMARY KEY (id_simulacao),
    CONSTRAINT fk_simulacao_cidade_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
);


-- ---------------------------------------------------------------------


CREATE INDEX ix_resposta_usuario_usuario  ON resposta_usuario (id_usuario);
CREATE INDEX ix_resposta_usuario_pergunta ON resposta_usuario (id_pergunta);
CREATE INDEX ix_simulacao_cidade_usuario  ON simulacao_cidade (id_usuario);


-- ---------------------------------------------------------------------


INSERT INTO usuario (id_usuario, nome, email, senha_hash, pontuacao, dt_cadastro)
VALUES (seq_usuario.NEXTVAL, 'Marina Souza',    'marina.souza@exemplo.com',    'HASH_DEMO_MARINA',  700, DATE '2026-10-01');
INSERT INTO usuario (id_usuario, nome, email, senha_hash, pontuacao, dt_cadastro)
VALUES (seq_usuario.NEXTVAL, 'João Pereira',    'joao.pereira@exemplo.com',    'HASH_DEMO_JOAO',    400, DATE '2026-10-02');
INSERT INTO usuario (id_usuario, nome, email, senha_hash, pontuacao, dt_cadastro)
VALUES (seq_usuario.NEXTVAL, 'Ana Lima',        'ana.lima@exemplo.com',        'HASH_DEMO_ANA',     100, DATE '2026-10-03');
INSERT INTO usuario (id_usuario, nome, email, senha_hash, pontuacao, dt_cadastro)
VALUES (seq_usuario.NEXTVAL, 'Carlos Mendes',   'carlos.mendes@exemplo.com',   'HASH_DEMO_CARLOS',  500, DATE '2026-10-04');
INSERT INTO usuario (id_usuario, nome, email, senha_hash, pontuacao, dt_cadastro)
VALUES (seq_usuario.NEXTVAL, 'Beatriz Rocha',   'beatriz.rocha@exemplo.com',   'HASH_DEMO_BEATRIZ', 100, DATE '2026-10-05');


-- ---------------------------------------------------------------------


INSERT INTO pergunta (id_pergunta, enunciado, resposta, explicacao, referencia)
VALUES (seq_pergunta.NEXTVAL,
        'A energia nuclear emite fumaça poluente na atmosfera.', 'F',
        'O que sai das torres é vapor de água. Na geração de energia, as usinas nucleares emitem pouquíssimo carbono.',
        'Eletronuclear');
INSERT INTO pergunta (id_pergunta, enunciado, resposta, explicacao, referencia)
VALUES (seq_pergunta.NEXTVAL,
        'A medicina usa tecnologia nuclear para diagnosticar e tratar o câncer.', 'V',
        'Radioterapia e exames de medicina nuclear ajudam a detectar e tratar doenças com precisão.',
        'INCA - Instituto Nacional de Câncer');
INSERT INTO pergunta (id_pergunta, enunciado, resposta, explicacao, referencia)
VALUES (seq_pergunta.NEXTVAL,
        'O rejeito nuclear brilha em verde como nos desenhos.', 'F',
        'Esse brilho é ficção. O combustível é uma cerâmica sólida, armazenada com múltiplas barreiras de proteção.',
        NULL);
INSERT INTO pergunta (id_pergunta, enunciado, resposta, explicacao, referencia)
VALUES (seq_pergunta.NEXTVAL,
        'Uma usina nuclear pode gerar energia dia e noite.', 'V',
        'Ela opera continuamente, sem depender do sol ou do vento, ajudando a manter o sistema elétrico estável.',
        'IAEA - Agência Internacional de Energia Atômica');
INSERT INTO pergunta (id_pergunta, enunciado, resposta, explicacao, referencia)
VALUES (seq_pergunta.NEXTVAL,
        'O Brasil possui usinas nucleares em operação.', 'V',
        'As usinas Angra 1 e Angra 2, em Angra dos Reis (RJ), geram energia elétrica para o país.',
        'Eletronuclear');


-- ---------------------------------------------------------------------


INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 1, 1, 'F', 'S', TIMESTAMP '2026-10-10 09:15:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 1, 2, 'V', 'S', TIMESTAMP '2026-10-10 09:16:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 1, 3, 'F', 'S', TIMESTAMP '2026-10-10 09:17:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 1, 4, 'V', 'S', TIMESTAMP '2026-10-10 09:18:00');

-- João user 2: 1 acerto e 2 x's

INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 2, 1, 'V', 'N', TIMESTAMP '2026-10-11 20:05:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 2, 2, 'V', 'S', TIMESTAMP '2026-10-11 20:06:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 2, 4, 'F', 'N', TIMESTAMP '2026-10-11 20:07:00');

-- Ana user 3: 1 acerto e 1 x

INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 3, 1, 'F', 'S', TIMESTAMP '2026-10-12 18:30:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 3, 3, 'V', 'N', TIMESTAMP '2026-10-12 18:31:00');

-- Carlos user 4: 2 acertos

INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 4, 5, 'V', 'S', TIMESTAMP '2026-10-13 12:00:00');
INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 4, 2, 'V', 'S', TIMESTAMP '2026-10-13 12:01:00');

-- Beatriz user 5: 1 acerto

INSERT INTO resposta_usuario (id_resposta, id_usuario, id_pergunta, resposta_dada, acertou, dt_resposta)
VALUES (seq_resposta_usuario.NEXTVAL, 5, 3, 'F', 'S', TIMESTAMP '2026-10-14 15:45:00');


-- ---------------------------------------------------------------------


INSERT INTO simulacao_cidade (id_simulacao, id_usuario, qtd_solar, qtd_eolica, qtd_nuclear, qtd_carvao, pontos_ganhos, dt_simulacao)
VALUES (seq_simulacao_cidade.NEXTVAL, 1, 2, 2, 2, 0, 300, TIMESTAMP '2026-10-10 09:30:00');

INSERT INTO simulacao_cidade (id_simulacao, id_usuario, qtd_solar, qtd_eolica, qtd_nuclear, qtd_carvao, pontos_ganhos, dt_simulacao)
VALUES (seq_simulacao_cidade.NEXTVAL, 2, 1, 1, 0, 1, 0,   TIMESTAMP '2026-10-11 20:15:00');

INSERT INTO simulacao_cidade (id_simulacao, id_usuario, qtd_solar, qtd_eolica, qtd_nuclear, qtd_carvao, pontos_ganhos, dt_simulacao)
VALUES (seq_simulacao_cidade.NEXTVAL, 2, 1, 2, 2, 0, 300, TIMESTAMP '2026-10-11 20:25:00');

INSERT INTO simulacao_cidade (id_simulacao, id_usuario, qtd_solar, qtd_eolica, qtd_nuclear, qtd_carvao, pontos_ganhos, dt_simulacao)
VALUES (seq_simulacao_cidade.NEXTVAL, 3, 3, 3, 0, 0, 0,   TIMESTAMP '2026-10-12 18:45:00');

INSERT INTO simulacao_cidade (id_simulacao, id_usuario, qtd_solar, qtd_eolica, qtd_nuclear, qtd_carvao, pontos_ganhos, dt_simulacao)
VALUES (seq_simulacao_cidade.NEXTVAL, 4, 1, 1, 3, 0, 300, TIMESTAMP '2026-10-13 12:20:00');

INSERT INTO simulacao_cidade (id_simulacao, id_usuario, qtd_solar, qtd_eolica, qtd_nuclear, qtd_carvao, pontos_ganhos, dt_simulacao)
VALUES (seq_simulacao_cidade.NEXTVAL, 5, 0, 0, 0, 3, 0,   TIMESTAMP '2026-10-14 16:00:00');

COMMIT;


-- Consultas 


SELECT u.nome          AS usuario,
       p.enunciado     AS pergunta,
       r.resposta_dada AS resposta_dada,
       r.dt_resposta   AS respondida_em
  FROM resposta_usuario r
  JOIN usuario  u ON u.id_usuario  = r.id_usuario
  JOIN pergunta p ON p.id_pergunta = r.id_pergunta
 WHERE r.acertou = 'S'
 ORDER BY u.nome, r.dt_resposta;


SELECT u.nome                  AS usuario,
       u.pontuacao             AS pontuacao_total,
       COUNT(s.id_simulacao)   AS qtd_simulacoes,
       SUM(s.pontos_ganhos)    AS pontos_da_cidade
  FROM usuario u
  LEFT JOIN simulacao_cidade s ON s.id_usuario = u.id_usuario
 GROUP BY u.id_usuario, u.nome, u.pontuacao
 ORDER BY u.pontuacao DESC, u.nome;
