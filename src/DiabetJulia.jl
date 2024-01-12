module DiabetJulia

using SQLite
using DataFrames

# Função para consultar todos os registros e exibir diretamente
function consultar_todos(db)
    # Consulta todos os registros na tabela glicemia
    query = "SELECT * FROM glicemia"
    result = SQLite.DBInterface.execute(db, query)

    # Verifica se há resultados antes de tentar exibir
    if isempty(result)
        println("\nNenhum registro encontrado.")
        return
    end
    
    df = DataFrames.DataFrame(result)

    # Dicionário de mapeamento de nomes de colunas
    coluna_nomes = Dict(
        "id" => "ID",
        "data" => "Data",
        "horario" => "Horário",
        "valor_glicemico" => "Valor Glicêmico",
        "tipo_refeicao" => "Refeição",
        "tipo_alimento" => "Alimentos Consumidos",
        "observacao" => "Observação"
    )

    # Substitui nomes das colunas no DataFrame
    rename!(df, coluna_nomes)

    println("\n")
    print(df)
    println("\n")
end

# Função para consultar glicemia
function consultar_glicemia(db)
    println("Consulta de Glicemia")
    consultar_todos(db)
end

# Função para inserir dados na tabela
function cadastrar_glicemia(db, data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao)
    SQLite.execute(db, """
        INSERT INTO glicemia (data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao)
        VALUES (?, ?, ?, ?, ?, ?);
    """, (data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao))
end

# Função para cadastrar glicemia interativamente
function cadastrar_glicemia_interativo(db)
    println("Cadastro de Glicemia")
    
    print("Data (DD-MM-AAAA): ")
    data = readline()
    
    print("Horário (HH:MM:SS): ")
    horario = readline()
    
    print("Valor Glicêmico (mg/DL): ")
    valor_glicemico = parse(Float64, readline())
    
    print("Tipo de Refeição (Jejum, Café da Manhã, Almoço, Café da Tarde ou Janta): ")
    tipo_refeicao = readline()
    
    print("Tipo de Alimento Consumido: ")
    tipo_alimento = readline()
    
    print("Observação: ")
    observacao = readline()
    
    # Chama a função para inserir os dados no banco de dados
    cadastrar_glicemia(db, data, horario, valor_glicemico, tipo_refeicao, tipo_alimento, observacao)
    
    println("Cadastro realizado com sucesso!")
end

# Função para excluir um registro pelo ID
function excluir_registro(db, id)
    query = "DELETE FROM glicemia WHERE id = $id"
    SQLite.execute(db, query)
    println("\nRegistro com ID $id excluído com sucesso.")
end

# Função principal do script
function julia_main()
    # Cria uma conexão com o banco de dados
    db = SQLite.DB("banco_dados.db")

    println("💊 Bem-vindo ao DiabetJulia v1.0 💉")
    println("Software Monitorização Glicêmico Desenvolvido na Linguagem Julia")

    while true
        println("\nOpções:")
        println("╔════════════════════════════════════╗")
        println("║ 1. Cadastrar Glicemia              ║")
        println("║ 2. Consultar Glicemia              ║")
        println("║ 3. Excluir Registro por ID         ║")
        println("║ 4. Sair                            ║")
        println("╚════════════════════════════════════╝")
        print("\nDigite um número para escolher o que deseja realizar: ")

        escolha = parse(Int, readline())

        if escolha == 1
            cadastrar_glicemia_interativo(db)
        elseif escolha == 2
            consultar_glicemia(db)
        elseif escolha == 3
            print("\nDigite o ID do registro a ser excluído: ")
            id_para_excluir = parse(Int, readline())
            excluir_registro(db, id_para_excluir)
        elseif escolha == 4
            println("\nSaindo do programa.")
            SQLite.close(db)
            return 0
        else
            println("\nOpção inválida. Tente novamente.")
        end
    end
end

end # module DiabetJulia