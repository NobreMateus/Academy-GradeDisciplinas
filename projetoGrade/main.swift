//
//  main.swift
//  projetoGrade
//
//  Created by Mateus Nobre Ferreira on 12/03/20.
//  Copyright © 2020 Mateus Nobre Ferreira. All rights reserved.
//

/*
01. Ver grade horaria 
02. Ver disciplinas possiveis
03. Ver disciplinas feitas
04. Gerar semestres otimos
05. Editar disciplinas feitas
*/

import Foundation


class GerenciaDisciplinas {

    static let instance = GerenciaDisciplinas()
    
    class var sharedInstance: GerenciaDisciplinas {
        return GerenciaDisciplinas.instance
    }
    
    private init(){}
    
    /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
    
    enum WeekDay {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    struct ClassHour{
        var startHour: Float
        var endHour: Float
        var weekDay: WeekDay
    }

    struct Discipline{
        let name: String
        let id: String
        let preRequisitos: [Discipline]
        let horarios: [ClassHour]
        let creditos: Int
        let semestre: Int
    }

    private let disciplinasPossiveis:[String: Discipline] = [
        "ENG01": Discipline(name:"Teste", id:"ENG01", preRequisitos: [], horarios: [ClassHour(startHour:13.5, endHour: 15.5, weekDay: WeekDay.monday)], creditos: 2, semestre: 1),
        "ENG02": Discipline(name:"Teste2", id:"ENG02",preRequisitos: [], horarios: [ClassHour(startHour:13.5, endHour: 15.5, weekDay: WeekDay.monday)], creditos: 6, semestre: 1),
        "ENG03": Discipline(name:"Teste3", id:"ENG03", preRequisitos: [], horarios: [ClassHour(startHour:13.5, endHour: 15.5, weekDay: WeekDay.friday)], creditos: 4, semestre: 1)
    ]
    
    private var disciplinasFeitas:[String: Discipline] = [:]
    
    public func getDisciplinasPossiveis() -> [String:Discipline]{
        return disciplinasPossiveis
    }
    
    public func getDisciplinasFeitas() -> [String: Discipline]{
        return disciplinasFeitas
    }
    
    /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
    
    func adicionaDisciplinaFeita(disciplinasID: [String]) -> [Bool] {
        var deuCerto:[Bool] = []
        for disciplinaID in disciplinasID {
//            disciplinasFeitas.append(disciplinasPossiveis[disciplinaID]!)
            if disciplinasPossiveis[disciplinaID] != nil {
                disciplinasFeitas[disciplinaID] = disciplinasPossiveis[disciplinaID]!
                deuCerto.append(true)
            } else{
                deuCerto.append(false)
            }
                
        }
        return deuCerto
    }
    
    func adicionaDisciplinaFeita(disciplinasID: String...) -> [Bool]{
        return adicionaDisciplinaFeita(disciplinasID: disciplinasID)
    }
    
    func removeDisciplinaFeita(disciplinasID: [String]) -> [Bool] {
        var deuCerto:[Bool] = []
        for disciplinaID in disciplinasID {
            if disciplinasFeitas[disciplinaID] != nil {
                disciplinasFeitas[disciplinaID] = nil
                deuCerto.append(true)
            }else {
                deuCerto.append(false)
            }
        }
        return deuCerto
    }
    
    func removeDisciplinaFeita(disciplinasID: String...) -> [Bool]{
        return removeDisciplinaFeita(disciplinasID: disciplinasID)
    }
    //print(disciplines["ENG01"]!.creditos)

    /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
    
    func chocaHorarios(disciplina1: Discipline, disciplina2: Discipline) -> Bool {
        
        var chocouHorario = false
        
        for aula1 in disciplina1.horarios {
            for aula2 in disciplina2.horarios {
                
                if(!(aula2.endHour < aula1.startHour) && aula1.weekDay == aula2.weekDay) {
                    chocouHorario = true
                } else {
                    chocouHorario = false
                }
            }
        }
        return chocouHorario
    }
    //print(chocaHorarios(disciplina1: disciplinasPossiveis["ENG02"]!, disciplina2: disciplinasPossiveis["ENG03"]!))
    
    /* ----------------------------------------------------------------------------------------- ---------------------------------------------------------- */


    func verGrade(disciplina: [Discipline]) {
        
        for diaSemana in 1...6 {
            
            for disciplina in disciplina{
                
            }
            
        }
            
        
    }
}
    
/* --------------------------------------------------------------------------------------------------------------------------------------------------- */


func main() {
    
    
}

/* --------------------------------------------------------------------------------------------------------------------------------------------------- */


func menu() {

    print("""
    *-----------------------------------------*
    01. Ver grade horaria
    02. Ver disciplinas possiveis
    03. Ver disciplinas feitas
    04. Gerar semestres otimos
    05. Editar disciplinas feitas
    06. Ver todas as Disciplinas
    07. Adicionar disciplina a grade atual
    10. Sair
    *-----------------------------------------*\n
    """)
    
    menuWhile: while true {
    
        let option = Int(readLine()!)!
        
        switch option {
        case 1:
            print("Opcao 01")
            //verGrade()
        case 2:
            print("Opcao 02")
        case 3:
            print("Opcao 03")
            print(GerenciaDisciplinas.sharedInstance.getDisciplinasFeitas())
        case 4:
            print("Opcao 04")
        case 5:
            print("Opcao 05")
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
                print(GerenciaDisciplinas.sharedInstance.adicionaDisciplinaFeita(disciplinasID: keys))
            case 2:
                print("Digite o ID das disciplinas a serem removidas (separe por espaco)")
                let str:String = readLine()!
                let keys:[String] = str.split(separator: " ").map {  String($0) }
                print(GerenciaDisciplinas.sharedInstance.removeDisciplinaFeita(disciplinasID:keys))
            case 3:
                print("Voltando...")
            default:
                print("Opcao desconhecida")
            }
        case 6:
            print("Opcao 6")
            print(GerenciaDisciplinas.sharedInstance.getDisciplinasPossiveis())
            
        case 10:
            break menuWhile
            
        default:
            print("Opcao desconhecida")
        }
        
        print("""
        \n*-----------------------------------------*
        01. Ver grade horaria
        02. Ver disciplinas possiveis
        03. Ver disciplinas feitas
        04. Gerar semestres otimos
        05. Editar disciplinas feitas
        06. Ver todas as Disciplinas
        10. Sair
        *-----------------------------------------*\n
        """)
    }
}

menu()
