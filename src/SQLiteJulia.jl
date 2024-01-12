using SQLite

# Cria uma conexão com o banco de dados
db = SQLite.DB("banco_dados.db")

# Cria a tabela para armazenar as informações de glicemia
SQLite.execute(db, """
    CREATE TABLE IF NOT EXISTS glicemia (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        horario TEXT NOT NULL,
        valor_glicemico REAL NOT NULL,
        tipo_refeicao TEXT NOT NULL,
        tipo_alimento TEXT NOT NULL,
        observacao TEXT
    );
""")

# Função para inserir dados na tabela
function cadastrar_glicemia(db, data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao)
    SQLite.execute(db, """
        INSERT INTO glicemia (data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao)
        VALUES (?, ?, ?, ?, ?, ?);
    """, (data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao))
end

# Fecha a conexão com o banco de dados
SQLite.close(db)
