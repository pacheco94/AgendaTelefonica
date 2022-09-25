const { assert } = require("chai");

const agendatelefonica = artifacts.require("Agenda");
  
contract("agendatelefonica", (acounts) =>{
    
    let agendatelefonicaInstance = null; // instanciamos el contrato
    //declramos las variables de los contratos
     name = 'george';
     surename = 'pacheco';
     id = '123';
     phone = 0674266412;
     owner = acounts[0];
     user1 = acounts[1];

    beforeEach(async () => {
       agendatelefonicaInstance = await agendatelefonica.deployed();
    });
    it("should deployes the contract", async () =>{
        //muetra la direccion del contrato
        console.log(agendatelefonica.address);
        assert(agendatelefonica !== ''); //si retorna vacio es que no se deployo  
    });
    //test de la funcion IngresarPersona
    it("shoud put a parson inside of list person", async () =>{
        const result = await agendatelefonicaInstance.IngresarPersona('george', 'pacheco','123',0674266412, {from: owner});
        return result;
    });
    //test no se debe ejecutar con otra cuenta que no sea la del dueno
    it("should not deploy with other acount that first acount ",async () => {
        try{
            await agendatelefonicaInstance.IngresarPersona('george', 'pacheco','123',0674266412, {from: user1});
            assert(false);
        }catch(err){
            assert(err);
        }
    });

    //probando que lo q existe en el struct es lo correcto
    it("Incide the agent should be have: george,pachaco,123, 0674266412",async () => {
        try{
         await agendatelefonicaInstance.IngresarPersona('george', 'pacheco','123',0674266412, {from:owner});
         assert(false);
        }catch(err){
            assert(err);
        }
    });

    //Probamos la funcion ver lista de numbres que es una funcion publica
    it("Should return the list names of the agende", async () => {
        let _stringsnames = await agendatelefonicaInstance.lookAgenda.call();
        let stringname = 'george';
        assert.equal(_stringsnames, stringname,"Should have names incide.");
    });
      //Pruebar el nombre deveria ser el ingrasado
    it("Should return name: george and not other one.", async () => {
        try{
            await agendatelefonicaInstance.lookAgenda.call()
            assert(false);
        }catch(err){
            assert(err);
        }
    });

});

