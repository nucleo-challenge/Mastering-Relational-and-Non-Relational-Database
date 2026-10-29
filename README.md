# Núcleo: Banco de Dados

Challenge 2026 · 1º semestre · 2TDS · Sprint 1 (Mitos e Verdades Nucleares)

Este repositório contém a modelagem e os scripts do banco de dados Oracle do Núcleo, um aplicativo mobile que combate a desinformação sobre energia nuclear por meio de jogos curtos. O aplicativo tem o jogo Mito ou Verdade, o jogo Equilíbrio da cidade, login de usuários, ranking de pontuação e um cadastro de perguntas.

Como o Sprint 1 é um Sprint Flash de ideação, o modelo guarda apenas os dados essenciais para demonstrar a ideia.

## Conteúdo do repositório

```
.
├── README.md
├── docs/
│   └── Nucleo_Challenge_1Sem_2TDS_BD.pdf
└── sql/
    └── Nucleo_Challenge_1Sem_2TDS_BD.sql
```

O PDF traz a descrição da solução, a justificativa da modelagem, os modelos conceitual, lógico e físico (3FN) e o DER na notação de Barker. O arquivo `.sql` traz os scripts DDL (criação dos objetos) e DML (inserts e consultas).

## Modelo de dados

O modelo tem quatro entidades.

| Tabela | Descrição | Usada por |
| --- | --- | --- |
| USUARIO | Jogador, com e-mail único e pontuação acumulada | Console .NET |
| PERGUNTA | Afirmação do Mito ou Verdade, com resposta (V ou F), explicação e referência | API Java |
| RESPOSTA_USUARIO | Histórico do que cada usuário respondeu e se acertou | API Java e console .NET |
| SIMULACAO_CIDADE | Cada simulação do jogo Equilíbrio da cidade, com as quantidades de cada fonte de energia | Console .NET |

Os relacionamentos são todos de um para muitos (1:N):

- um USUARIO possui várias RESPOSTA_USUARIO;
- uma PERGUNTA possui várias RESPOSTA_USUARIO;
- um USUARIO possui várias SIMULACAO_CIDADE.

A tabela RESPOSTA_USUARIO liga USUARIO e PERGUNTA e desfaz o relacionamento muitos para muitos entre elas. A pontuação fica em USUARIO e é atualizada pelas aplicações a cada resposta certa (100 pontos) ou simulação equilibrada (300 pontos). O ranking é a lista de usuários ordenada por esse campo.

## Como executar

1. Conecte-se a um schema Oracle com permissão para criar tabelas e sequences.
2. Abra `sql/Nucleo_Challenge_1Sem_2TDS_BD.sql` no Oracle SQL Developer.
3. Execute o arquivo inteiro com **Executar Script** (F5).

O script pode ser executado mais de uma vez: o bloco inicial remove as tabelas USUARIO, PERGUNTA, RESPOSTA_USUARIO e SIMULACAO_CIDADE e as sequences do projeto, caso existam, antes de recriá-las. Por isso, não execute em um schema que tenha tabelas com esses nomes que precisem ser mantidas.

Ao final da execução, o banco terá 5 usuários, 5 perguntas, 12 respostas e 6 simulações da cidade.

## Consultas de exemplo

O final do script traz duas consultas com JOIN:

1. **Perguntas respondidas corretamente por cada usuário:** une RESPOSTA_USUARIO, USUARIO e PERGUNTA e filtra as respostas com `acertou = 'S'`.
2. **Ranking de pontuação:** une USUARIO e SIMULACAO_CIDADE e mostra a pontuação total, a quantidade de simulações e os pontos obtidos na cidade por usuário.

## Integração com as aplicações

- Cada chave primária tem uma sequence própria (`seq_usuario`, `seq_pergunta`, `seq_resposta_usuario` e `seq_simulacao_cidade`), com incremento de 1 e sem cache. No JPA, use `allocationSize = 1` no `@SequenceGenerator`.
- Os campos `resposta`, `resposta_dada` e `acertou` são `CHAR(1)`: `V` ou `F` nos dois primeiros e `S` ou `N` no último. Na API Java, isso exige um enum ou um conversor no lugar de `boolean`.
- As chaves estrangeiras usam `ON DELETE CASCADE`, então excluir uma pergunta ou um usuário também remove as respostas e simulações ligadas a ele.
- O campo `senha_hash` espera a senha já criptografada. Os valores do script são apenas de demonstração.

## Integrantes

| Integrante | Responsabilidade no Sprint 1 |
| --- | --- |
| Cassio | Coordenação do grupo, Docker e Azure |
| Pedro | API Java com Spring |
| Matheus | Console .NET |
| Hugo | Aplicativo mobile em Flutter |
| Davi | Banco de dados (este repositório) |
