//
//  GerenciaDisciplinas.swift
//  projetoGrade
//
//  Created by Mateus Nobre Ferreira on 30/03/20.
//  Copyright © 2020 Mateus Nobre Ferreira. All rights reserved.
//

import Foundation


enum WeekDay {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

struct ClassHour {
    var startHour: Float
    var endHour: Float
    var weekDay: WeekDay
}

struct Discipline {
    let name: String
    let id: String
    let horarios: [ClassHour]
    let creditos: Int
    let semestre: Int
    let preReq: [String]
}


class GerenciaDisciplinas {

    var todasDisciplinas:[String: Discipline] = [:]
    private var disciplinasFeitas:[String: Discipline] = [:]
    private var disciplinasGradeSalva:[Discipline] = []
    private(set) var disciplinasPossiveis:[Discipline] = []
    static let instance = GerenciaDisciplinas()
    
    
    class var sharedInstance: GerenciaDisciplinas {
        return GerenciaDisciplinas.instance
    }
    
    
    private init(){}
    
    
    func start(todasFilePath:String, feitasFilePath:String){
        self.csvToDisciplinas(filePath:todasFilePath)
        self.csvToDisciplinasFeitas(filePath: feitasFilePath)
        self.disciplinasPossiveis = self.preencheDisciplinasPossiveis()
    }
    
    
    private func csvToDisciplinasFeitas(filePath: String){
        let fileURL: URL = URL(fileURLWithPath: filePath)
        do{
            let stringFromFile: String = try String(contentsOf: fileURL)
            let feitasId:[String] = stringFromFile.split(separator: "\r\n").map{ String($0) }
            for disc in feitasId {
                disciplinasFeitas[disc] = todasDisciplinas[disc]!
            }
        }catch {
            print(error.localizedDescription)
            return
        }
    }
    
    
    private func csvToDisciplinas(filePath: String){
        let fileURL: URL = URL(fileURLWithPath: filePath)
        do {
            let stringFromFile: String = try String(contentsOf: fileURL)
        
            let linesString = stringFromFile.split(separator: "\r\n")
            
            var firstLine:String?
            
            for line in linesString {
                guard firstLine != nil else {
                    firstLine = String(line)
                    continue
                }
                //Create Discipline from File
                let infoLine = line.split(separator: ",")
          
                let preReqString:[String] = infoLine.count > 5 ? infoLine[5].split(separator: ";").map{String($0)} : []
                
                var horarios:[ClassHour] = []
                let discHorariosString = infoLine[2].split(separator: ";")
                for horarioString in discHorariosString {
                    let horarioInfo = horarioString.split(separator: ":")
                    let horasString = horarioInfo[1].split(separator: "-")
                    let horas = horasString.map{ Float($0)! }
                    var day: WeekDay?
                    switch horarioInfo[0] {
                    case "mon":
                        day = .monday
                    case "tue":
                        day = .tuesday
                    case "wed":
                        day = .wednesday
                    case "thu":
                        day = .thursday
                    case "fri":
                        day = .friday
                    case "sat":
                        day = .saturday
                    default:
                        break
                    }
                    let horario = ClassHour(startHour: horas[0], endHour: horas[1], weekDay: day!)
                    horarios.append(horario)
                }
                todasDisciplinas[String(infoLine[0])] =
                Discipline(name: String(infoLine[1]), id: String(infoLine[0]), horarios: horarios, creditos: Int(String(infoLine[3]))!, semestre: Int(String(infoLine[4]))!, preReq: preReqString)
                
            }
            return
        
        } catch {
            print(error.localizedDescription)
            return
        }
        
    }
    
    
    private func preencheDisciplinasPossiveis()->[Discipline]{
        
        var disciplinasPossiveis:[Discipline] = []
        itDiscs: for (key, disciplina) in self.todasDisciplinas{
            
            guard disciplinasFeitas[key] == nil else {
                continue
            }
            for preReqKey in disciplina.preReq{
                guard disciplinasFeitas[preReqKey] != nil else {
                    continue itDiscs
                }
            }
            for discSalva in self.disciplinasGradeSalva {
                guard !self.chocaHorarios(discSalva, disciplina) else {
                    continue itDiscs
                }
            }
            
            disciplinasPossiveis.append(disciplina)
        }
        
        return disciplinasPossiveis
    }
    
    
    public func getTodasDisciplinas() {
        
        print("Todas as Disciplinas:\n")
        for i in todasDisciplinas {
            print("Disciplina: \(i.value.name)\nID: \(i.value.id) | Créditos: \(i.value.creditos)\n")
        }
    }
    
    
    public func printDisciplinasPossiveis() {
        
        print("Disciplinas Possiveis:\n")
        for i in preencheDisciplinasPossiveis() {
            print("Disciplina: \(i.name)\nID: \(i.id) | Créditos: \(i.creditos) | Semestre: \(i.semestre) \n")
        }
    }
    
    
    func printArrayDisciplinas(_ discs:[Discipline]){
        for i in discs {
            print("Disciplina: \(i.name)\nID: \(i.id) | Créditos: \(i.creditos) | Semestre: \(i.semestre) \n")
        }
    }
    
    
    public func getDisciplinasFeitas() {
        
        print("Disciplinas feitas:\n")
        for i in disciplinasFeitas {
            //print("Disciplina: \(i.value.name)")
            print("Disciplina: \(i.value.name)\nID: \(i.value.id) | Créditos: \(i.value.creditos)\n")
        }
    }
    
    public func getDisciplinasGradeSalva() -> [Discipline] {
      return disciplinasGradeSalva
    }

    
    func adicionaDisciplinasGradeSalva(disciplinasID: [String]) -> [Bool] {
        var deuCerto:[Bool] = []
        for disciplinaID in disciplinasID {
            if todasDisciplinas[disciplinaID] != nil {
                var possivel: Bool = true
                disciplinasGradeSalva.forEach {
                  if chocaHorarios($0, todasDisciplinas[disciplinaID]!){
                    possivel = false
                  }
                }
                
                let filt = self.preencheDisciplinasPossiveis().filter{$0.id == disciplinaID}
                if(filt.count == 0){ possivel = false }
                
                if possivel {
                  deuCerto.append(true)
                  disciplinasGradeSalva.append(todasDisciplinas[disciplinaID]!)
                }else{
                  deuCerto.append(false)
                }
            } else{
                deuCerto.append(false)
            }
        }
        return deuCerto
    }

    func removeDisciplinaGradeSalva(disciplinasID: [String]) -> [Bool] {
        print(disciplinasID)
        var deuCerto:[Bool] = []
        for disciplinaID in disciplinasID {
            if todasDisciplinas[disciplinaID] != nil {
               var temp = false
               for (i, disc) in disciplinasGradeSalva.enumerated(){
                  if disc.id == disciplinaID {
                    disciplinasGradeSalva.remove(at: i)
                    temp = true
                  }
                }
                deuCerto.append(temp)
            }else {
                deuCerto.append(false)
            }
        }
        return deuCerto
    }
    
    
    func chocaHorarios(_ disciplina1: Discipline, _ disciplina2: Discipline) -> Bool {
        
        var chocouHorario: Bool = false
        
        for aula1 in disciplina1.horarios {
            for aula2 in disciplina2.horarios {
                
                if ( aula2.startHour >= aula1.startHour && aula2.startHour < aula1.endHour ) && (aula1.weekDay == aula2.weekDay) {
                    chocouHorario = true
                }
            }
        }
        return chocouHorario
    }
    
    
    func melhorSemestre(discsPossiveis:[Discipline]) -> [Discipline] {
        
        var arrayResposta:[Discipline]?
        
        guard discsPossiveis.count != 0 else {
            return []
        }
        
        for disciplina:Discipline in discsPossiveis{
            
            var possiveisComDiscAtual: [Discipline] = []
            
            discsPossiveis.forEach{
                if(!self.chocaHorarios($0, disciplina)){
                    possiveisComDiscAtual.append($0)
                }
            }
           
            var tempArray:[Discipline] = melhorSemestre(discsPossiveis: possiveisComDiscAtual)
            
            tempArray.append(disciplina)
            
            guard arrayResposta != nil else{
                arrayResposta = tempArray
                continue
            }
            
            if self.avaliaEMelhor(atual: arrayResposta!, novo: tempArray){
                arrayResposta  = tempArray
                
            }
        }
        return arrayResposta!
    }
    
    
    private func avaliaEMelhor(atual:[Discipline], novo: [Discipline])->Bool{
        
        var creditosAtual = 0, creditosNovo = 0, somaSemestreAtual = 0, somaSemestreNovo=0
        
        atual.forEach{
            creditosAtual+=$0.creditos
            somaSemestreAtual+=$0.semestre
        }
        
        novo.forEach{
            creditosNovo+=$0.creditos
            somaSemestreNovo+=$0.semestre
        }
        
        if creditosNovo>creditosAtual {
            return true
        }else if creditosNovo == creditosAtual && somaSemestreNovo < somaSemestreAtual {
            return true
        }
        
        return false
    }
    
    
    func printGrade() {
        let disciplinas = disciplinasGradeSalva
        let semana = [
        WeekDay.monday : disciplinas.filter {$0.horarios.filter{$0.weekDay == WeekDay.monday}.count > 0},
        WeekDay.tuesday : disciplinas.filter {$0.horarios.filter{$0.weekDay == WeekDay.tuesday}.count > 0} ,
        WeekDay.wednesday : disciplinas.filter {$0.horarios.filter{$0.weekDay == WeekDay.wednesday}.count > 0} ,
        WeekDay.thursday : disciplinas.filter {$0.horarios.filter{$0.weekDay == WeekDay.thursday}.count > 0} ,
        WeekDay.friday : disciplinas.filter {$0.horarios.filter{$0.weekDay == WeekDay.friday}.count > 0} ,
        WeekDay.saturday : disciplinas.filter {$0.horarios.filter{$0.weekDay == WeekDay.saturday}.count > 0}
        ]
        
        let orderWeek = [WeekDay.monday, WeekDay.tuesday, WeekDay.wednesday, WeekDay.thursday, WeekDay.friday, WeekDay.saturday]

        print("\nGRADE DE HORARIOS SALVA: \n")
        for key in orderWeek {
            
            var discsTuplas = semana[key]!.map { ($0.name, $0.horarios.filter{$0.weekDay == key}[0]) }
            
            discsTuplas.sort{ $0.1.startHour < $1.1.startHour }
            
            print("\(weekDaytoString(key)): ")
            discsTuplas.forEach{
                print("\($0.1.startHour) - \($0.1.endHour): \($0.0)    ")
            }
            print()
        }
    }
    
    
    private func weekDaytoString(_ weekDay:WeekDay)->String{
        switch weekDay {
        case .monday:
            return "Segunda"
        case .tuesday:
            return "Terça"
        case .wednesday:
            return "Quarta"
        case .thursday:
            return "Quinta"
        case .friday:
            return "Sexta"
        case .saturday:
            return "Sábado"
            
        }
    }
}


