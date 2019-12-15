pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {
// The address of the adoption contract to be tested
 SupplyChain supplychain = SupplyChain(DeployedAddresses.SupplyChain());

// The supplies
 string expectedSupplier = "NZ Farmer 1";
 string supply1_Name = "Milk";
 string supply1_ID = "milk88888888";
 string supply2_Name = "Sugar";
 string supply2_ID = "sugar88888888";

//The products
string product1_Name = "Whey Protein";
string product1_ID = "WP12345678";
string expectedProducer = "OptimumNutrition";

// Testing the uploadSupply() function
function testUserCanUploadSupply() public {
  string memory s1 = supplychain.uploadSupply(expectedSupplier, supply1_Name, supply1_ID);
  string memory s2 = supplychain.uploadSupply(expectedSupplier, supply2_Name, supply2_ID);

  Assert.equal(s1, supply1_Name, "S1 does not match!");
  Assert.equal(s2, supply2_Name, "S2 does not match!");
}

// Testing the assignPart() function
function testUserCanAssignPart() public {
  string memory p1 = supplychain.assignPart(expectedProducer, supply1_ID, product1_Name, product1_ID);
  p1 = supplychain.assignPart(expectedProducer, supply2_ID, product1_Name, product1_ID);

  Assert.equal(p1, product1_Name, "p1 does not match!");
}

// Testing assignPart() overwrite
function testTotalComponents() public {

  uint supplyN = supplychain.getTotalSupply();
  uint productN = supplychain.getTotalProduct();
  uint componentN = supplychain.getTotalComponents(product1_ID);

  Assert.equal(supplyN,2,"supply # does not match!");
  Assert.equal(productN,1,"product # does not match!");
  Assert.equal(componentN,2,"component # does not match!");
}

function testGetProductInfo() public {
  string memory Pname;
  string memory Pername;
  uint number;
  string[] memory SID;
  string[] memory Sname;
  string[] memory Sername;

  (Pname, Pername, number, SID, Sname, Sername) = supplychain.getProductInfo(product1_ID);

  // string memory s1 = Sname[0];
  // string memory s2 = Sname[1];

  Assert.equal(Pname,product1_Name,"Pname does not match!");
  Assert.equal(Pername,expectedProducer,"Pername does not match!");
  Assert.equal(number,2,"number does not match!");
  Assert.equal(SID[0],supply1_ID,"sid1 does not match!");
  Assert.equal(SID[1],supply2_ID,"sid2 does not match!");
  Assert.equal(Sname[0],supply1_Name,"s1 does not match!");
  Assert.equal(Sname[1],supply2_Name,"s2 does not match!");
  Assert.equal(Sername[0],expectedSupplier,"s2 does not match!");
  Assert.equal(Sername[1],expectedSupplier,"s2 does not match!");

}

}

