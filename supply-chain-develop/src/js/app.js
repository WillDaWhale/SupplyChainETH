App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
    // $.getJSON('../pets.json', function(data) {
    //   var petsRow = $('#petsRow');
    //   var petTemplate = $('#petTemplate');

    //   for (i = 0; i < data.length; i ++) {
    //     petTemplate.find('.panel-title').text(data[i].name);
    //     petTemplate.find('img').attr('src', data[i].picture);
    //     petTemplate.find('.pet-breed').text(data[i].breed);
    //     petTemplate.find('.pet-age').text(data[i].age);
    //     petTemplate.find('.pet-location').text(data[i].location);
    //     petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

    //     petsRow.append(petTemplate.html());
    //   }
    // });

    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('SupplyChain.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var SupplyChainArtifact = data;
      App.contracts.SupplyChain = TruffleContract(SupplyChainArtifact);
    
      // Set the provider for our contract
      App.contracts.SupplyChain.setProvider(App.web3Provider);
    
      // Use our contract to retrieve and mark the adopted pets
      // return App.markAdopted();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-supplier', App.handleSupply);
    $(document).on('click', '.btn-producer', App.handleAssign);
    $(document).on('click', '.btn-consumer', App.handleSearch);
  },

  // markAdopted: function(adopters, account) {
  //   var adoptionInstance;

  //   App.contracts.Adoption.deployed().then(function(instance) {
  //     adoptionInstance = instance;
    
  //     return adoptionInstance.getAdopters.call();
  //   }).then(function(adopters) {
  //     for (i = 0; i < adopters.length; i++) {
  //       if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
  //         $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
  //       }
  //     }
  //   }).catch(function(err) {
  //     console.log(err.message);
  //   });
  // },

  handleSupply: function(event) {
    event.preventDefault();

    // var petId = parseInt($(event.target).data('id'));
    var supplier = document.getElementById('supplier').value;
    var supplyID = document.getElementById('supplyid').value;;
    var supply = document.getElementById('supplyDes').value;

    var SupplyChainInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.SupplyChain.deployed().then(function(instance) {
        SupplyChainInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return SupplyChainInstance.uploadSupply(supplier,supply,supplyID,{from: account});
      }).then(function(){
        $('.supply-panel').find('button').text('"'+ supplyID + '" is successfully uploaded. Click to create another one!');
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },
  
  handleAssign: function(event) {
    event.preventDefault();

    // var petId = parseInt($(event.target).data('id'));
    var producer = document.getElementById('producer').value;
    var componentid = document.getElementById('componentid').value;;
    var productid = document.getElementById('productid').value;
    var productdes = document.getElementById('productdes').value;


    // $('.consumer-panel').find('button').text(producer + componentid + productid + productdes);
    var SupplyChainInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.SupplyChain.deployed().then(function(instance) {
        SupplyChainInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return SupplyChainInstance.assignPart(producer,componentid,productdes,productid,{from: account});
      }).then(function(){
        $('.producer-panel').find('button').text('"'+ productid + '" is successfully assigned. Click to do another one!');
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleSearch: function(event) {
    event.preventDefault();

    var productid4search = document.getElementById('trackid').value;
    var SupplyChainInstance;
    var searchResult;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
      // document.getElementById('name').innerHTML = (productid4search+"123");
      App.contracts.SupplyChain.deployed().then(function(instance) {
        SupplyChainInstance = instance;
        return searchResult = SupplyChainInstance.getProductInfo(productid4search);
      }).then(function(searchResult){
        // // $('.supply-panel').find('button').text('"'+ productid + '" is successfully assigned. Click to do another one!');
        document.getElementById('name').innerHTML = (productid4search);
        document.getElementById('description').innerHTML = (searchResult[0] + " / Total Components: " + searchResult[2]);
        document.getElementById('manufacturer').innerHTML = (searchResult[1]);
        // if (a[0] == ""){
        //   $('.consumer-panel').find('button').text("1");
        // }else if (a[0] == " "){
        //   $('.consumer-panel').find('button').text("2");
        // }else{
        //   $('.consumer-panel').find('button').text(a[0]);
        // }
        document.getElementById('location').innerHTML = (searchResult[3]+"/"+searchResult[5]);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
