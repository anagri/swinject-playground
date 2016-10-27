//: Please build the scheme 'SwinjectPlayground' first
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

import Swinject

//protocol IPresenter :class {
//    var view:IView? {get set}
//    func getTodo()
//}
//
//
//class Presenter : IPresenter
//{
//    weak var view:IView?
//    init(){
//    }
//    
//    func getTodo(){
//        view?.displayTodos("1. presenter sending todos")
//    }
//    
//}
//
//protocol IView : class{
//    func displayTodos(todo:String)
//    func getTodo()
//}
//
//
//
//class View : IView
//{
//    private let presenter:IPresenter
//    init(presenter:IPresenter){
//        self.presenter = presenter
//    }
//    
//    func displayTodos(todo:String){
//        print(todo)
//    }
//    
//    func getTodo(){
//        presenter.getTodo()
//    }
//}
//
//func getView() -> IView{
//    let p = Presenter()
//    let v = View(presenter: p)
//    p.view = v
//    return v
//}
//
//let v = getView()
//v.getTodo()
//
//print("hello")


protocol IAnimal {
    var name: String { get }
}
protocol IPerson {
    var name: String { get }
    var petName: String { get }
}

class Cat: IAnimal {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class PetOwner: IPerson {
    let name: String
    let pet: IAnimal
    
    init(name: String, pet: IAnimal) {
        self.name = name
        self.pet = pet
    }
    
    var petName: String {
        get {
            return pet.name
        }
    }
}


let container = Container()
container.register(IAnimal.self) { _ in
    return Cat(name: "Mimi")
}

container.register(IPerson.self) { r in
    let cat = r.resolve(IAnimal.self)!
    return PetOwner(name: "Stephen", pet: cat)
}

let animal = container.resolve(IAnimal.self)!

print(animal.name)

let person = container.resolve(IPerson.self)!

print(person.name)
print(person.petName)

container.register(IAnimal.self) { _, petName in
    return Cat(name: petName)
}

let c = container.resolve(IAnimal.self, argument: "mycat")!

print(c.name)


container.register(IPerson.self){ (r, personName:String, petName:String) in
    let cat = r.resolve(IAnimal.self, argument:petName)!
    return PetOwner(name:personName,pet:cat)
}

let p = container.resolve(IPerson.self, arguments: ("Amir", "harshad") )!

print(p.name)
print(p.petName)



class PetShopAssemblyType : AssemblyType{
    func assemble(container: Container){
        container.register(IAnimal.self) { _, petName in
            return Cat(name: petName)
        }
        
        container.register(IPerson.self){ (r, personName:String, petName:String) in
            let cat = r.resolve(IAnimal.self, argument:petName)!
            return PetOwner(name:personName,pet:cat)
        }
   
    }
}

let assembly = Assembler()

assembly.applyAssemblies([PetShopAssemblyType()])

let dog = assembly.resolver.resolve(IAnimal.self, argument:"dog")!

print(dog.name)
//

//
//let animal = container.resolve(AnimalType.self)!
//let person = container.resolve(PersonType.self)!
//let pet = (person as! PetOwner).pet
//
//print(animal.name)
//print(animal is Cat)
//print(person.name)
//print(person.petName)
//print(person is PetOwner)
//print(pet.name)
//print(pet is Cat)
//
//
//container.register(IAnimal.self) { _, name in Cat(name: name) }
//
//
//let amirsCat = container.resolve(IAnimal.self, argument:"Amir's Cat")!
//
//print(amirsCat.name)
//
//container.register(IPerson.self) { (r, animalName:String, ownerName:String) in
//    PetOwner(name: ownerName, pet: r.resolve(IAnimal.self, argument:animalName)!)
//}
//
//let ownerWithMyCat = container.resolve(IPerson.self, arguments:("myCat", "owner"))!
//
//print(ownerWithMyCat.name)
//print(ownerWithMyCat.petName)
