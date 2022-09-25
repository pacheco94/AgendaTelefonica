//SPDX-License-Identifier: GPL-3.0

/**
titule: En este contrato se desarrolla una agenda telefonica
en la cual se hace uso de una libreria de busqueda para buscar el nombre de 
una persona y sus datos dentro de una lista.
_ se usa mapping para asociar a una persona y sus datos con su hash de identificacion
_ se crea modificador para que solo el owner del contrato pueda ingresar personas dentro
de la agenda.Cualquir persona puede ver los nombres de la agenda,pero no ver sus datos.

 */ 

 pragma solidity ^0.8.0;
 pragma experimental ABIEncoderV2;
 
 
 library Search{
    //funcion de busqueda dentro de una lista 
    function search(uint[] memory _list, uint _valor) internal pure returns(uint){
         int not = -1;
        for(uint i = 0; i < _list.length ; i++)
          if(_valor == _list[i]) return i;
            return uint(not);
    }
 }
 //creando el contrato de agenda telefonica
 contract Agenda{
    // uso de la libreria de busqueda
    using Search for uint[];

    //declarando el owner del contrato y su constructor
    address owner;
    constructor(){
        owner = msg.sender;
    }

    //declarando el tipo de datos struct
    struct Person{
        string name;
        string surename;
        string id;
        uint cellphone;
    }
    //definiendo el tipo de dato struct
    Person[] listpersons;

    //declarando el mapping para guardar los datos
    mapping(bytes32 => Person) persons;

    //lista de string para guardar los nombres de las personas
     string [] listnames;

     //lista para guardar los numeros de celular
     uint[] listcellphone;

    // modificador para ingresar personas en la lista
    modifier onlyOwner(){
        require(msg.sender == owner,"No tienes permisos");
        _;
    }

    //declarando evento para saber que se ingreso a una persona
    event Ingresado(string _name, string _surename, string _id, uint _cellphone);

    ///dev: funcion para ingresar personas en la agenda solo el owner del contrato
    function IngresarPersona(string memory _name, string memory _surename, string memory _id, uint _cellphone) public onlyOwner{
      for(uint i = 0; i < listpersons.length; i++){
        require(keccak256(abi.encodePacked(_id)) != keccak256(abi.encodePacked(listpersons[i].id)),"Ya esta en la agenda");
      }
      listpersons.push(Person(_name, _surename, _id, _cellphone));

      //guaradamos los datos de la persona en el mapping como clave el hash de si id
      bytes32 hashId = keccak256(abi.encodePacked(_cellphone));
      persons[hashId] = Person(_name, _surename, _id, _cellphone);

      //guardamos en la lista de nombres las personas que ingresamos en la lista de agenda
      listnames.push(_name);

      //guardamos los  numeros de los cell en una lista para buscar una persona desde su numero de telefono
      listcellphone.push(_cellphone);

      //emitimos el evento
      emit Ingresado(_name, _surename, _id, _cellphone);
    }

    // funcion para ver cuantas parsonas existen en la agenda retornamos el array de nombres
    function lookAgenda() public view returns(string[] memory){
        return listnames;
    }

    //funcion para buscar una persona por su numero de telefono y si existe retornar sus datos mapping
    //ejecutable solo por owner
    function SearchPerson(uint _cellphone) public view onlyOwner returns(Person memory _persons) {
      int  not = -1;
       uint finded = listcellphone.search(_cellphone);
       if(finded != uint(not))
       //convertir el numemro de telefone en un hash
       _persons =  persons[keccak256(abi.encodePacked(_cellphone))];
       return _persons;
    }


 }