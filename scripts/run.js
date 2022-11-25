const main = async () => {
    const web3 = require('web3');
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const slotMachineContractFactory = await hre.ethers.getContractFactory("SlotMachine");
    const slotMachineContract = await slotMachineContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.5"),
    });
    let contractBalance = await hre.ethers.provider.getBalance(
      slotMachineContract.address
    );
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    let ownerBalance = await hre.ethers.provider.getBalance(owner.address);

    console.log(
      "Owner balance:",
      hre.ethers.utils.formatEther(ownerBalance)
    );

    await slotMachineContract.deployed();
    console.log("Contract deployed to:", slotMachineContract.address);
    console.log("Owner of the contract:", owner.address);

    const randNums = await slotMachineContract.play(web3.utils.toWei("0.1", 'ether'));
    await randNums.wait();

    contractBalance = await hre.ethers.provider.getBalance(slotMachineContract.address);
    ownerBalance = await hre.ethers.provider.getBalance(owner.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0); // exit Node process without error
    } catch (error) {
      console.log(error);
      process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
  };
  
  runMain();