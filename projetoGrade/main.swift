//
//  main.swift
//  projetoGrade
//
//  Created by Mateus Nobre Ferreira on 12/03/20.
//  Copyright © 2020 Mateus Nobre Ferreira. All rights reserved.
//


import Foundation

func start(){
    GerenciaDisciplinas.sharedInstance.start(filePath: "/Users/mateusnobre/Teste/DISCIPLINAS.csv")
}


func menu() {

    let menuStr = """
    *-----------------------------------------*
    01. Ver grade horaria criada
    02. Editar disciplinas da grade atual
    03. Ver disciplinas possíveis (Em progresso)
    04. Ver disciplinas feitas
    05. Editar disciplinas feitas
    06. Ver todas as Disciplinas
    07. Gerar semestres ótimos (Em progresso)
    08. Ver disciplinas Possiveis
    10. Sair
    *-----------------------------------------*\n
    
    """

    print(menuStr)
    
    menuWhile: while true {
    
        let option = Int(readLine()!)!

        switch option {
        case 1:
            GerenciaDisciplinas.sharedInstance.verGrade()
        case 2:
            print("""
            \n*-------------------------------*
            01. Adicionar Disciplinas
            02. Remover Disciplinas
            03. Voltar
            *-------------------------------*\n
            """)
            let option2 = Int(readLine()!)!
            switch option2 {
            case 1:
                print("Digite o ID das disciplinas a serem inseridas (separe por espaco)")
                let str:String = readLine()!
                let keys:[String] = str.split(separator: " ").map {  String($0) }
                print(GerenciaDisciplinas.sharedInstance.adicionaDisciplinasGradeSalva(disciplinasID: keys))
            case 2:
                print("Opcao 02")
                print("Digite o ID das disciplinas a serem removidas (separe por espaco)")
                let str:String = readLine()!
                let keys:[String] = str.split(separator: " ").map {  String($0) }
                print(GerenciaDisciplinas.sharedInstance.removeDisciplinaGradeSalva(disciplinasID:keys))
            case 3:
                print("Voltando...")
            default:
                print("Opcao desconhecida")
            }
        case 3:
            print("Opcao 03")
        case 4:
            GerenciaDisciplinas.sharedInstance.getDisciplinasFeitas()
       // case 5:
//            print("Opcao 05")
//            print("""
//            \n*-------------------------------*
//            01. Adicionar Disciplinas
//            02. Remover Disciplinas
//            03. Voltar
//            *-------------------------------*\n
//            """)
//            let option2 = Int(readLine()!)!
//            switch option2 {
//            case 1:
//                print("Digite o ID das disciplinas a serem inseridas (separe por espaco)")
//                let str:String = readLine()!
//                let keys:[String] = str.split(separator: " ").map {  String($0) }
//                print(GerenciaDisciplinas.sharedInstance.adicionaDisciplinaFeita(disciplinasID: keys))
//            case 2:
//                print("Digite o ID das disciplinas a serem removidas (separe por espaco)")
//                let str:String = readLine()!
//                let keys:[String] = str.split(separator: " ").map {  String($0) }
//                print(GerenciaDisciplinas.sharedInstance.removeDisciplinaFeita(disciplinasID:keys))
//            case 3:
//                print("Voltando...")
//            default:
//                print("Opcao desconhecida")
//            }
        case 6:
            GerenciaDisciplinas.sharedInstance.getTodasDisciplinas()
        
        case 7:
            print("Opcao 07")
        
        case 8:
            print("Opcao 08")
            GerenciaDisciplinas.sharedInstance.printDisciplinasPossiveis()
        case 10:
            break menuWhile
            
        default:
            print("Opcao desconhecida")
        }
        
        print(menuStr)
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------------------------- */

start()

menu()

