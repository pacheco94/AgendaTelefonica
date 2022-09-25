const agendatelefonica = artifacts.require("Agenda");

module.exports = async function (deployer) {
  await deployer.deploy(agendatelefonica);
};

